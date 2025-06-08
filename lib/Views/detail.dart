import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AgentDetailPage extends StatefulWidget {
  final dynamic agent;

  AgentDetailPage({required this.agent});

  @override
  _AgentDetailPageState createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  bool isFavorite = false;

  // Define Valorant-inspired colors for consistency
  static const Color valorantRed = Color(0xFFFF4655);
  static const Color valorantDarkBlue =
      Color(0xFF0F1923); // A very dark blue, almost black
  static const Color valorantGrey =
      Color(0xFF272D38); // Dark grey for cards/background
  static const Color valorantLightGrey =
      Color(0xFFEFEFEF); // Off-white for text
  static const Color valorantAccentYellow =
      Color(0xFFFBEA2D); // Subtle accent (if needed)

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // Load favorite status from SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    isFavorite = await FavoriteAgents().isFavorite(widget.agent);
    setState(() {}); // Update UI based on loaded status
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await FavoriteAgents().addToFavorites(widget.agent);
      _showSnackBar('Agent added to favorites!', valorantRed);
    } else {
      await FavoriteAgents().removeFromFavorites(widget.agent);
      _showSnackBar('Agent removed from favorites!', valorantGrey);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: valorantLightGrey),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAbilityDescription(String abilityName, String abilityDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: valorantGrey, // Dialog background
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            abilityName.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'ValorantFont',
              color: valorantRed,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            abilityDescription,
            style: const TextStyle(
              fontFamily: 'ValorantFont',
              color: valorantLightGrey,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  fontFamily: 'ValorantFont',
                  color: valorantRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue, // Main background
      appBar: AppBar(
        backgroundColor: valorantDarkBlue,
        elevation: 0,
        // UBAH DI SINI: Mengatur warna ikon dan teks foreground AppBar menjadi valorantLightGrey
        foregroundColor: valorantLightGrey,
        title: Text(
          (widget.agent['displayName'] ?? '').toUpperCase(),
          style: const TextStyle(
            fontFamily: 'ValorantFont',
            color: valorantLightGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.bookmark
                  : Icons.bookmark_border, // Changed icon to bookmark
              color:
                  isFavorite ? valorantRed : valorantLightGrey.withOpacity(0.7),
              size: 28,
            ),
            onPressed: toggleFavorite,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
          const SizedBox(width: 8), // Add some spacing
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Portrait and Role/Description
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Rounded corners for the image
                  child: Image.network(
                    widget.agent['fullPortraitV2'] ??
                        widget.agent['fullPortrait'] ??
                        '',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height *
                        0.5, // Adjust height
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      color: valorantGrey,
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            color: valorantRed, size: 50),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: valorantDarkBlue
                        .withOpacity(0.8), // Semi-transparent dark blue overlay
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (widget.agent['role'] != null
                                ? widget.agent['role']['displayName']
                                : 'Unknown Role')
                            .toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'ValorantFont',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              valorantAccentYellow, // Use accent yellow for role
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.agent['description'] ??
                            'No description available.',
                        style: const TextStyle(
                          fontFamily: 'ValorantFont',
                          fontSize: 14,
                          color: valorantLightGrey,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Abilities Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    valorantGrey, // Dark grey background for abilities section
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(color: valorantRed.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ABILITIES',
                    style: TextStyle(
                      fontFamily: 'ValorantFont',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: valorantRed, // Red for section title
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.agent['abilities'] != null &&
                      widget.agent['abilities'].isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true, // important for nested GridView
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two abilities per row
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            1.2, // Adjust aspect ratio for better look
                      ),
                      itemCount: widget.agent['abilities'].length,
                      itemBuilder: (context, index) {
                        final ability = widget.agent['abilities'][index];
                        if (ability['displayIcon'] == null ||
                            ability['displayName'] == null ||
                            ability['description'] == null) {
                          return const SizedBox
                              .shrink(); // Hide if data is incomplete
                        }
                        return _buildAbilityCard(ability);
                      },
                    )
                  else
                    const Text(
                      'No abilities information available.',
                      style: TextStyle(
                        fontFamily: 'ValorantFont',
                        color: valorantLightGrey,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityCard(dynamic ability) {
    return GestureDetector(
      onTap: () {
        _showAbilityDescription(
          ability['displayName'],
          ability['description'],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: valorantDarkBlue, // Dark blue for ability card background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: valorantRed.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ability['displayIcon'] != null)
              Image.network(
                ability['displayIcon'],
                height: 40,
                width: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  color: valorantRed,
                  size: 30,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              ability['displayName'].toUpperCase(),
              style: const TextStyle(
                fontFamily: 'ValorantFont',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valorantLightGrey, // Light grey for ability name
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteAgents {
  static final FavoriteAgents _instance = FavoriteAgents._internal();
  factory FavoriteAgents() => _instance;
  FavoriteAgents._internal();

  static const String _favoritesKey = 'favoriteAgents';
  List<dynamic> _favoriteAgents = [];
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson != null) {
        _favoriteAgents = json.decode(favoritesJson);
      }
      _isInitialized = true;
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = json.encode(_favoriteAgents);
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  Future<void> addToFavorites(dynamic agent) async {
    await _init();
    // Check if agent is already in favorites by UUID to prevent duplicates
    if (!_favoriteAgents.any((favAgent) => favAgent['uuid'] == agent['uuid'])) {
      _favoriteAgents.add(agent);
      await _saveFavorites();
    }
  }

  Future<void> removeFromFavorites(dynamic agent) async {
    await _init();
    _favoriteAgents
        .removeWhere((favAgent) => favAgent['uuid'] == agent['uuid']);
    await _saveFavorites();
  }

  Future<bool> isFavorite(dynamic agent) async {
    await _init();
    return _favoriteAgents.any((favAgent) => favAgent['uuid'] == agent['uuid']);
  }

  Future<List<dynamic>> getFavorites() async {
    await _init();
    return List.from(
        _favoriteAgents); // Return a copy to prevent external modification
  }
}
