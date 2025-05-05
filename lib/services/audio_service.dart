import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AudioService {
  final Dio _dio = Dio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl =
      "https://app-audio-analyzer-887192895309.us-central1.run.app";

  Future<Map<String, dynamic>> uploadAudioFile(File audioFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Error: No user is currently signed in');
        throw Exception('User not authenticated');
      }

      final idToken = await user.getIdToken();

      final now = DateTime.now();
      final timestamp = formatDateToIso8601WithMilliseconds(now);
      final requestId = 'req_${now.millisecondsSinceEpoch}';

      // Read the audio file
      final bytes = await audioFile.readAsBytes();
      final Uint8List wavBytes = bytes.buffer.asUint8List();
      final base64Audio = base64Encode(wavBytes);

      // Print detailed information about the audio data
      // print('Audio file details:');
      // print('- File path: ${audioFile.path}');
      // print('- File size: ${bytes.length} bytes');
      // print('- Base64 length: ${base64Audio.length} characters');
      // print(
      //     '- Base64 preview (first 100 chars): ${base64Audio.substring(0, 100)}...');
      // print(
      //     '- Base64 preview (last 100 chars): ...${base64Audio.substring(base64Audio.length - 100)}');

      // Prepare the request payload
      final jsonPayload = {
        "requestId": requestId,
        "timestamp": timestamp,
        "audioType": "heart", // You might want to make this dynamic
        "metadata": {
          "device": {
            "model": "Flutter App Device",
            "osVersion": Platform.operatingSystemVersion
          },
          "app": {"id": "Digital Steth", "version": "2.1.0"}
        },
        "audioData": {"format": "wav", "content": base64Audio}
      };

      print('Sending request to: $_baseUrl/predict-test');
      if (idToken != null) {
        print(
            'Request headers: Authorization: Bearer ${idToken.substring(0, 20)}...');
      } else {
        print('Warning: ID Token is null');
      }

      // Send the request
      final response = await _dio.post(
        '$_baseUrl/predict-test',
        data: jsonPayload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return response.data;
      } else {
        print('Error response: ${response.statusMessage}');
        throw Exception('Failed to upload audio: ${response.statusMessage}');
      }
    } catch (e) {
      print('Exception during upload: $e');
      throw Exception('Error uploading audio: $e');
    }
  }
}

String formatDateToIso8601WithMilliseconds(DateTime dateTime) {
  return dateTime.toUtc().toIso8601String().replaceFirstMapped(
          RegExp(r'\.\d+'), (match) => '.${match.group(0)!.substring(1, 7)}') +
      'Z';
}
