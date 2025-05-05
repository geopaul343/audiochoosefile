import 'package:flutter/material.dart';

class UploadSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> uploadResult;

  const UploadSuccessScreen({
    super.key,
    required this.uploadResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Successful'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withOpacity(0.1),
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
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 30),
                const Text(
                  'File Uploaded Successfully!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.green.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'Upload Details:',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       const SizedBox(height: 10),

                      
                //       Text('Request ID: ${uploadResult['requestId'] ?? 'N/A'}'),
                //       Text('Timestamp: ${uploadResult['timestamp'] ?? 'N/A'}'),
                //       if (uploadResult['result'] != null) ...[
                //         const SizedBox(height: 10),
                //         const Text(
                //           'Analysis Result:',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         const SizedBox(height: 5),
                //         Text(uploadResult['result'].toString()),
                //       ],
                //     ],
                //   ),
                // ),





              Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.green.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Upload Details:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),

      Text('Request ID: ${uploadResult['requestId'] ?? 'N/A'}'),
      Text('Timestamp: ${uploadResult['timestamp'] ?? 'N/A'}'),
      Text('Message: ${uploadResult['message'] ?? 'N/A'}'),
      Text('Status: ${uploadResult['status'] ?? 'N/A'}'),

      if (uploadResult['prediction'] != null) ...[
        const SizedBox(height: 10),
        const Text(
          'Analysis Result:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text('Class: ${uploadResult['prediction']['className'] ?? 'N/A'}'),
        Text(
          'Confidence: ${(double.tryParse(uploadResult['prediction']['confidence'].toString()) ?? 0.0).toStringAsFixed(2)}',
        ),
      ],
    ],
  ),
),

                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
