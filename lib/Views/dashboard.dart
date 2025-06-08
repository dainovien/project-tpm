import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectakhir_mobile/Views/datadiri.dart';
import 'package:projectakhir_mobile/Views/detail.dart';
import 'package:projectakhir_mobile/Views/favorite.dart';
import 'package:projectakhir_mobile/Views/login_screen.dart';
import 'package:projectakhir_mobile/Views/moneyconverter.dart';
import 'package:projectakhir_mobile/Views/sarankesan.dart';
import 'package:projectakhir_mobile/Views/timeconverter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> agents = [];
  List<dynamic> searchResults = [];
  bool isSearching = false;

  late SharedPreferences prefs;

  // Define Valorant-inspired colors for consistency across the app
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
    _initialSetup(); // Renamed for clarity
    fetchAgents();
  }

  void _initialSetup() async {
    // Renamed for clarity
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchAgents() async {
    final response = await http.get(Uri.parse(
        'https://valorant-api.com/v1/agents?isPlayableCharacter=true'));
    if (response.statusCode == 200) {
      setState(() {
        agents = json.decode(response.body)['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to fetch agents. Please try again later.',
            style:
                TextStyle(color: valorantLightGrey), // Text color for clarity
          ),
          backgroundColor: valorantRed, // Valorant Red for snackbar
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
      throw Exception('Failed to fetch agents');
    }
  }

  void searchAgents(String query) {
    setState(() {
      if (query.isNotEmpty) {
        isSearching = true;
        searchResults = agents.where((agent) {
          return agent['displayName']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (agent['role'] != null &&
                  agent['role']['displayName'] // Null check for role
                      .toLowerCase()
                      .contains(query.toLowerCase()));
        }).toList();
      } else {
        isSearching = false;
        searchResults = [];
      }
    });
  }

  void navigateToDetailPage(dynamic agent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgentDetailPage(agent: agent),
      ),
    );
  }

  void navigateToFavoriteAgentsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteAgentsPage(),
      ),
    );
  }

  void navigateToCurrencyConverterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyConverterPage(),
      ),
    );
  }

  void navigateToTimeConverterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeConverterPage(),
      ),
    );
  }

  void navigateToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  void navigateToFeedbackPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FeedbackPage(), // Using FeedbackPage from sarankesan.dart
      ),
    );
  }

  void navigateToLogout() async {
    await prefs.remove("username");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue, // Main background
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/valorant-logo.png', // Ensure this asset is available
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'VALORANT AGENTS',
              style: TextStyle(
                fontFamily: 'ValorantFont', // Custom font for game feel
                color: valorantLightGrey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 22,
              ),
            ),
          ],
        ),
        backgroundColor: valorantDarkBlue,
        elevation: 0, // Flat app bar
      ),
      body: agents.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    valorantRed), // Valorant Red indicator
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: searchAgents,
                    style: const TextStyle(color: valorantLightGrey),
                    decoration: InputDecoration(
                      hintText: 'Search agent by name or role...',
                      hintStyle:
                          TextStyle(color: valorantLightGrey.withOpacity(0.6)),
                      labelText: 'Search Agent',
                      labelStyle: const TextStyle(color: valorantLightGrey),
                      prefixIcon: const Icon(Icons.search,
                          color: valorantRed), // Valorant Red search icon
                      filled: true,
                      fillColor: valorantGrey, // Darker grey for search bar
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Pill shape for search bar
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: valorantRed.withOpacity(0.5),
                            width: 1.0), // Subtle red border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: valorantRed,
                            width: 2.0), // Stronger red border on focus
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      // Background Image - Subtly visible behind the grid
                      Positioned.fill(
                        // Use Positioned.fill to ensure it covers the whole space
                        child: Image.asset(
                          'assets/valobackground.jpg', // Ensure this image is suitable for a background
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(
                              0.2), // Make it subtle
                        ),
                      ),
                      // Gradient Overlay for readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              valorantDarkBlue.withOpacity(0.3),
                              valorantDarkBlue.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      isSearching
                          ? _buildAgentGrid(searchResults) // Pass filtered list
                          : _buildAgentGrid(agents), // Pass all agents
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: valorantDarkBlue,
        selectedItemColor:
            valorantRed, // Highlight selected item with Valorant Red
        unselectedItemColor:
            valorantLightGrey.withOpacity(0.7), // Subtle grey for unselected
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'ValorantFont', // Apply custom font
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontFamily: 'ValorantFont',
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons
                .bookmark), // Changed to bookmark for consistency with detail page
            label: 'FAVORITES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange), // More modern currency icon
            label: 'CURRENCY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule), // More modern time icon
            label: 'TIME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.notes), // Changed to notes for feedback consistency
            label: 'FEEDBACK',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'LOGOUT',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              navigateToFavoriteAgentsPage();
              break;
            case 1:
              navigateToCurrencyConverterPage();
              break;
            case 2:
              navigateToTimeConverterPage();
              break;
            case 3:
              navigateToProfilePage();
              break;
            case 4:
              navigateToFeedbackPage();
              break;
            case 5:
              navigateToLogout();
              break;
          }
        },
      ),
    );
  }

  // Refactored buildAgentGrid to accept a list for reusability with search results
  Widget _buildAgentGrid(List<dynamic> agentList) {
    if (agentList.isEmpty && isSearching) {
      return Center(
        child: Text(
          'NO AGENTS FOUND',
          style: TextStyle(
              color: valorantLightGrey,
              fontSize: 18,
              fontFamily: 'ValorantFont'),
        ),
      );
    } else if (agentList.isEmpty && !isSearching) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(valorantRed),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85, // Adjusted for slightly taller cards
      ),
      itemCount: agentList.length,
      itemBuilder: (context, index) {
        final agent = agentList[index];
        return GestureDetector(
          onTap: () => navigateToDetailPage(agent),
          child: Card(
            color: valorantGrey, // Dark grey card background
            elevation: 8, // More pronounced shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // More rounded corners
              side: BorderSide(
                  color: valorantRed.withOpacity(0.3),
                  width: 1.0), // Subtle red border
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.black, // Dark background for image area
                    child: Image.network(
                      agent['displayIcon'],
                      fit:
                          BoxFit.contain, // Use contain to show full agent icon
                      errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.broken_image,
                              color: valorantRed)), // Valorant Red error icon
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: valorantGrey
                          .withOpacity(0.9), // Slightly transparent overlay
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          agent['displayName']
                              .toUpperCase(), // Uppercase for agent names
                          style: const TextStyle(
                            fontFamily: 'ValorantFont',
                            fontWeight: FontWeight.bold,
                            color: valorantRed, // Agent name in Valorant Red
                            fontSize: 16,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          agent['role']['displayName']
                              .toUpperCase(), // Uppercase for role
                          style: TextStyle(
                            fontFamily: 'ValorantFont',
                            color: valorantLightGrey
                                .withOpacity(0.8), // Role in light grey
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
