// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placeholder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceholderConstraints _$PlaceholderConstraintsFromJson(
  Map<String, dynamic> json,
) => PlaceholderConstraints(
  aspectRatio: json['aspectRatio'] as String?,
  maxLength: (json['maxLength'] as num?)?.toInt(),
  dataType: json['dataType'] as String?,
  faceDetection: json['faceDetection'] as bool? ?? false,
  autoCenter: json['autoCenter'] as bool? ?? false,
  autoResize: json['autoResize'] as bool? ?? true,
  minWidth: (json['minWidth'] as num?)?.toDouble(),
  maxWidth: (json['maxWidth'] as num?)?.toDouble(),
  minHeight: (json['minHeight'] as num?)?.toDouble(),
  maxHeight: (json['maxHeight'] as num?)?.toDouble(),
  allowedFormats:
      (json['allowedFormats'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PlaceholderConstraintsToJson(
  PlaceholderConstraints instance,
) => <String, dynamic>{
  'aspectRatio': instance.aspectRatio,
  'maxLength': instance.maxLength,
  'dataType': instance.dataType,
  'faceDetection': instance.faceDetection,
  'autoCenter': instance.autoCenter,
  'autoResize': instance.autoResize,
  'minWidth': instance.minWidth,
  'maxWidth': instance.maxWidth,
  'minHeight': instance.minHeight,
  'maxHeight': instance.maxHeight,
  'allowedFormats': instance.allowedFormats,
};

PlaceholderPosition _$PlaceholderPositionFromJson(Map<String, dynamic> json) =>
    PlaceholderPosition(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      zIndex: (json['zIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PlaceholderPositionToJson(
  PlaceholderPosition instance,
) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
  'rotation': instance.rotation,
  'opacity': instance.opacity,
  'zIndex': instance.zIndex,
};

PlaceholderEffect _$PlaceholderEffectFromJson(Map<String, dynamic> json) =>
    PlaceholderEffect(
      type: $enumDecode(_$AnimationTypeEnumMap, json['type']),
      duration: (json['duration'] as num).toInt(),
      startTime: (json['startTime'] as num).toInt(),
      easing: json['easing'] as String? ?? 'ease',
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$PlaceholderEffectToJson(PlaceholderEffect instance) =>
    <String, dynamic>{
      'type': _$AnimationTypeEnumMap[instance.type]!,
      'duration': instance.duration,
      'startTime': instance.startTime,
      'easing': instance.easing,
      'properties': instance.properties,
    };

const _$AnimationTypeEnumMap = {
  AnimationType.fadeIn: 'fadeIn',
  AnimationType.fadeOut: 'fadeOut',
  AnimationType.slideIn: 'slideIn',
  AnimationType.slideOut: 'slideOut',
  AnimationType.zoom: 'zoom',
  AnimationType.rotate: 'rotate',
  AnimationType.bounce: 'bounce',
  AnimationType.countUp: 'countUp',
  AnimationType.typewriter: 'typewriter',
};

Placeholder _$PlaceholderFromJson(Map<String, dynamic> json) => Placeholder(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$PlaceholderTypeEnumMap, json['type']),
  position: PlaceholderPosition.fromJson(
    json['position'] as Map<String, dynamic>,
  ),
  constraints: json['constraints'] == null
      ? const PlaceholderConstraints()
      : PlaceholderConstraints.fromJson(
          json['constraints'] as Map<String, dynamic>,
        ),
  effects:
      (json['effects'] as List<dynamic>?)
          ?.map((e) => PlaceholderEffect.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  styling: json['styling'] as Map<String, dynamic>? ?? const {},
  defaultValue: json['defaultValue'] as String?,
  required: json['required'] as bool? ?? false,
  description: json['description'] as String?,
);

Map<String, dynamic> _$PlaceholderToJson(Placeholder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PlaceholderTypeEnumMap[instance.type]!,
      'position': instance.position,
      'constraints': instance.constraints,
      'effects': instance.effects,
      'styling': instance.styling,
      'defaultValue': instance.defaultValue,
      'required': instance.required,
      'description': instance.description,
    };

const _$PlaceholderTypeEnumMap = {
  PlaceholderType.image: 'image',
  PlaceholderType.video: 'video',
  PlaceholderType.text: 'text',
  PlaceholderType.audio: 'audio',
  PlaceholderType.logo: 'logo',
  PlaceholderType.qrCode: 'qrCode',
  PlaceholderType.socialHandle: 'socialHandle',
};
