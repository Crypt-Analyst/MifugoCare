import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../buyer/screens/buyer_listings_screen.dart';
import '../buyer/screens/buyer_messages_screen.dart';
import '../buyer/screens/buyer_saved_listings_screen.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthRepository().signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionCard(
            title: 'Browse Listings',
            subtitle: 'Filter livestock by type and location',
            icon: Icons.storefront,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BuyerListingsScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'Messages',
            subtitle: 'Contact pastoralists',
            icon: Icons.chat_bubble_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BuyerMessagesScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'Saved Listings',
            subtitle: 'Keep track of favorites',
            icon: Icons.bookmark_border,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BuyerSavedListingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
