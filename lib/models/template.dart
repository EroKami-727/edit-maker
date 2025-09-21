// lib/models/template.dart
import 'package:json_annotation/json_annotation.dart';
import 'placeholder.dart';

part 'template.g.dart';

@JsonSerializable()
class TemplateMetadata {
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final String aspectRatio;
  final int durationMs;
  final String difficulty;
  final String thumbnailUrl;
  final int estimatedRenderTimeMs;

  const TemplateMetadata({
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.aspectRatio,
    required this.durationMs,
    this.difficulty = 'easy',
    required this.thumbnailUrl,
    this.estimatedRenderTimeMs = 30000,
  });

  factory TemplateMetadata.fromJson(Map<String, dynamic> json) =>
      _$TemplateMetadataFromJson(json);
  
  Map<String, dynamic> toJson() => _$TemplateMetadataToJson(this);
}

@JsonSerializable()
class TimelineScene {
  final String id;
  final String name;
  final int startTime;
  final int endTime;
  final List<String> activePlaceholderIds;
  final Map<String, dynamic> sceneEffects;
  final String? backgroundMusic;
  final String? backgroundColor;

  const TimelineScene({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.activePlaceholderIds,
    this.sceneEffects = const {},
    this.backgroundMusic,
    this.backgroundColor,
  });

  int get duration => endTime - startTime;

  factory TimelineScene.fromJson(Map<String, dynamic> json) =>
      _$TimelineSceneFromJson(json);
  
  Map<String, dynamic> toJson() => _$TimelineSceneToJson(this);
}

@JsonSerializable()
class VideoTemplate {
  final String id;
  final TemplateMetadata metadata;
  final List<Placeholder> placeholders;
  final List<TimelineScene> timeline;
  final Map<String, dynamic> globalEffects;
  final String creatorId;
  final double price;
  final int downloadsCount;
  final double rating;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;
  final String version;

  const VideoTemplate({
    required this.id,
    required this.metadata,
    required this.placeholders,
    required this.timeline,
    this.globalEffects = const {},
    required this.creatorId,
    this.price = 0.0,
    this.downloadsCount = 0,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.version = '1.0.0',
  });

  // Helper getters
  bool get isFree => price == 0.0;
  bool get isPremium => price > 0.0;
  
  List<Placeholder> get requiredPlaceholders => 
      placeholders.where((p) => p.required).toList();
  
  List<Placeholder> get optionalPlaceholders => 
      placeholders.where((p) => !p.required).toList();

  // Get placeholders by type
  List<Placeholder> getPlaceholdersByType(PlaceholderType type) =>
      placeholders.where((p) => p.type == type).toList();

  // Validation
  bool isValid() {
    if (timeline.isEmpty) return false;
    
    final firstScene = timeline.first.startTime;
    final lastScene = timeline.last.endTime;
    
    return firstScene == 0 && lastScene == metadata.durationMs;
  }

  factory VideoTemplate.fromJson(Map<String, dynamic> json) =>
      _$VideoTemplateFromJson(json);
  
  Map<String, dynamic> toJson() => _$VideoTemplateToJson(this);

  // Helper methods for DateTime serialization
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
}