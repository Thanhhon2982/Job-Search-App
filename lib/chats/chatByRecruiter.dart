// ignore_for_file: prefer_const_constructors_in_immutables, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatRecruiter extends StatefulWidget {
  final String jobId;
  final String applicationId;

  ChatRecruiter({required this.jobId, required this.applicationId});

  @override
  _ChatRecruiterState createState() => _ChatRecruiterState();
}

class _ChatRecruiterState extends State<ChatRecruiter> {
  TextEditingController messageController = TextEditingController();
  late CollectionReference messagesCollection;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messagesCollection = FirebaseFirestore.instance
        .collection('jobsposted')
        .doc(widget.jobId)
        .collection('applications')
        .doc(widget.applicationId)
        .collection('messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 53, 41),
        title: Text(
          'Trang trò chuyện',
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.chat,
          color: Colors.blue,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> messageData =
                        messages[index].data() as Map<String, dynamic>;
                    String messageText = messageData['message'];
                    String sender = messageData['sender'];
                    Timestamp? timestamp = messageData['timestamp'];

                    String formattedTime = 'Timestamp not available';

                    if (timestamp != null) {
                      DateTime dateTime = timestamp.toDate();
                      formattedTime =
                          DateFormat('HH:mm:ss dd-MM-yy').format(dateTime);
                    }

                    bool isUserSender = sender == 'Recruiter';
                    if (isUserSender) {
                      sender = 'you ';
                    }
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: isUserSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isUserSender
                                  ? Color.fromARGB(255, 49, 134, 203)
                                  : Color.fromARGB(255, 199, 210, 40),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: isUserSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUserSender) SizedBox(width: 8),
                          Text(
                            sender,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isUserSender) SizedBox(width: 8),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 8,
                              color: Color.fromARGB(255, 4, 146, 51),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: isUserSender
                          ? EdgeInsets.only(left: 80.0, right: 8.0)
                          : EdgeInsets.only(left: 8.0, right: 80.0),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Gõ tin nhắn của bạn ở đây',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 177, 217, 225),
                  ),
                )),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    messagesCollection.add({
      'message': messageText,
      'sender': 'Recruiter',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
