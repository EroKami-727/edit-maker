// lib/services/template_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/template.dart';
import '../models/placeholder.dart';

class TemplateService {
  static final TemplateService _instance = TemplateService._internal();
  factory TemplateService() => _instance;
  TemplateService._internal();

  // Mock data - later this will come from Supabase
  List<VideoTemplate> _templates = [];
  bool _isInitialized = false;

  // Initialize with sample templates
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _templates = _createSampleTemplates();
    _isInitialized = true;
  }

  // Get all templates
  Future<List<VideoTemplate>> getAllTemplates() async {
    await initialize();
    return List.from(_templates);
  }

  // Get templates by category
  Future<List<VideoTemplate>> getTemplatesByCategory(String category) async {
    await initialize();
    return _templates.where((t) => t.metadata.category == category).toList();
  }

  // Get template by ID
  Future<VideoTemplate?> getTemplateById(String id) async {
    await initialize();
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search templates
  Future<List<VideoTemplate>> searchTemplates(String query) async {
    await initialize();
    final lowercaseQuery = query.toLowerCase();
    return _templates.where((t) =>
      t.metadata.title.toLowerCase().contains(lowercaseQuery) ||
      t.metadata.description.toLowerCase().contains(lowercaseQuery) ||
      t.metadata.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  // Get popular templates
  Future<List<VideoTemplate>> getPopularTemplates({int limit = 10}) async {
    await initialize();
    final sorted = List<VideoTemplate>.from(_templates);
    sorted.sort((a, b) => b.downloadsCount.compareTo(a.downloadsCount));
    return sorted.take(limit).toList();
  }

  // Get templates by difficulty
  Future<List<VideoTemplate>> getTemplatesByDifficulty(String difficulty) async {
    await initialize();
    return _templates.where((t) => t.metadata.difficulty == difficulty).toList();
  }

  // Create sample templates for demo
  List<VideoTemplate> _createSampleTemplates() {
    final now = DateTime.now();
    
    return [
      // Social Media Template
      VideoTemplate(
        id: 'social_promo_001',
        metadata: TemplateMetadata(
          title: 'Social Media Promo',
          description: 'Perfect for Instagram stories and TikTok videos. Eye-catching design with space for your product and call-to-action.',
          category: 'social',
          tags: ['instagram', 'tiktok', 'promo', 'modern'],
          aspectRatio: '9:16',
          durationMs: 15000, // 15 seconds
          difficulty: 'easy',
          thumbnailUrl: 'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400',
          estimatedRenderTimeMs: 20000,
        ),
        placeholders: [
          Placeholder(
            id: 'hero_image',
            name: 'Product Image',
            type: PlaceholderType.image,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.2, width: 0.8, height: 0.4
            ),
            constraints: const PlaceholderConstraints(
              aspectRatio: '1:1',
              autoCenter: true,
              allowedFormats: ['jpg', 'png', 'webp']
            ),
            effects: [
              const PlaceholderEffect(
                type: AnimationType.zoom,
                duration: 2000,
                startTime: 0,
                properties: {'scale': 1.1}
              )
            ],
            required: true,
            description: 'Upload your product photo here',
          ),
          Placeholder(
            id: 'title_text',
            name: 'Title Text',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.65, width: 0.8, height: 0.15
            ),
            constraints: const PlaceholderConstraints(
              maxLength: 50,
              dataType: 'text'
            ),
            styling: const {
              'fontSize': 24,
              'fontWeight': 'bold',
              'color': '#FFFFFF',
              'textAlign': 'center'
            },
            effects: [
              const PlaceholderEffect(
                type: AnimationType.slideIn,
                duration: 1000,
                startTime: 500,
              )
            ],
            required: true,
            defaultValue: 'Your Amazing Product',
            description: 'Enter your product title',
          ),
          Placeholder(
            id: 'cta_text',
            name: 'Call to Action',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.82, width: 0.8, height: 0.08
            ),
            constraints: const PlaceholderConstraints(
              maxLength: 30,
              dataType: 'text'
            ),
            styling: const {
              'fontSize': 16,
              'color': '#FFD700',
              'textAlign': 'center'
            },
            required: false,
            defaultValue: 'Shop Now!',
            description: 'Call to action text',
          ),
        ],
        timeline: [
          const TimelineScene(
            id: 'main_scene',
            name: 'Main',
            startTime: 0,
            endTime: 15000,
            activePlaceholderIds: ['hero_image', 'title_text', 'cta_text'],
            backgroundColor: '#1a1a1a'
          ),
        ],
        creatorId: 'system',
        price: 0.0,
        downloadsCount: 1250,
        rating: 4.8,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      // Business Template
      VideoTemplate(
        id: 'business_intro_001',
        metadata: TemplateMetadata(
          title: 'Business Introduction',
          description: 'Professional template for company introductions and team presentations.',
          category: 'business',
          tags: ['professional', 'corporate', 'intro', 'team'],
          aspectRatio: '16:9',
          durationMs: 30000, // 30 seconds
          difficulty: 'medium',
          thumbnailUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
        ),
        placeholders: [
          Placeholder(
            id: 'company_logo',
            name: 'Company Logo',
            type: PlaceholderType.logo,
            position: const PlaceholderPosition(
              x: 0.05, y: 0.05, width: 0.2, height: 0.15
            ),
            constraints: const PlaceholderConstraints(
              allowedFormats: ['png', 'svg'],
              autoResize: true
            ),
            required: true,
            description: 'Upload your company logo',
          ),
          Placeholder(
            id: 'company_name',
            name: 'Company Name',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.3, width: 0.8, height: 0.15
            ),
            styling: const {
              'fontSize': 48,
              'fontWeight': 'bold',
              'color': '#2563eb'
            },
            required: true,
            description: 'Enter your company name',
          ),
          Placeholder(
            id: 'tagline',
            name: 'Company Tagline',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.5, width: 0.8, height: 0.1
            ),
            constraints: const PlaceholderConstraints(
              maxLength: 80
            ),
            styling: const {
              'fontSize': 20,
              'color': '#64748b'
            },
            required: false,
            defaultValue: 'Your success is our mission',
          ),
        ],
        timeline: [
          const TimelineScene(
            id: 'intro',
            name: 'Introduction',
            startTime: 0,
            endTime: 30000,
            activePlaceholderIds: ['company_logo', 'company_name', 'tagline'],
            backgroundColor: '#ffffff'
          ),
        ],
        creatorId: 'system',
        price: 4.99,
        downloadsCount: 890,
        rating: 4.6,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),

      // Personal Template
      VideoTemplate(
        id: 'birthday_celebration_001',
        metadata: TemplateMetadata(
          title: 'Birthday Celebration',
          description: 'Fun and colorful template for birthday videos with photo montage.',
          category: 'personal',
          tags: ['birthday', 'celebration', 'family', 'fun'],
          aspectRatio: '1:1',
          durationMs: 20000, // 20 seconds
          difficulty: 'easy',
          thumbnailUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400',
        ),
        placeholders: [
          Placeholder(
            id: 'birthday_photo',
            name: 'Birthday Photo',
            type: PlaceholderType.image,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.1, width: 0.8, height: 0.6
            ),
            constraints: const PlaceholderConstraints(
              faceDetection: true,
              autoCenter: true
            ),
            effects: [
              const PlaceholderEffect(
                type: AnimationType.bounce,
                duration: 1500,
                startTime: 1000,
              )
            ],
            required: true,
            description: 'Upload the birthday person\'s photo',
          ),
          Placeholder(
            id: 'age_number',
            name: 'Age',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.75, y: 0.15, width: 0.2, height: 0.2
            ),
            constraints: const PlaceholderConstraints(
              maxLength: 3,
              dataType: 'number'
            ),
            styling: const {
              'fontSize': 72,
              'fontWeight': 'bold',
              'color': '#ff6b6b'
            },
            effects: [
              const PlaceholderEffect(
                type: AnimationType.countUp,
                duration: 2000,
                startTime: 2000,
              )
            ],
            required: true,
            description: 'Enter the age',
          ),
          Placeholder(
            id: 'birthday_message',
            name: 'Birthday Message',
            type: PlaceholderType.text,
            position: const PlaceholderPosition(
              x: 0.1, y: 0.75, width: 0.8, height: 0.15
            ),
            constraints: const PlaceholderConstraints(
              maxLength: 60
            ),
            styling: const {
              'fontSize': 18,
              'color': '#4ecdc4',
              'textAlign': 'center'
            },
            required: false,
            defaultValue: 'Happy Birthday! Hope your day is amazing!',
          ),
        ],
        timeline: [
          const TimelineScene(
            id: 'celebration',
            name: 'Celebration',
            startTime: 0,
            endTime: 20000,
            activePlaceholderIds: ['birthday_photo', 'age_number', 'birthday_message'],
            backgroundColor: '#fff9e6',
            sceneEffects: const {'confetti': true}
          ),
        ],
        creatorId: 'system',
        price: 0.0,
        downloadsCount: 2100,
        rating: 4.9,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Get categories with counts
  Future<Map<String, int>> getCategoryCounts() async {
    await initialize();
    final counts = <String, int>{};
    for (final template in _templates) {
      counts[template.metadata.category] = 
          (counts[template.metadata.category] ?? 0) + 1;
    }
    return counts;
  }

  // Save template (for template creation)
  Future<String> saveTemplate(VideoTemplate template) async {
    // In real app, this would save to Supabase
    _templates.add(template);
    return template.id;
  }

  // Update template
  Future<void> updateTemplate(VideoTemplate template) async {
    final index = _templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      _templates[index] = template;
    }
  }

  // Delete template
  Future<void> deleteTemplate(String id) async {
    _templates.removeWhere((t) => t.id == id);
  }
}