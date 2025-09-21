// lib/models/placeholder.dart
import 'package:json_annotation/json_annotation.dart';

part 'placeholder.g.dart';

enum PlaceholderType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('text')
  text,
  @JsonValue('audio')
  audio,
  @JsonValue('logo')
  logo,
  @JsonValue('qrCode')
  qrCode,
  @JsonValue('socialHandle')
  socialHandle
}

enum AnimationType {
  @JsonValue('fadeIn')
  fadeIn,
  @JsonValue('fadeOut')
  fadeOut,
  @JsonValue('slideIn')
  slideIn,
  @JsonValue('slideOut')
  slideOut,
  @JsonValue('zoom')
  zoom,
  @JsonValue('rotate')
  rotate,
  @JsonValue('bounce')
  bounce,
  @JsonValue('countUp')
  countUp,
  @JsonValue('typewriter')
  typewriter
}

@JsonSerializable()
class PlaceholderConstraints {
  final String? aspectRatio;
  final int? maxLength;
  final String? dataType;
  final bool faceDetection;
  final bool autoCenter;
  final bool autoResize;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final List<String> allowedFormats;

  const PlaceholderConstraints({
    this.aspectRatio,
    this.maxLength,
    this.dataType,
    this.faceDetection = false,
    this.autoCenter = false,
    this.autoResize = true,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.allowedFormats = const [],
  });

  factory PlaceholderConstraints.fromJson(Map<String, dynamic> json) =>
      _$PlaceholderConstraintsFromJson(json);
  
  Map<String, dynamic> toJson() => _$PlaceholderConstraintsToJson(this);
}

@JsonSerializable()
class PlaceholderPosition {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final double opacity;
  final int zIndex;

  const PlaceholderPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0,
    this.opacity = 1.0,
    this.zIndex = 0,
  });

  PlaceholderPosition copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    double? opacity,
    int? zIndex,
  }) {
    return PlaceholderPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
    );
  }

  factory PlaceholderPosition.fromJson(Map<String, dynamic> json) =>
      _$PlaceholderPositionFromJson(json);
  
  Map<String, dynamic> toJson() => _$PlaceholderPositionToJson(this);
}

@JsonSerializable()
class PlaceholderEffect {
  final AnimationType type;
  final int duration;
  final int startTime;
  final String easing;
  final Map<String, dynamic> properties;
  
  const PlaceholderEffect({
    required this.type,
    required this.duration,
    required this.startTime,
    this.easing = 'ease',
    this.properties = const {},
  });

  factory PlaceholderEffect.fromJson(Map<String, dynamic> json) =>
      _$PlaceholderEffectFromJson(json);
  
  Map<String, dynamic> toJson() => _$PlaceholderEffectToJson(this);
}

@JsonSerializable()
class Placeholder {
  final String id;
  final String name;
  final PlaceholderType type;
  final PlaceholderPosition position;
  final PlaceholderConstraints constraints;
  final List<PlaceholderEffect> effects;
  final Map<String, dynamic> styling;
  final String? defaultValue;
  final bool required;
  final String? description;

  const Placeholder({
    required this.id,
    required this.name,
    required this.type, // THE DUPLICATE LINE HAS BEEN REMOVED
    required this.position,
    this.constraints = const PlaceholderConstraints(),
    this.effects = const [],
    this.styling = const {},
    this.defaultValue,
    this.required = false,
    this.description,
  });

  Placeholder copyWith({
    String? id,
    String? name,
    PlaceholderType? type,
    PlaceholderPosition? position,
    PlaceholderConstraints? constraints,
    List<PlaceholderEffect>? effects,
    Map<String, dynamic>? styling,
    String? defaultValue,
    bool? required,
    String? description,
  }) {
    return Placeholder(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      position: position ?? this.position,
      constraints: constraints ?? this.constraints,
      effects: effects ?? this.effects,
      styling: styling ?? this.styling,
      defaultValue: defaultValue ?? this.defaultValue,
      required: required ?? this.required,
      description: description ?? this.description,
    );
  }

  bool accepts(String? value, String? fileExtension) {
    if (required && (value == null || value.isEmpty)) return false;
    
    if (constraints.maxLength != null && 
        value != null && 
        value.length > constraints.maxLength!) return false;
        
    if (constraints.allowedFormats.isNotEmpty && 
        fileExtension != null &&
        !constraints.allowedFormats.contains(fileExtension.toLowerCase())) {
      return false;
    }
    
    return true;
  }

  factory Placeholder.fromJson(Map<String, dynamic> json) =>
      _$PlaceholderFromJson(json);
  
  Map<String, dynamic> toJson() => _$PlaceholderToJson(this);
}