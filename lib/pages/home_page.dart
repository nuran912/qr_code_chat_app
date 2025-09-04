import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_chat_app/widgets/qr_code_page.dart';
import 'package:qr_chat_app/widgets/qr_scanner_page.dart';
import 'package:qr_chat_app/services/auth/auth_service.dart';
import 'package:qr_chat_app/services/chat_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();

  // Sign out method
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  // Handle QR scan result → open/create chat
  Future<void> _handleQRScan() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final scannedUserId = await showQRScannerPopUp(context);
    // print("Scanned User ID: $scannedUserId");

    if (scannedUserId != null && scannedUserId.isNotEmpty) {
      final chatId =
          await _chatService.getOrCreateChat(currentUserId, scannedUserId);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(chatId: chatId, otherUserId: scannedUserId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserEmail = currentUser!.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$currentUserEmail", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      body: StreamBuilder(
        stream: _chatService.getChatsForUser(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading chats"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatDocs = snapshot.data!.docs;

          // No chats yet
          if (chatDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Oops, No chats yet :(",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    "Start a new chat now!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chat = chatDocs[index];
              final chatId = chat.id;
              final lastMessage = chat['lastMessage'] ?? '';

              return FutureBuilder<String?>(
                future: _chatService.getOtherParticipantId(chatId, currentUser.uid),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final otherUserId = userSnapshot.data!;

                  return FutureBuilder<String?>(
                    future: _chatService.getUserEmailById(otherUserId),
                    builder: (context, emailSnapshot) {
                      final otherUserEmail = emailSnapshot.data ?? "Unknown";

                      return ListTile(
                        title: Text(otherUserEmail),
                        subtitle: Text(lastMessage),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatPage(
                                chatId: chatId,
                                otherUserId: otherUserId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleQRScan,
        backgroundColor: Colors.black,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(Icons.add_outlined, color: Colors.white),
      ),
    );
  }
}
