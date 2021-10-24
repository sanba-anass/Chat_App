import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:fun_chat_app/providers/auth_provider.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';
import 'package:fun_chat_app/services/firebase_fire.dart';
import 'package:fun_chat_app/views/home_page.dart';
import 'package:fun_chat_app/views/message_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
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

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).userName;
    final phoneNumber = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).phoneNumber;
    final userId = Provider.of<FirebaseAuthService>(
      context,
      listen: false,
    ).userId;
    final user = Provider.of<FirebaseAuthService>(context, listen: false).user;
    final countryNumber =
        Provider.of<AuthProvider>(context, listen: false).countryNumber;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text('Profile Info',
                  style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontSize: 25,
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                'Please provide your name and your profile photo.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  UiMethods.showModal(
                    context,
                    setuserImagefromcamera,
                    setuserImagefromgallery,
                  );
                },
                child: _userimage == null
                    ? Container(
                        height: 110,
                        width: 110,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.grey,
                            size: 35,
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.file(_userimage as File).image),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                child: TextField(
                  cursorColor: Colors.teal,
                  controller: userName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type your name here',
                    contentPadding: EdgeInsets.only(left: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple.shade400, width: 1.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurple.shade400,
                  ),
                ),
                onPressed: () async {
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('user_image')
                      .child(_userId + '.jpg');

                  if ((_userimage != null) &&
                      !(userName.text.isEmpty || userName.text.length < 6) &&
                      user != null) {
                    this.setState(() {
                      isloading = true;
                    });
                    await ref.putFile(_userimage as File);
                    final url = await ref.getDownloadURL();

                    await context.read<FirebaseFireService>().addUser(
                          userName.text,
                          '${countryNumber.text.trim()} ${phoneNumber.text.trim()}',
                          userId,
                          url,
                        );

                    await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => MessageDetailsPage(),
                        ),
                        (route) => false);
                    this.setState(() {
                      isloading = false;
                    });
                  } else {
                    UiMethods.showalert(
                        "Something goes wrong ethier you didn't pick a picture or your name is too short!",
                        context,
                        'Oops!');
                    this.setState(() {
                      isloading = false;
                    });
                  }
                },
                child: isloading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.2,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Processing...',
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text('NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
