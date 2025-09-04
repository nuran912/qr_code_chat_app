import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_chat_app/services/chat_service.dart';

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

  String? _otherUserEmail; // state variable

  @override
  void initState() {
    super.initState();
    _loadOtherUserEmail();
  }

  Future<void> _loadOtherUserEmail() async {
    final email = await _chatService.getUserEmailById(widget.otherUserId);
    setState(() {
      _otherUserEmail = email ?? "Unknown";
    });
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
        title: Text(
          _otherUserEmail ?? "Loading...",
          style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: cardDark,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: neonGreen),
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: TextStyle(color: neonGreen.withOpacity(0.7)),
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
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: neonGreen),
                  onPressed: _sendMessage,
                  tooltip: "Send",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
