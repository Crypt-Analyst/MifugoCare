import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/livestock.dart';
import '../../../data/repositories/chat_message_repository.dart';
import '../../../data/repositories/conversation_repository.dart';
import '../../messaging/screens/chat_screen.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class BuyerMessageScreen extends StatefulWidget {
  const BuyerMessageScreen({super.key, required this.livestock});

  final Livestock livestock;

  @override
  State<BuyerMessageScreen> createState() => _BuyerMessageScreenState();
}

class _BuyerMessageScreenState extends State<BuyerMessageScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _startConversation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Message cannot be empty.';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final conversation = await ConversationRepository().getOrCreate(
        buyerId: user.uid,
        sellerId: widget.livestock.ownerId,
        livestockId: widget.livestock.id,
      );

      await ChatMessageRepository().sendMessage(
        conversationId: conversation.id,
        senderId: user.uid,
        body: _messageController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: conversation.id,
              title: 'Seller ${widget.livestock.ownerId}',
            ),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to start conversation.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Seller')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.livestock.name} (${widget.livestock.type})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Seller ID: ${widget.livestock.ownerId}'),
              const SizedBox(height: 20),
              if (user == null)
                const Text('Login required to message sellers.')
              else
                AppTextField(
                  controller: _messageController,
                  label: 'Your message',
                ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              if (user != null)
                AppButton(
                  label: _isSending ? 'Sending...' : 'Start Chat',
                  onPressed: _isSending ? null : _startConversation,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
