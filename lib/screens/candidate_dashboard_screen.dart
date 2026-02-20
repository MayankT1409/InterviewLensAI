import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/interview_request_model.dart';
import 'package:uuid/uuid.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CandidateDashboardScreen extends StatefulWidget {
  const CandidateDashboardScreen({super.key});

  @override
  State<CandidateDashboardScreen> createState() => _CandidateDashboardScreenState();
}

class _CandidateDashboardScreenState extends State<CandidateDashboardScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isRequesting = false;

  void _requestInterview() async {
    final messageController = TextEditingController();
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Interview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add a note for the interviewer (optional):'),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'e.g., Looking for Flutter Senior role',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );

    if (shouldSend != true) return;

    setState(() => _isRequesting = true);
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // Create Request
      // Using simple ID generation if uuid not available, or just timestamp
      final String requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';

      // We need user name. For now assume it's in a profile or Auth display name
      // Fetching fresh user profile might be better, but for speed using "Candidate" if null
      // Actually we can fetch user profile first.
      final userProfile = await _firestoreService.getUser(user.uid);
      final String candidateName = userProfile?.name ?? 'Candidate';

      final request = InterviewRequestModel(
        id: requestId,
        candidateId: user.uid,
        candidateName: candidateName,
        status: 'pending',
        createdAt: DateTime.now(),
        message: messageController.text.trim(),
      );

      await _firestoreService.createInterviewRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interview Request Sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  int _selectedIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: _selectedIndex == 0 ? AppBar(
        title: Text(
          'Candidate Dashboard',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
          ),
        ],
      ) : null, // Hide AppBar for other tabs as they have their own
      body: IndexedStack(
        index: _selectedIndex,
        children: [
           SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to practice?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 24),
                
                // --- Request Interview Card ---
                CustomCard(
                  onTap: _isRequesting ? null : _requestInterview,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.send_rounded, color: Colors.white, size: 40),
                          if (_isRequesting)
                            const SizedBox(
                              height: 24, 
                              width: 24, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Request Interview',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Send a request to an interviewer',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha:0.9),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // --- My Requests List ---
                Text(
                  'My Requests',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<InterviewRequestModel>>(
                  stream: user != null ? _firestoreService.getCandidateRequests(user.uid) : const Stream.empty(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final requests = snapshot.data!;
                    if (requests.isEmpty) {
                      return Text(
                        'No requests made yet.',
                        style: TextStyle(color: Colors.grey[500]),
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        Color statusColor = Colors.orange;
                        IconData statusIcon = Icons.access_time_rounded;
                        
                        if (req.status == 'accepted') {
                          statusColor = Colors.green;
                          statusIcon = Icons.check_circle_outline;
                        } else if (req.status == 'rejected') {
                          statusColor = Colors.red;
                          statusIcon = Icons.cancel_outlined;
                        } else if (req.status == 'completed') {
                          statusColor = Colors.blue;
                          statusIcon = Icons.task_alt;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomCard(
                            onTap: () {
                              if (req.status == 'accepted') {
                                Navigator.pushNamed(context, '/interview-session', arguments: req);
                              }
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: statusColor.withValues(alpha:0.1),
                                  child: Icon(statusIcon, color: statusColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req.status.toUpperCase(),
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Interviewer: ${req.interviewerName ?? "Waiting..."}',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (req.message != null && req.message!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            'Note: ${req.message}',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontStyle: FontStyle.italic,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      Text(
                                        req.createdAt.toString().split('.')[0], 
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (req.status == 'accepted')
                                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const HistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

