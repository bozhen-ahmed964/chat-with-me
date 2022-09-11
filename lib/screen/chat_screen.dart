import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwithme/screen/group_info.dart';
import 'package:chatwithme/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/message_tile.dart';
import '../widget/widgets.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatScreen(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  ImagePicker picker = ImagePicker();
  XFile? image;
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.red, Colors.blue],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1620055374842-145f66ec4652?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80',
                ),
              ),
            ),
            height: 665,
            child: chatMessages(),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              height: 77,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.red, Colors.blue],
                ),
                
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108)),
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        hintText: "Send a message...",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Text('Select File From',
                                  style: TextStyle(color: Colors.black)),
                              children: [
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Take a photo',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.camera);
                                    setState(() {
                                      clearImage();
                                    });
                                  },
                                ),
                                image == null
                                    ? Container()
                                    : Image.file(File(image!.path)),
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('Chose from gallery',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () async {
                                    image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    setState(() {
                                      clearImage();
                                    });
                                  },
                                ),
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('Cancel',
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Center(
                          child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        color: Colors.black,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  void clearImage() {
    setState(() {
      image = null;
    });
  }
}
