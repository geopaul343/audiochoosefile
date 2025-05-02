
import 'package:audiochoosefil/screens/signin_screen.dart';
import 'package:audiochoosefil/screens/upload_success_screen.dart';
import 'package:audiochoosefil/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChooseFile extends StatefulWidget {
  final Function(File) onFileSelected;

  const ChooseFile({
    super.key,
    required this.onFileSelected,
  });

  @override
  State<ChooseFile> createState() => _ChooseFileState();
}

class _ChooseFileState extends State<ChooseFile> {
  String? _selectedFilePath;
  bool _isProcessing = false;
  final AudioService _audioService = AudioService();

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav'],
        allowMultiple: false,
        withData: true,
        withReadStream: true,
        dialogTitle: 'Select WAV File',
        allowCompression: false,
        onFileLoading: (FilePickerStatus status) {
          if (status == FilePickerStatus.picking) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please select a WAV file"),
                backgroundColor: Colors.blue,
              ),
            );
          }
        },
      );

      if (result != null) {
        final file = result.files.single;
        if (file.extension?.toLowerCase() == 'wav') {
          setState(() {
            _selectedFilePath = file.path;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("WAV file selected successfully"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please select only WAV files"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error selecting file: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processFile() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a file first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final result =
          await _audioService.uploadAudioFile(File(_selectedFilePath!));

      if (mounted) {
        // Navigate to success screen with the result
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UploadSuccessScreen(uploadResult: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error processing file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose File'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(title: 'Sign In'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Select Your WAV File',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Only WAV files are supported',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Selected: ${_selectedFilePath!.split('/').last}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickAudioFile,
                    icon: const Icon(Icons.file_upload),
                    label: const Text(
                      'Select WAV File',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _processFile,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.play_arrow),
                      label: Text(
                        _isProcessing ? 'Processing...' : 'Process File',
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
