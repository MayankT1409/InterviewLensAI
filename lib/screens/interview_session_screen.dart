import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterviewSessionScreen extends StatefulWidget {
  const InterviewSessionScreen({super.key});

  @override
  State<InterviewSessionScreen> createState() => _InterviewSessionScreenState();
}

class _InterviewSessionScreenState extends State<InterviewSessionScreen> {
  CameraController? _cameraController;
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (status.isGranted && micStatus.isGranted) {
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // Use front camera if available
          final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

          _cameraController = CameraController(
            frontCamera,
            ResolutionPreset.medium,
            enableAudio: true,
          );

          await _cameraController!.initialize();
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      } catch (e) {
        debugPrint('Camera initialization failed: $e');
      }
    } else {
      debugPrint('Permissions not granted');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Camera View
          Positioned.fill(
            child: _isCameraOn
                ? CameraPreview(_cameraController!)
                : Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off_outlined,
                            size: 64,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Camera Off',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
          
          // Question Overlay
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                   Text(
                    'Question 1 of 5',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                   ),
                   const SizedBox(height: 8),
                   Text(
                    'Tell me about a time you faced a difficult challenge at work.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                   ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlBtn(
                  icon: _isMicOn ? Icons.mic : Icons.mic_off,
                  onPressed: () => setState(() => _isMicOn = !_isMicOn),
                ),
                
                // End Call Button
                GestureDetector(
                    onTap: () async {
                         // Generative AI Feedback Flow
                         showDialog(
                           context: context,
                           barrierDismissible: false,
                           builder: (context) => const Center(
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 CircularProgressIndicator(color: Colors.white),
                                 SizedBox(height: 16),
                                 Text('Generating AI Feedback...', style: TextStyle(color: Colors.white)),
                               ],
                             ),
                           ),
                         );

                           try {
                           final aiService = AIService();
                           final feedback = await aiService.generateFeedback('session_mock_id');
                           
                           // Save to history
                           final user = FirebaseAuth.instance.currentUser;
                           if (user != null) {
                              final firestoreService = FirestoreService();
                              await firestoreService.saveInterviewFeedback(feedback, user.uid);
                           }

                           if (context.mounted) {
                             Navigator.pop(context); // Dismiss loading
                             Navigator.pushReplacementNamed(context, '/feedback', arguments: feedback);
                           }
                         } catch (e) {
                           if (context.mounted) {
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                             Navigator.pushReplacementNamed(context, '/dashboard');
                           }
                         }
                    },
                    child: Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                            color: Colors.red[500],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha:0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                                offset: const Offset(0, 4),
                              )
                            ]
                        ),
                        child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                    ),
                ),
                
                _buildControlBtn(
                  icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                  onPressed: () {
                    // Toggle preview only for now, controller doesn't support 'pause' easily without dispose usually
                    // But for UI toggle:
                    setState(() => _isCameraOn = !_isCameraOn);
                    if (_isCameraOn) {
                      _cameraController?.resumePreview();
                    } else {
                      _cameraController?.pausePreview();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildControlBtn({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: 28,
        onPressed: onPressed,
      ),
    );
  }
}
