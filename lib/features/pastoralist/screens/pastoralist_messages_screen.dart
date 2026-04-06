import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/conversation.dart';
import '../../../data/repositories/conversation_repository.dart';
import '../../messaging/screens/chat_screen.dart';

class PastoralistMessagesScreen extends StatelessWidget {
  const PastoralistMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Messages')),
      body: StreamBuilder<List<Conversation>>(
        stream: ConversationRepository().streamForSeller(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final convo = conversations[index];
              return Card(
                child: ListTile(
                  title: Text('Buyer: ${convo.buyerId}'),
                  subtitle: Text(convo.lastMessage.isEmpty
                      ? 'No messages yet'
                      : convo.lastMessage),
                  trailing: Text(
                    convo.updatedAt.toLocal().toString().split(' ')[0],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          conversationId: convo.id,
                          title: 'Buyer ${convo.buyerId}',
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
