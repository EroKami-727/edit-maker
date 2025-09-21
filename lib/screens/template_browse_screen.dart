// lib/screens/template_browse_screen.dart
import 'package:flutter/material.dart';
import '../models/template.dart';
import '../services/template_service.dart';
import '../widgets/template_card.dart';

class TemplateBrowseScreen extends StatefulWidget {
  const TemplateBrowseScreen({super.key});

  @override
  State<TemplateBrowseScreen> createState() => _TemplateBrowseScreenState();
}

class _TemplateBrowseScreenState extends State<TemplateBrowseScreen> {
  final TemplateService _templateService = TemplateService();
  final TextEditingController _searchController = TextEditingController();
  
  List<VideoTemplate> _allTemplates = [];
  List<VideoTemplate> _filteredTemplates = [];
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';
  bool _isLoading = true;
  
  final List<String> _categories = ['all', 'social', 'business', 'personal', 'events'];
  final List<String> _difficulties = ['all', 'easy', 'medium', 'hard'];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() => _isLoading = true);
    
    try {
      final templates = await _templateService.getAllTemplates();
      setState(() {
        _allTemplates = templates;
        _filteredTemplates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load templates: $e');
    }
  }

  void _filterTemplates() {
    List<VideoTemplate> filtered = _allTemplates;

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((template) =>
        template.metadata.title.toLowerCase().contains(query) ||
        template.metadata.description.toLowerCase().contains(query) ||
        template.metadata.tags.any((tag) => tag.toLowerCase().contains(query))
      ).toList();
    }

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((template) =>
        template.metadata.category == _selectedCategory
      ).toList();
    }

    // Filter by difficulty
    if (_selectedDifficulty != 'all') {
      filtered = filtered.where((template) =>
        template.metadata.difficulty == _selectedDifficulty
      ).toList();
    }

    setState(() {
      _filteredTemplates = filtered;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Templates'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border(
                bottom: BorderSide(color: const Color.fromARGB(255, 29, 24, 24)!),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search templates...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterTemplates();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 84, 45, 45),
                  ),
                  onChanged: (value) => _filterTemplates(),
                ),
                
                const SizedBox(height: 16),
                
                // Filter Chips
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return FilterChip(
                                label: Text(category.toUpperCase()),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                  _filterTemplates();
                                },
                                backgroundColor: Colors.white,
                                selectedColor: const Color.fromARGB(255, 148, 54, 52),
                                checkmarkColor: Colors.blue[700],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Difficulty Filter
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _difficulties.map((difficulty) {
                              final isSelected = _selectedDifficulty == difficulty;
                              return FilterChip(
                                label: Text(difficulty.toUpperCase()),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedDifficulty = difficulty;
                                  });
                                  _filterTemplates();
                                },
                                backgroundColor: Colors.white,
                                selectedColor: Colors.green[100],
                                checkmarkColor: Colors.green[700],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results Count
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text(
              '${_filteredTemplates.length} templates found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          
          // Templates Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTemplates.isEmpty
                    ? _buildEmptyState()
                    : _buildTemplatesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No templates found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = 'all';
                _selectedDifficulty = 'all';
              });
              _filterTemplates();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = _filteredTemplates[index];
        return TemplateCard(
          template: template,
          onTap: () => _onTemplateSelected(template),
        );
      },
    );
  }

  void _onTemplateSelected(VideoTemplate template) {
    Navigator.pushNamed(
      context,
      '/template-preview',
      arguments: template,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}