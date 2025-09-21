// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateMetadata _$TemplateMetadataFromJson(Map<String, dynamic> json) =>
    TemplateMetadata(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      aspectRatio: json['aspectRatio'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
      difficulty: json['difficulty'] as String? ?? 'easy',
      thumbnailUrl: json['thumbnailUrl'] as String,
      estimatedRenderTimeMs:
          (json['estimatedRenderTimeMs'] as num?)?.toInt() ?? 30000,
    );

Map<String, dynamic> _$TemplateMetadataToJson(TemplateMetadata instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'tags': instance.tags,
      'aspectRatio': instance.aspectRatio,
      'durationMs': instance.durationMs,
      'difficulty': instance.difficulty,
      'thumbnailUrl': instance.thumbnailUrl,
      'estimatedRenderTimeMs': instance.estimatedRenderTimeMs,
    };

TimelineScene _$TimelineSceneFromJson(Map<String, dynamic> json) =>
    TimelineScene(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      activePlaceholderIds: (json['activePlaceholderIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sceneEffects: json['sceneEffects'] as Map<String, dynamic>? ?? const {},
      backgroundMusic: json['backgroundMusic'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
    );

Map<String, dynamic> _$TimelineSceneToJson(TimelineScene instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'activePlaceholderIds': instance.activePlaceholderIds,
      'sceneEffects': instance.sceneEffects,
      'backgroundMusic': instance.backgroundMusic,
      'backgroundColor': instance.backgroundColor,
    };

VideoTemplate _$VideoTemplateFromJson(Map<String, dynamic> json) =>
    VideoTemplate(
      id: json['id'] as String,
      metadata: TemplateMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      placeholders: (json['placeholders'] as List<dynamic>)
          .map((e) => Placeholder.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => TimelineScene.fromJson(e as Map<String, dynamic>))
          .toList(),
      globalEffects: json['globalEffects'] as Map<String, dynamic>? ?? const {},
      creatorId: json['creatorId'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      downloadsCount: (json['downloadsCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: VideoTemplate._dateTimeFromJson(json['createdAt'] as String),
      updatedAt: VideoTemplate._dateTimeFromJson(json['updatedAt'] as String),
      version: json['version'] as String? ?? '1.0.0',
    );

Map<String, dynamic> _$VideoTemplateToJson(VideoTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'metadata': instance.metadata,
      'placeholders': instance.placeholders,
      'timeline': instance.timeline,
      'globalEffects': instance.globalEffects,
      'creatorId': instance.creatorId,
      'price': instance.price,
      'downloadsCount': instance.downloadsCount,
      'rating': instance.rating,
      'createdAt': VideoTemplate._dateTimeToJson(instance.createdAt),
      'updatedAt': VideoTemplate._dateTimeToJson(instance.updatedAt),
      'version': instance.version,
    };
