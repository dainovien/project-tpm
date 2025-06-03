import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Views/detail.dart';

class FavoriteAgentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengakses daftar favorit dari FavoriteAgents()
    List<dynamic> favoriteAgents = FavoriteAgents().favoriteAgents;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Agents'),
        backgroundColor: Colors.black, // Warna hitam
      ),
      body: ListView.builder(
        itemCount: favoriteAgents.length,
        itemBuilder: (context, index) {
          dynamic agent = favoriteAgents[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgentDetailPage(agent: agent),
                ),
              );
            },
            child: ListTile(
              leading: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(agent['displayIcon'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                agent['displayName'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent['role'] != null
                          ? agent['role']['displayName']
                          : 'Initiator',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      agent['description'] ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}