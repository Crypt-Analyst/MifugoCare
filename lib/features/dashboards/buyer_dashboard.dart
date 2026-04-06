import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/dashboard_action_card.dart';
import '../../shared/widgets/dashboard_header.dart';
import '../buyer/screens/buyer_listings_screen.dart';
import '../buyer/screens/buyer_messages_screen.dart';
import '../buyer/screens/buyer_saved_listings_screen.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Market'),
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
          const DashboardHeader(
            title: 'Browse verified livestock',
            subtitle: 'Find healthy animals and connect fast',
            icon: Icons.storefront,
          ),
          const SizedBox(height: 20),
          DashboardActionCard(
            title: 'Browse Listings',
            subtitle: 'Filter livestock by type and location',
            icon: Icons.storefront,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BuyerListingsScreen()),
              );
            },
          ),
          DashboardActionCard(
            title: 'Messages',
            subtitle: 'Contact pastoralists',
            icon: Icons.chat_bubble_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BuyerMessagesScreen()),
              );
            },
          ),
          DashboardActionCard(
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
