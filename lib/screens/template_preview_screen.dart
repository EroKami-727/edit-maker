// lib/screens/template_preview_screen.dart
import 'package:flutter/material.dart';
import '../models/placeholder.dart' as ph; // Using a prefix to avoid name clashes
import '../models/template.dart';

class TemplatePreviewScreen extends StatelessWidget {
  const TemplatePreviewScreen({super.key});

  // Helper to get an icon for each placeholder type
  IconData _getIconForPlaceholderType(ph.PlaceholderType type) {
    switch (type) {
      case ph.PlaceholderType.image:
        return Icons.image;
      case ph.PlaceholderType.video:
        return Icons.videocam;
      case ph.PlaceholderType.text:
        return Icons.title;
      case ph.PlaceholderType.audio:
        return Icons.audiotrack;
      case ph.PlaceholderType.logo:
        return Icons.business;
      case ph.PlaceholderType.qrCode:
        return Icons.qr_code;
      case ph.PlaceholderType.socialHandle:
        return Icons.alternate_email;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract the template passed from the browse screen
    final template = ModalRoute.of(context)!.settings.arguments as VideoTemplate;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                template.metadata.title,
                style: const TextStyle(
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
              background: Image.network(
                template.metadata.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.video_library, size: 60, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template.metadata.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: template.metadata.tags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Placeholders Section
                  Text(
                    'Required Content',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (template.placeholders.isEmpty)
                    const Text('This template does not require any content.')
                  else
                    ...template.placeholders.map((placeholder) => Card(
                      elevation: 0,
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          _getIconForPlaceholderType(placeholder.type),
                          color: Colors.blue[600],
                        ),
                        title: Text(
                          placeholder.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          placeholder.description ?? 'No description available.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: placeholder.required
                            ? const Text(
                                'Required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to the content upload/editing screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Next step: Content Upload!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Use This Template',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}