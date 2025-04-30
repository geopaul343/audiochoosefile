import 'package:audiochoosefil/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class ChooseFile extends StatefulWidget {
  const ChooseFile({super.key});

  @override
  State<ChooseFile> createState() => _ChooseFileState();
}

class _ChooseFileState extends State<ChooseFile> {
  String? _selectedFilePath;

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
        const SnackBar(
          content: Text("Please select a valid WAV file"),
          backgroundColor: Colors.red,
        ),
      );
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
                    builder: (context) => SignInScreen(title: 'Sign In'),
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
                    onPressed: _pickAudioFile,
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
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedFilePath != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Processing WAV file..."),
                            backgroundColor: Colors.green,

                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a WAV file first"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'Process File',
                      style: TextStyle(fontSize: 18),
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
            ),
          ),
        ),
      ),
    );
  }
}


// // Dummy SignInScreen class for reference


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
// import 'package:logging/logging.dart';

// class ChooseFile extends StatefulWidget {
//   final String idToken;

//   const ChooseFile({super.key, required this.idToken});

//   @override
//   State<ChooseFile> createState() => _ChooseFileState();
// }

// class _ChooseFileState extends State<ChooseFile> {
//   final _logger = Logger('ChooseFile');
//   List<String> files = [];
//   bool isLoading = false;
//   String? errorMessage;
//   String? _selectedFilePath;
//   bool isServerConnected = false;

//   // API configuration
//   static const String baseUrl = 'http://127.0.0.1:3001';

//   @override
//   void initState() {
//     super.initState();
//     checkServerConnection();
//   }

//   Future<void> checkServerConnection() async {
//     try {
//       final response = await http
//           .get(Uri.parse('$baseUrl/'))
//           .timeout(const Duration(seconds: 5));
//       setState(() {
//         isServerConnected = response.statusCode == 200;
//         if (isServerConnected) {
//           fetchFiles();
//         } else {
//           errorMessage = 'Server is not responding properly';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isServerConnected = false;
//         errorMessage = 'Cannot connect to server: $e';
//       });
//     }
//   }

//   Future<void> fetchFiles() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       print('Attempting to connect to server...');
//       final response = await http.post(
//         Uri.parse(
//           'http://10.0.2.2:3001/list-files',
//         ), // Use 10.0.2.2 for Android emulator
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'idToken': widget.idToken}),
//       );

//       print('Server response status: ${response.statusCode}');
//       print('Server response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           files = List<String>.from(data['files']);
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Server error: ${response.body}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Connection error: $e');
//       setState(() {
//         errorMessage =
//             'Connection error: $e\n\nPlease make sure the Python server is running on port 3001';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _pickAudioFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['wav'],
//         allowMultiple: false,
//         withData: true,
//         withReadStream: true,
//         dialogTitle: 'Select WAV File',
//         allowCompression: false,
//       );

//       if (result != null) {
//         final file = result.files.single;
//         if (file.extension?.toLowerCase() == 'wav') {
//           setState(() {
//             _selectedFilePath = file.path;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("WAV file selected successfully"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Please select only WAV files"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select a valid WAV file"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose File'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(
//               isServerConnected ? Icons.cloud_done : Icons.cloud_off,
//               color: isServerConnected ? Colors.green : Colors.red,
//             ),
//             onPressed: checkServerConnection,
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Theme.of(context).colorScheme.primary.withOpacity(0.1),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               if (!isServerConnected)
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_outline, color: Colors.red),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           errorMessage ?? 'Server connection error',
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: checkServerConnection,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               // Upload Section
//               Container(
//                 width: double.infinity,
//                 height: 60,
//                 margin: const EdgeInsets.symmetric(vertical: 20),
//                 child: ElevatedButton.icon(
//                   onPressed: _pickAudioFile,
//                   icon: const Icon(Icons.file_upload),
//                   label: const Text(
//                     'Upload WAV File',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 5,
//                   ),
//                 ),
//               ),
//               if (_selectedFilePath != null)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     "Selected: ${_selectedFilePath!.split('/').last}",
//                     style: const TextStyle(fontSize: 16, color: Colors.blue),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),

//               // Files List Section
//               const Text(
//                 'Available Files',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child:
//                     isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : errorMessage != null
//                         ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(errorMessage!),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   _logger.severe(
//                                     'Error message: $errorMessage',
//                                   );
//                                 },
//                                 child: const Text('Log Error'),
//                               ),
//                             ],
//                           ),
//                         )
//                         : files.isEmpty
//                         ? const Center(child: Text('No files found'))
//                         : ListView.builder(
//                           itemCount: files.length,
//                           itemBuilder: (context, index) {
//                             return Card(
//                               margin: const EdgeInsets.symmetric(
//                                 vertical: 5,
//                                 horizontal: 0,
//                               ),
//                               child: ListTile(
//                                 leading: const Icon(Icons.audio_file),
//                                 title: Text(files[index]),
//                                 onTap: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Selected: ${files[index]}',
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


