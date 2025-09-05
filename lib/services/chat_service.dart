import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create a chat between two users
  Future<String> getOrCreateChat(String userAId, String userBId) async {
    // Check if a chat already exists
    final sortedExistingIds = [userAId, userBId]..sort();
    final chatQuery = await _firestore
          .collection('chats')
          .where('participants', isEqualTo: sortedExistingIds)
          .get();
          
    for (var doc in chatQuery.docs) {
      List participants = doc['participants'];
      if (participants.contains(userBId)) {
        return doc.id; // Chat already exists
      }
    }

    // Otherwise, create a new chat
    final sortedIds = [userAId, userBId]..sort();
    final newChat = await _firestore.collection('chats').add({
      'participants': sortedIds,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  // Send a message in a chat
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final message = {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  //get other user's details
  Future<String?> getUserEmailById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['username'] ?? '...';
      }
    } catch (e) {
      print("Error fetching user username: $e");
    }
    return null;
  }

  // Stream messages for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Stream all chats for a user
  Stream<QuerySnapshot> getChatsForUser(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get the other participant's ID in a chat
  Future<String?> getOtherParticipantId(String chatId, String currentUserId) async {
    final doc = await _firestore.collection('chats').doc(chatId).get();

    if (!doc.exists) return null;

    final participants = List<String>.from(doc['participants']);

    if(participants[0] == participants[1]) {
      // Chat with self
      return currentUserId;
    }else{

      participants.remove(currentUserId);
      return participants.first;
    }
  }
}
