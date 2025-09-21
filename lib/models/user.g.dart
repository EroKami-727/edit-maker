// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isCreator: json['isCreator'] as bool? ?? false,
  isPremium: json['isPremium'] as bool? ?? false,
  createdAt: User._dateTimeFromJson(json['createdAt'] as String),
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'isCreator': instance.isCreator,
  'isPremium': instance.isPremium,
  'createdAt': User._dateTimeToJson(instance.createdAt),
  'preferences': instance.preferences,
};

UserContent _$UserContentFromJson(Map<String, dynamic> json) => UserContent(
  id: json['id'] as String,
  placeholderId: json['placeholderId'] as String,
  type: $enumDecode(_$ContentTypeEnumMap, json['type']),
  filePath: json['filePath'] as String?,
  url: json['url'] as String?,
  textContent: json['textContent'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  uploadedAt: User._dateTimeFromJson(json['uploadedAt'] as String),
);

Map<String, dynamic> _$UserContentToJson(UserContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeholderId': instance.placeholderId,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'filePath': instance.filePath,
      'url': instance.url,
      'textContent': instance.textContent,
      'metadata': instance.metadata,
      'uploadedAt': User._dateTimeToJson(instance.uploadedAt),
    };

const _$ContentTypeEnumMap = {
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.audio: 'audio',
  ContentType.text: 'text',
};

VideoProject _$VideoProjectFromJson(Map<String, dynamic> json) => VideoProject(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  userContent:
      (json['userContent'] as List<dynamic>?)
          ?.map((e) => UserContent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customizations: json['customizations'] as Map<String, dynamic>? ?? const {},
  status:
      $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
      ProjectStatus.draft,
  outputPath: json['outputPath'] as String?,
  createdAt: User._dateTimeFromJson(json['createdAt'] as String),
  updatedAt: User._dateTimeFromJson(json['updatedAt'] as String),
  renderProgressPercent: (json['renderProgressPercent'] as num?)?.toInt() ?? 0,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$VideoProjectToJson(VideoProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'templateId': instance.templateId,
      'userId': instance.userId,
      'title': instance.title,
      'userContent': instance.userContent,
      'customizations': instance.customizations,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'outputPath': instance.outputPath,
      'createdAt': User._dateTimeToJson(instance.createdAt),
      'updatedAt': User._dateTimeToJson(instance.updatedAt),
      'renderProgressPercent': instance.renderProgressPercent,
      'errorMessage': instance.errorMessage,
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.draft: 'draft',
  ProjectStatus.processing: 'processing',
  ProjectStatus.completed: 'completed',
  ProjectStatus.error: 'error',
};
