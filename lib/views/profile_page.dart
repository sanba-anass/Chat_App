import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  final db = FirebaseFirestore.instance;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  File? _userimage;

  bool isloading = false;

  void setuserImagefromcamera() async {
    final userimage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _userimage = File(userimage!.path);
    });
  }

  void setuserImagefromgallery() async {
    final userimage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _userimage = File(userimage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 40,
          ),
          FutureBuilder<DocumentSnapshot<Object?>>(
            future: _users.doc(userId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Container(
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FadeInImage.assetNetwork(
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                            placeholder: 'assets/load.gif',
                            image: data['userImageUrl'],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            UiMethods.showModal(
                              context,
                              setuserImagefromcamera,
                              setuserImagefromgallery,
                            );
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('user_image')
                                .child(userId + '.jpg');
                            await ref.putFile(_userimage as File);
                            final url = await ref.getDownloadURL();

                            await snapshot.data!.reference.update({
                              'userImageUrl': url,
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
          SizedBox(
            height: 60,
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: _users.doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.person),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text(
                                  data['userName'].toString(),
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 230,
                                ),
                                IconButton(
                                  onPressed: () {
                                    final TextEditingController _controller =
                                        TextEditingController(
                                      text: data['userName'].toString(),
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.deepPurple,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('CANCEL'),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.deepPurple,
                                            ),
                                            onPressed: () async {
                                              await snapshot.data!.reference
                                                  .update({
                                                'userName': _controller.text
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('SAVE'),
                                          ),
                                        ],
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Enter your name',
                                            ),
                                            TextField(
                                              maxLength: 20,
                                              decoration: InputDecoration(),
                                              controller: _controller,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.deepPurple.shade400,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'This name will be visible to others if you send a message',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.phone),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone',
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              data['phoneNumber'].toString(),
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
