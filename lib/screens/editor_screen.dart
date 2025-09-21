// lib/screens/editor_screen.dart
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:template_video_editor/models/template.dart';
import '../models/placeholder.dart' as ph;
import 'dart:math';

// Constants for our timeline UI
const double RULER_HEIGHT = 30.0;
const double PIXELS_PER_SECOND = 60.0; // Defines the zoom level of the timeline

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late VideoTemplate _template;
  late final MultiSplitViewController _verticalController;
  late final MultiSplitViewController _horizontalController;

  ph.Placeholder? _selectedPlaceholder;
  final TextEditingController _nameController = TextEditingController();
  
  // --- NEW TIMELINE STATE ---
  Duration _currentPlayheadPosition = Duration.zero;
  final ScrollController _timelineScrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _verticalController = MultiSplitViewController(areas: [Area(weight: 0.65), Area(weight: 0.35)]);
    _horizontalController = MultiSplitViewController(areas: [Area(weight: 0.25), Area(weight: 0.50), Area(weight: 0.25)]);
    _template = VideoTemplate(
      id: 'new_template_${DateTime.now().millisecondsSinceEpoch}',
      metadata: TemplateMetadata(title: 'Untitled Template', description: '', category: 'social', tags: [], aspectRatio: '16:9', durationMs: 30000, thumbnailUrl: ''),
      placeholders: [],
      timeline: [],
      creatorId: 'user_123',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void _addElementToTimeline(ph.PlaceholderType type) {
    final random = Random();
    final newId = 'ph_${type.name}_${random.nextInt(99999)}';
    final newPlaceholder = ph.Placeholder(id: newId, name: '${type.name.toUpperCase()} Placeholder', type: type, position: const ph.PlaceholderPosition(x: 0.3, y: 0.4, width: 0.4, height: 0.2));
    final newScene = TimelineScene(id: 'scene_for_$newId', name: '${type.name} Scene', startTime: _currentPlayheadPosition.inMilliseconds, endTime: _currentPlayheadPosition.inMilliseconds + 5000, activePlaceholderIds: [newId]);
    setState(() {
      _template.placeholders.add(newPlaceholder);
      _template.timeline.add(newScene);
      _selectPlaceholder(newPlaceholder);
    });
  }

  void _selectPlaceholder(ph.Placeholder? placeholder) {
    setState(() {
      _selectedPlaceholder = placeholder;
      if (placeholder != null) {
        _nameController.text = placeholder.name;
      } else {
        _nameController.clear();
      }
    });
  }

  void _updatePlaceholder(ph.Placeholder updatedPlaceholder) {
    final index = _template.placeholders.indexWhere((p) => p.id == updatedPlaceholder.id);
    if (index != -1) {
      setState(() {
        _template.placeholders[index] = updatedPlaceholder;
        _selectPlaceholder(updatedPlaceholder);
      });
    }
  }

  void _updateScene(TimelineScene updatedScene) {
    final index = _template.timeline.indexWhere((s) => s.id == updatedScene.id);
    if (index != -1) {
      setState(() {
        _template.timeline[index] = updatedScene;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timelineScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Template Creator: ${_template.metadata.title}'), actions: [
        TextButton.icon(onPressed: () { print(_template.toJson()); }, icon: const Icon(Icons.upload_file), label: const Text('Export Template'), style: TextButton.styleFrom(foregroundColor: Colors.white)),
        const SizedBox(width: 16),
      ]),
      body: MultiSplitViewTheme(
        data: MultiSplitViewThemeData(dividerThickness: 2.5, dividerPainter: DividerPainters.background(color: Theme.of(context).scaffoldBackgroundColor, highlightedColor: Colors.blueAccent)),
        child: MultiSplitView(axis: Axis.vertical, controller: _verticalController, children: [
          MultiSplitView(controller: _horizontalController, children: [_buildMediaPoolPanel(), _buildPreviewPanel(), _buildInspectorPanel()]),
          _buildTimelinePanel(),
        ]),
      ),
    );
  }

  Widget _buildMediaPoolPanel() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(toolbarHeight: 0, bottom: const TabBar(tabs: [Tab(icon: Icon(Icons.add_box_outlined), text: 'Add'), Tab(icon: Icon(Icons.folder_open_outlined), text: 'Media')])),
        body: TabBarView(children: [
          ListView(padding: const EdgeInsets.all(8), children: [
            _buildAddElementButton(icon: Icons.title, label: 'Add Text', onPressed: () => _addElementToTimeline(ph.PlaceholderType.text)),
            _buildAddElementButton(icon: Icons.image_outlined, label: 'Add Image', onPressed: () => _addElementToTimeline(ph.PlaceholderType.image)),
            _buildAddElementButton(icon: Icons.videocam_outlined, label: 'Add Video', onPressed: () => _addElementToTimeline(ph.PlaceholderType.video)),
          ]),
          const Center(child: Text("Imported media will appear here.")),
        ]),
      ),
    );
  }

  Widget _buildAddElementButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(color: Colors.grey.withOpacity(0.1), elevation: 0, child: InkWell(onTap: onPressed, child: Padding(padding: const EdgeInsets.all(12.0), child: Row(children: [Icon(icon), const SizedBox(width: 12), Text(label)]))));
  }

  Widget _buildPreviewPanel() {
    final parts = _template.metadata.aspectRatio.split(':');
    final aspectRatio = double.parse(parts[0]) / double.parse(parts[1]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = (constraints.maxHeight * aspectRatio < constraints.maxWidth) ? constraints.maxHeight * aspectRatio : constraints.maxWidth;
        final canvasHeight = canvasWidth / aspectRatio;

        return DragTarget<ph.Placeholder>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: _template.placeholders.map((placeholder) {
                        return _buildInteractivePlaceholder(
                          placeholder: placeholder,
                          canvasWidth: canvasWidth,
                          canvasHeight: canvasHeight,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInteractivePlaceholder({
    required ph.Placeholder placeholder,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    bool isSelected = _selectedPlaceholder?.id == placeholder.id;
    
    // Use Draggable for better performance and accurate cursor tracking
    return Draggable(
      data: placeholder,
      feedback: const SizedBox(), // The feedback is the widget that follows the cursor, we render it invisible
      onDragEnd: (details) {
        // Calculate new position based on where the drag ended
        final newX = (details.offset.dx - (canvasWidth * placeholder.position.width / 2)) / canvasWidth;
        final newY = (details.offset.dy - (canvasHeight * placeholder.position.height / 2)) / canvasHeight;

        final updatedPosition = placeholder.position.copyWith(x: newX, y: newY);
        _updatePlaceholder(placeholder.copyWith(position: updatedPosition));
      },
      child: Positioned(
        left: placeholder.position.x * canvasWidth,
        top: placeholder.position.y * canvasHeight,
        width: placeholder.position.width * canvasWidth,
        height: placeholder.position.height * canvasHeight,
        child: GestureDetector(
          onTap: () => _selectPlaceholder(placeholder),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent, width: 2)),
                child: Center(child: Text(placeholder.name, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12))),
              ),
              if (isSelected) ..._buildResizeHandles(placeholder, canvasWidth, canvasHeight),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles(ph.Placeholder placeholder, double canvasWidth, double canvasHeight) {
    const handleSize = 12.0;
    return [
      // Bottom-right
      Positioned(right: -handleSize / 2, bottom: -handleSize / 2, child: _buildResizeHandle(onPanUpdate: (details) {
        final newWidth = placeholder.position.width + (details.delta.dx / canvasWidth);
        final newHeight = placeholder.position.height + (details.delta.dy / canvasHeight);
        _updatePlaceholder(placeholder.copyWith(position: placeholder.position.copyWith(width: newWidth, height: newHeight)));
      })),
      // Top-left
      Positioned(left: -handleSize / 2, top: -handleSize / 2, child: _buildResizeHandle(onPanUpdate: (details) {
        final newX = placeholder.position.x + (details.delta.dx / canvasWidth);
        final newY = placeholder.position.y + (details.delta.dy / canvasHeight);
        final newWidth = placeholder.position.width - (details.delta.dx / canvasWidth);
        final newHeight = placeholder.position.height - (details.delta.dy / canvasHeight);
        _updatePlaceholder(placeholder.copyWith(position: placeholder.position.copyWith(x: newX, y: newY, width: newWidth, height: newHeight)));
      })),
      // Top-right
       Positioned(right: -handleSize / 2, top: -handleSize / 2, child: _buildResizeHandle(onPanUpdate: (details) {
        final newY = placeholder.position.y + (details.delta.dy / canvasHeight);
        final newWidth = placeholder.position.width + (details.delta.dx / canvasWidth);
        final newHeight = placeholder.position.height - (details.delta.dy / canvasHeight);
        _updatePlaceholder(placeholder.copyWith(position: placeholder.position.copyWith(y: newY, width: newWidth, height: newHeight)));
      })),
       // Bottom-left
       Positioned(left: -handleSize / 2, bottom: -handleSize / 2, child: _buildResizeHandle(onPanUpdate: (details) {
        final newX = placeholder.position.x + (details.delta.dx / canvasWidth);
        final newWidth = placeholder.position.width - (details.delta.dx / canvasWidth);
        final newHeight = placeholder.position.height + (details.delta.dy / canvasHeight);
        _updatePlaceholder(placeholder.copyWith(position: placeholder.position.copyWith(x: newX, width: newWidth, height: newHeight)));
      })),
    ];
  }

  Widget _buildResizeHandle({required Function(DragUpdateDetails) onPanUpdate}) {
    const handleSize = 12.0;
    return GestureDetector(onPanUpdate: onPanUpdate, child: MouseRegion(cursor: SystemMouseCursors.resizeUpLeftDownRight, child: Container(width: handleSize, height: handleSize, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.blueAccent, width: 1.5)))));
  }

  Widget _buildInspectorPanel() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Inspector', style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        if (_selectedPlaceholder == null)
          const Text('Select an element on the timeline.')
        else
          ListView(shrinkWrap: true, children: [
            Text('ID: ${_selectedPlaceholder!.id}', style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), onChanged: (newName) {
              if (_selectedPlaceholder != null) _updatePlaceholder(_selectedPlaceholder!.copyWith(name: newName));
            }),
            // TODO: Add more inspector fields for position, size, etc.
          ]),
      ]),
    );
  }

  Widget _buildTimelinePanel() {
    double totalTimelineWidth = _template.metadata.durationMs / 1000 * PIXELS_PER_SECOND;

    return SingleChildScrollView(
      controller: _timelineScrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: double.infinity,
        width: totalTimelineWidth,
        child: Stack(
          children: [
            // The background, ruler, and tracks
            Column(
              children: [
                _buildTimelineRuler(totalTimelineWidth),
                Expanded(child: _buildTimelineTracks()),
              ],
            ),
            // The playhead on top
            _buildPlayhead(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineRuler(double totalWidth) {
    return GestureDetector(
      onTapDown: (details) => _movePlayhead(details.localPosition.dx),
      onHorizontalDragUpdate: (details) => _movePlayhead(details.localPosition.dx),
      child: Container(
        width: totalWidth,
        height: RULER_HEIGHT,
        color: Colors.grey.withOpacity(0.1),
        child: CustomPaint(
          painter: TimelineRulerPainter(duration: Duration(milliseconds: _template.metadata.durationMs)),
        ),
      ),
    );
  }

  Widget _buildTimelineTracks() {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: _template.timeline.map((scene) {
          final placeholder = _template.placeholders.firstWhere((p) => p.id == scene.activePlaceholderIds.first);
          return Positioned(
            left: scene.startTime / 1000 * PIXELS_PER_SECOND,
            top: _template.timeline.indexOf(scene) * 45.0, // Basic layering for now
            child: _buildTimelineClip(scene, placeholder),
          );
        }).toList(),
      );
    });
  }

  Widget _buildTimelineClip(TimelineScene scene, ph.Placeholder placeholder) {
    bool isSelected = _selectedPlaceholder?.id == placeholder.id;
    double clipWidth = scene.duration / 1000 * PIXELS_PER_SECOND;

    return GestureDetector(
      onTap: () => _selectPlaceholder(placeholder),
      child: SizedBox(
        width: clipWidth,
        height: 40,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent.withOpacity(0.8) : Colors.blueGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
              ),
              child: Center(child: Text(placeholder.name, style: const TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ),
            // Left handle for trimming start time
            Positioned(left: 0, top: 0, bottom: 0, child: _buildClipHandle(onPanUpdate: (details) {
              int deltaMs = (details.delta.dx / PIXELS_PER_SECOND * 1000).round();
              if (scene.startTime + deltaMs < scene.endTime) {
                _updateScene(scene.copyWith(startTime: scene.startTime + deltaMs));
              }
            })),
            // Right handle for trimming end time
            Positioned(right: 0, top: 0, bottom: 0, child: _buildClipHandle(onPanUpdate: (details) {
              int deltaMs = (details.delta.dx / PIXELS_PER_SECOND * 1000).round();
               if (scene.endTime + deltaMs > scene.startTime) {
                _updateScene(scene.copyWith(endTime: scene.endTime + deltaMs));
              }
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildClipHandle({required Function(DragUpdateDetails) onPanUpdate}) {
    return GestureDetector(
      onHorizontalDragUpdate: onPanUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: Container(width: 8, color: Colors.white.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildPlayhead() {
    double playheadPosition = _currentPlayheadPosition.inMilliseconds / 1000 * PIXELS_PER_SECOND;
    return Positioned(
      left: playheadPosition,
      top: 0,
      bottom: 0,
      child: Container(width: 2, color: Colors.redAccent),
    );
  }

  void _movePlayhead(double localDx) {
    int newPositionMs = (localDx / PIXELS_PER_SECOND * 1000).round();
    setState(() {
      _currentPlayheadPosition = Duration(milliseconds: newPositionMs.clamp(0, _template.metadata.durationMs));
    });
  }
}

// A CustomPainter to draw the timeline ruler efficiently
class TimelineRulerPainter extends CustomPainter {
  final Duration duration;
  TimelineRulerPainter({required this.duration});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    int totalSeconds = duration.inSeconds;
    for (int i = 0; i <= totalSeconds; i++) {
      double x = i * PIXELS_PER_SECOND;
      
      // Draw main second tick
      canvas.drawLine(Offset(x, 0), Offset(x, size.height * 0.6), paint);

      // Draw second label
      textPainter.text = TextSpan(text: '$i' 's', style: const TextStyle(color: Colors.white54, fontSize: 10));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + 4, size.height - textPainter.height));

      // Draw sub-second ticks if there's enough space
      if (PIXELS_PER_SECOND > 40 && i < totalSeconds) {
        for (int j = 1; j < 4; j++) {
          double subX = x + j * PIXELS_PER_SECOND / 4;
          canvas.drawLine(Offset(subX, 0), Offset(subX, size.height * 0.2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// We need to add a copyWith to TimelineScene as well
extension TimelineSceneCopyWith on TimelineScene {
  TimelineScene copyWith({
    String? id,
    String? name,
    int? startTime,
    int? endTime,
  }) {
    return TimelineScene(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      activePlaceholderIds: this.activePlaceholderIds,
      sceneEffects: this.sceneEffects,
      backgroundMusic: this.backgroundMusic,
      backgroundColor: this.backgroundColor,
    );
  }
}