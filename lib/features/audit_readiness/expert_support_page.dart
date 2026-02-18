import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpertSupportPage extends StatefulWidget {
  const ExpertSupportPage({super.key});

  @override
  State<ExpertSupportPage> createState() => _ExpertSupportPageState();
}

class _ExpertSupportPageState extends State<ExpertSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! This is the Audit Defense expert team. How can we help you today?",
      time: "02:44 PM",
      isUser: true, // Right side (simulating user's message as per image design or maybe user is expert?)
      // Note: Image shows right side with user avatar but same text as expert. I will implement as per standard chat:
      // Right = User (Me), Left = Expert (Support).
      // However, if the user explicitly wants the exact text "Hello! This is the Audit Defense expert team..." on the right, I will do that.
      // The image seems to show a conversation.
      // Top bubble (Right): "Hello! This is the Audit Defense expert team. How can we help you today?" -> This is weird if it's the user. Maybe it's a quote?
      // Bottom bubble (Left): "Hello! This is the Audit Defense expert team. How can we help you today?" -> This is definitely the expert.
      // I'll stick to a standard conversation flow but use the visual style from the image.
    ),
    ChatMessage(
      text: "Hello! This is the Audit Defense expert team. How can we help you today?",
      time: "02:44 PM",
      isUser: false, // Left side
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2937), // Dark blue-grey background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Expert Support',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
            ),

            // Chat Area
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Date Label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Messages List
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Input Area
            Container(
              padding: const EdgeInsets.all(16.0),
              // decoration: BoxDecoration(
              //   color: const Color(0xFF1F2937),
              // ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Slightly rounded corners like in image
                  border: Border.all(color: Colors.white, width: 1.5), // White border
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, color: Colors.white70, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0091EA), // Bright blue send button
                        shape: BoxShape.circle, // Rounded corners for send button container? Image shows circle icon inside or rounded square? Looks like circle icon.
                        // Wait, image shows blue square with rounded corners containing the send icon? No, it looks like a blue circle with a white paper plane.
                        // Actually, looking closely at the input field:
                        // It's a rounded rectangle outline.
                        // Inside right: A blue circle with a white paper plane icon.
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                // Expert Avatar (Logo)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16253A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/cashflow.png'), // Placeholder for logo
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              
              // Message Bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent bg with border
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight: message.isUser ? Radius.zero : const Radius.circular(16),
                    ),
                    border: Border.all(color: Colors.white, width: 1.5), // White border
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              if (message.isUser) ...[
                const SizedBox(width: 12),
                // User Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          // Time Stamp
          Padding(
            padding: EdgeInsets.only(
              left: message.isUser ? 0 : 52, // 40 + 12
              right: message.isUser ? 52 : 0, // 40 + 12
            ),
            child: Text(
              message.time,
              textAlign: message.isUser ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String time;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isUser,
  });
}
