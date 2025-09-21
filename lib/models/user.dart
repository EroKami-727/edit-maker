// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final bool isCreator;
  final bool isPremium;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  final Map<String, dynamic> preferences;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.isCreator = false,
    this.isPremium = false,
    required this.createdAt,
    this.preferences = const {},
  });

  String get displayNameOrEmail => displayName ?? email;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Helper methods for DateTime serialization
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

  // Project and content models
}

enum ContentType {
  @JsonValue('image')
  image,
  @JsonValue('video') 
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('text')
  text
}

@JsonSerializable()
class UserContent {
  final String id;
  final String placeholderId;
  final ContentType type;
  final String? filePath;
  final String? url;
  final String? textContent;
  final Map<String, dynamic> metadata;
  @JsonKey(fromJson: User._dateTimeFromJson, toJson: User._dateTimeToJson)
  final DateTime uploadedAt;

  const UserContent({
    required this.id,
    required this.placeholderId,
    required this.type,
    this.filePath,
    this.url,
    this.textContent,
    this.metadata = const {},
    required this.uploadedAt,
  });

  bool get hasContent => 
      filePath != null || url != null || textContent != null;

  factory UserContent.fromJson(Map<String, dynamic> json) =>
      _$UserContentFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserContentToJson(this);
}

enum ProjectStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('error')
  error
}

@JsonSerializable()
class VideoProject {
  final String id;
  final String templateId;
  final String userId;
  final String title;
  final List<UserContent> userContent;
  final Map<String, dynamic> customizations;
  final ProjectStatus status;
  final String? outputPath;
  @JsonKey(fromJson: User._dateTimeFromJson, toJson: User._dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: User._dateTimeFromJson, toJson: User._dateTimeToJson)
  final DateTime updatedAt;
  final int renderProgressPercent;
  final String? errorMessage;

  const VideoProject({
    required this.id,
    required this.templateId,
    required this.userId,
    required this.title,
    this.userContent = const [],
    this.customizations = const {},
    this.status = ProjectStatus.draft,
    this.outputPath,
    required this.createdAt,
    required this.updatedAt,
    this.renderProgressPercent = 0,
    this.errorMessage,
  });

  // Helper methods
  bool get isCompleted => status == ProjectStatus.completed && outputPath != null;
  bool get hasErrors => status == ProjectStatus.error;
  bool get isProcessing => status == ProjectStatus.processing;

  factory VideoProject.fromJson(Map<String, dynamic> json) =>
      _$VideoProjectFromJson(json);
  
  Map<String, dynamic> toJson() => _$VideoProjectToJson(this);
}