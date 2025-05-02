import 'dart:io';
import 'package:audiochoosefil/screens/choosefilescreen.dart';
import 'package:audiochoosefil/services/auth_service.dart';
import 'package:audiochoosefil/services/audio_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final AudioService _audioService = AudioService();
  String? _idToken;
  File? _selectedFile;
  bool _isUploading = false;
  String? _uploadStatus;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _idToken = await _authService.getuserIdToken();
    if (_idToken != null) {
      await _authService.callProtectedApi(_idToken!);
    }
  }

  Future<void> _handleFileSelection(File file) async {
    setState(() {
      _selectedFile = file;
      _uploadStatus = null;
    });
  }

  Future<void> _uploadAudioFile() async {
    if (_selectedFile == null) {
      setState(() {
        _uploadStatus = 'Please select a file first';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Uploading...';
    });

    try {
      final result = await _audioService.uploadAudioFile(_selectedFile!);
      setState(() {
        _uploadStatus = 'Upload successful!';
        _isUploading = false;
      });
      // You might want to show the result in a dialog or navigate to a results screen
      print('Upload result: $result');
    } catch (e) {
      setState(() {
        _uploadStatus = 'Upload failed: ${e.toString()}';
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (user != null) ...[
              _buildInfoCard('User ID', user.uid),
              _buildInfoCard('Email', user.email ?? 'Not available'),
              _buildInfoCard('Display Name', user.displayName ?? 'Not set'),
              _buildInfoCard(
                  'Email Verified', user.emailVerified ? 'Yes' : 'No'),
              _buildInfoCard('Phone Number', user.phoneNumber ?? 'Not set'),
              _buildInfoCard('Last Sign In',
                  user.metadata.lastSignInTime?.toString() ?? 'Not available'),
            ] else
              const Center(
                child: Text('No user information available'),
              ),
            const SizedBox(height: 20),
            if (_selectedFile != null) ...[
              Text('Selected file: ${_selectedFile!.path.split('/').last}'),
              const SizedBox(height: 8),
            ],
            if (_uploadStatus != null) ...[
              Text(
                _uploadStatus!,
                style: TextStyle(
                  color: _uploadStatus!.contains('failed')
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseFile(
                                onFileSelected: _handleFileSelection,
                              ),
                            ),
                          );
                        },
                  child: const Text('Choose Audio File'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isUploading || _selectedFile == null
                      ? null
                      : _uploadAudioFile,
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Upload File'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
