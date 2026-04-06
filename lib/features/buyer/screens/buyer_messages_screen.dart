import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/conversation.dart';
import '../../../data/repositories/conversation_repository.dart';
import '../../messaging/screens/chat_screen.dart';

class BuyerMessagesScreen extends StatelessWidget {
  const BuyerMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder<List<Conversation>>(
        stream: ConversationRepository().streamForBuyer(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return Card(
                child: ListTile(
                  title: Text('Seller: ${conversation.sellerId}'),
                  subtitle: Text(conversation.lastMessage.isEmpty
                      ? 'No messages yet'
                      : conversation.lastMessage),
                  trailing: Text(
                    conversation.updatedAt
                        .toLocal()
                        .toString()
                        .split(' ')[0],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          conversationId: conversation.id,
                          title: 'Seller ${conversation.sellerId}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
