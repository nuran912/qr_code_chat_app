import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_box/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatPage({super.key, required this.chatId, required this.otherUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<String?> _getOtherUsername(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data()?['username'] ?? '';
  }

  // Send message
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final senderId = FirebaseAuth.instance.currentUser!.uid;

    _chatService.sendMessage(widget.chatId, senderId, text);
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final neonGreen = const Color(0xFF39FF14);
    final bgDark = const Color.fromARGB(255, 0, 20, 49);
    final appBarDark = const Color.fromARGB(255, 0, 32, 79);
    final cardDark = const Color.fromARGB(255, 0, 40, 100);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: appBarDark,
        title: FutureBuilder<String?>(
          future: _getOtherUsername(widget.otherUserId),
          builder: (context, snapshot) {
            final username = snapshot.data ?? "";
            return Text(
              username.isNotEmpty ? username : "...",
              style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
            );
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error loading messages",
                      style: TextStyle(color: neonGreen),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF39FF14)),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == currentUserId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isMe ? neonGreen : appBarDark,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isMe
                              ? [
                                  BoxShadow(
                                    color: neonGreen.withOpacity(0.5),
                                    blurRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isMe ? Colors.black : neonGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 8,
                top: 4,
              ),
              child: Container(
                color: cardDark,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: neonGreen),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: neonGreen.withOpacity(0.7),
                          ),
                          filled: true,
                          fillColor: bgDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: neonGreen),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: neonGreen, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: neonGreen),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      height: 48,
                      width: 48,
                      margin: const EdgeInsets.only(left: 4),
                      child: Material(
                        color: neonGreen,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _sendMessage,
                          child: Icon(Icons.send, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
