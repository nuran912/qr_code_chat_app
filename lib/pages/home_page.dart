import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      final chatId = await _chatService.getOrCreateChat(
        currentUserId,
        scannedUserId,
      );

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
    final neonGreen = const Color(0xFF39FF14);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 20, 49),
      appBar: AppBar(
        title: Text(
          "$currentUserEmail",
          style: TextStyle(
            color: neonGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 32, 79),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout, color: neonGreen),
            tooltip: "Sign Out",
          ),
        ],
        elevation: 0,
        // toolbarHeight: kToolbarHeight + 15,
        
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            color: neonGreen,
            height: 5,
          ),
        ),
      ),

      body: StreamBuilder(
        stream: _chatService.getChatsForUser(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading chats",
                style: TextStyle(color: neonGreen),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF39FF14)),
            );
          }

          final chatDocs = snapshot.data!.docs;

          // No chats yet
          if (chatDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, color: neonGreen, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "No chats yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: neonGreen,
                      shadows: [Shadow(color: neonGreen, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start a new chat now!",
                    style: TextStyle(
                      fontSize: 16,
                      color: neonGreen.withOpacity(0.7),
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
                future: _chatService.getOtherParticipantId(
                  chatId,
                  currentUser.uid,
                ),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final otherUserId = userSnapshot.data!;

                  
                  return FutureBuilder<String?>(
                    future: _chatService.getUserEmailById(otherUserId),
                    builder: (context, emailSnapshot) {
                      final otherUserEmail = emailSnapshot.data ?? "Unknown";

                      return Card(
                        color: const Color.fromARGB(255, 0, 40, 100),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            otherUserEmail,
                            style: TextStyle(
                              color: neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage,
                            style: TextStyle(color: neonGreen.withOpacity(0.7)),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: neonGreen,
                            size: 18,
                          ),
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
                        ),
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
        backgroundColor: neonGreen,
        elevation: 8,
        child: const Icon(Icons.add_outlined, color: Colors.black),
      ),
    );
  }
}
