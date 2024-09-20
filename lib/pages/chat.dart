import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/hooks.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<String, dynamic> getfetchuser = {};
  final TextEditingController _messageController = TextEditingController();
  String? chatID;

  // Function to fetch user data by userId
  Future<void> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          getfetchuser = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print('User does not exist');
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('chats')
                  .where('vetID', isEqualTo: userAuth.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          snapshot.data!.docs[index].data();

                      String dataID = data['userid'];
                      debugPrint(dataID);

                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(dataID)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              Map<String, dynamic>? datvalue =
                                  snapshot.data!.data();
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    chatID = data['userid'];
                                  });
                                },
                                leading: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ClipOval(
                                    child: Image.network(
                                        fit: BoxFit.cover,
                                        datvalue!['imageprofile']),
                                  ),
                                ),
                                title: Text(datvalue['fname'] ?? 'Loading...'),
                              );
                            }
                          });
                    },
                  );
                }
              },
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(10),
            child: chatID == null
                ? const Center(
                    child: Text("Select a chat to view messages"),
                  )
                : FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('chats')
                        .where('userid', isEqualTo: chatID)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("No Message");
                      } else {
                        return Column(
                          children: [
                            // Chat message list
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(userAuth.currentUser!.uid)
                                    .collection('message')
                                    .snapshots(),
                                builder: (context, messageSnapshot) {
                                  if (messageSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (!messageSnapshot.hasData ||
                                      messageSnapshot.data!.docs.isEmpty) {
                                    return const Center(
                                        child: Text("No messages available"));
                                  }

                                  final messageDocs =
                                      messageSnapshot.data!.docs;

                                  return ListView.builder(
                                    reverse: true,
                                    itemCount: messageDocs.length,
                                    itemBuilder: (context, index) {
                                      var messageData = messageDocs[index]
                                          .data() as Map<String, dynamic>;
                                      bool isSentByCurrentUser =
                                          messageData['senderId'] ==
                                              userAuth.currentUser!.uid;

                                      return Align(
                                        alignment: isSentByCurrentUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: isSentByCurrentUser
                                                ? Colors.blue[100]
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: messageData['imageUrl'] != null
                                              ? Image.network(
                                                  messageData['imageUrl'])
                                              : Text(messageData['text'] ?? ''),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            // Message input and send button at the bottom
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      decoration: const InputDecoration(
                                        hintText: "Type your message...",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () {
                                      if (chatID != null) {
                                        _sendMessage();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    try {
      DocumentReference chatDoc = FirebaseFirestore.instance
          .collection('chats')
          .doc(userAuth.currentUser!.uid);

      // Create or update the chat document
      await chatDoc.set({
        'vetID': userAuth.currentUser!.uid,
        'userid': chatID,
      }, SetOptions(merge: true));

      CollectionReference messageCollection = chatDoc.collection('message');

      await messageCollection.add({
        'text': _messageController.text,
        'senderId': userAuth.currentUser!.uid,
        'vetId': userAuth.currentUser!.uid,
        'imageUrl': null,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
