import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/views/message_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  final db = FirebaseFirestore.instance;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FutureBuilder<DocumentSnapshot>(
        future: _users.doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.only(bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade800,
                      image: DecorationImage(
                          image: Image.asset('assets/buimade52352.jpg').image,
                          fit: BoxFit.cover),
                    ),
                    child: UserAccountsDrawerHeader(
                      currentAccountPictureSize: Size.fromRadius(30),
                      currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/loading-gif-.gif',
                            image: data['userImageUrl'],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.transparent),
                      accountName: Text('${data['userName']}',
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      accountEmail: Text(
                        '${data['phoneNumber']}',
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('profile'),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('settings'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }

          return Text("loading...");
        },
      ),
      appBar: AppBar(
        title: Text('fun chat'),
        backgroundColor: Colors.teal.shade800,
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: _users.where('userId', isNotEqualTo: userId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "no users yet :(",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong pls try again!'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  final usersData = snapshot.data;

                  final userName = usersData!.docs[index]['userName'];
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [],
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade400,
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 25,
                              offset: Offset(5, 5),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            placeholder: 'assets/loading-gif-.gif',
                            image: usersData.docs[index]['userImageUrl'],
                          ),
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            /* Provider.of<DataProvider>(context, listen: false)
                                .index = index; */
                           /*  Provider.of<DataProvider>(context, listen: false)
                                .listOfUsers = snapshot.data!.docs; */
                            return MessageDetailsPage();
                          }),
                        );
                        context.read<DataProvider>().toggleisvisibletofalse();

                        final document = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId);
                        await document.update({
                          'countMessage': 0,
                        });
                      },
                      title: Text(
                        userName,
                      ),
                      subtitle:
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: db
                                  .collection('messages')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  return Text(
                                    !(data.docs.isEmpty)
                                        ? data.docs.reversed.last
                                            .data()['message']
                                            .toString()
                                        : '',
                                  );
                                } else {
                                  return Text('');
                                }
                              }),
                      trailing: Visibility(
                        visible: context.watch<DataProvider>().isvisible,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  return Center(
                                    child: Text(
                                      snapshot.data!
                                          .get('countMessage')
                                          .toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else
                                  return Container();
                              }),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
