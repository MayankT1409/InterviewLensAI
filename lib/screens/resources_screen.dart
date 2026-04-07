import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/resource_model.dart';
import '../widgets/custom_card.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<ResourceModel>> _futureResources;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureResources = _apiService.fetchResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ResourceModel>>(
      future: _futureResources,
      builder: (context, snapshot) {
        // 1. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error Handling State
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to Connect',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Connection'),
                  )
                ],
              ),
            ),
          );
        }

        // 3. Empty Data State
        final resources = snapshot.data ?? [];
        if (resources.isEmpty) {
          return const Center(child: Text("No interview resources found."));
        }

        // 4. Success State Output
        return RefreshIndicator(
          onRefresh: () async {
            _loadData();
            await _futureResources;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              final item = resources[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.1),
                            child: const Icon(Icons.article_outlined, color: Colors.deepPurple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, height: 1.2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.body,
                        style: TextStyle(color: Colors.grey[700], height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Community Post #${item.id}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
