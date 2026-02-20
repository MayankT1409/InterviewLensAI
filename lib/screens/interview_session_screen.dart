import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  
  final List<String> _questions = [
    'Tell me about a time you faced a difficult challenge at work.',
    'Explain the concept of Object-Oriented Programming.',
    'Where do you see yourself in 5 years?'
  ];
  int _currentQuestionIndex = 0;
  final StringBuffer _fullTranscript = StringBuffer();

  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeCamera();
    _initSpeech();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (status.isGranted && micStatus.isGranted) {
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
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
    }
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
        }),
      );
    }
  }

  void _nextQuestion() {
    // Save current Q&A
    _fullTranscript.writeln("Question: ${_questions[_currentQuestionIndex]}");
    _fullTranscript.writeln("Answer: $_text");
    _fullTranscript.writeln("-" * 20);

    // Reset for next
    setState(() {
      _currentQuestionIndex++;
      _text = ''; 
    });
    
    // Restart listening to clear buffer
    _speech.stop();
    Future.delayed(const Duration(milliseconds: 100), () {
      _speech.listen(onResult: (val) => setState(() {
          _text = val.recognizedWords;
      }));
    });
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
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              // 1. Virtual AI Interviewer
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.indigo.shade900, Colors.black],
                    ),
                    border: const Border(bottom: BorderSide(color: Colors.white24, width: 1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blueAccent, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withValues(alpha:0.3), blurRadius: 20, spreadRadius: 5),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.smart_toy_rounded, size: 50, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 16),
                       Text(
                        'AI Interviewer',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                       Text(
                        _isListening ? 'Listening...' : 'Thinking...',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. User Camera & Overlay
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _isCameraOn
                          ? CameraPreview(_cameraController!)
                          : Container(
                              color: Colors.grey[900], 
                              child: const Center(child: Text('Camera Off', style: TextStyle(color: Colors.grey)))
                            ),
                      ),
                      
                      // Question Overlay
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                                style: TextStyle(color: Colors.blue[200], fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _questions[_currentQuestionIndex],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Transcript
                      if (_text.isNotEmpty)
                      Positioned(
                        bottom: 100,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _text,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Controls
          if (!_isAnalyzing)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlBtn(
                    icon: _isMicOn ? Icons.mic : Icons.mic_off,
                    onPressed: () {
                      setState(() => _isMicOn = !_isMicOn);
                      if (_isMicOn) {
                         _speech.listen(onResult: (val) => setState(() => _text = val.recognizedWords));
                      } else {
                         _speech.stop();
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  
                  // Next / End Button
                  GestureDetector(
                    onTap: () {
                      if (_currentQuestionIndex < _questions.length - 1) {
                        _nextQuestion();
                      } else {
                        _onEndCall();
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                            color: _currentQuestionIndex < _questions.length - 1 ? Colors.blue[600] : Colors.red[600],
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: (_currentQuestionIndex < _questions.length - 1 ? Colors.blue : Colors.red).withValues(alpha:0.5),
                                blurRadius: 15, spreadRadius: 2,
                              )
                            ]
                        ),
                        child: Text(
                          _currentQuestionIndex < _questions.length - 1 ? "Next Question" : "End Interview",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                    ),
                  ),

                  const SizedBox(width: 24),
                  _buildControlBtn(
                    icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                    onPressed: () {
                      setState(() => _isCameraOn = !_isCameraOn);
                      if (_isCameraOn) _cameraController?.resumePreview();
                      else _cameraController?.pausePreview();
                    },
                  ),
                ],
              ),
            ),

          // 4. Loading Overlay
          if (_isAnalyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80, width: 80, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)),
                    const SizedBox(height: 48),
                    Text('AI is Analyzing Session...', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    Text('Evaluating all responses...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onEndCall() async {
     setState(() => _isAnalyzing = true);
     _speech.stop();
     
     // Add final answer
     _fullTranscript.writeln("Question: ${_questions[_currentQuestionIndex]}");
     _fullTranscript.writeln("Answer: $_text");
     
     try {
       final aiService = AIService();
       final fullSessionData = _fullTranscript.toString();
       
       // Pass "Full Session" as topic, and transcript as answer
       final feedback = await aiService.generateFeedback("Full Session Interview", fullSessionData);
       
       final user = FirebaseAuth.instance.currentUser;
       final firestoreService = FirestoreService();

       if (user != null) {
           await firestoreService.saveInterviewFeedback(feedback, user.uid);
       }

       // Mark request as completed if requestId is present
       final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
       if (args != null && args['requestId'] != null) {
         final requestId = args['requestId'];
         debugPrint('Marking request $requestId as completed');
         await firestoreService.updateRequestStatus(requestId, 'completed');
       }

       if (mounted) {
         Navigator.pushReplacementNamed(context, '/feedback', arguments: feedback);
       }
     } catch (e) {
       debugPrint('Error in _onEndCall: $e');
       if (mounted) {
         setState(() => _isAnalyzing = false);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
         Navigator.pop(context); 
       }
     }
  }

  Widget _buildControlBtn({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.1),
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
