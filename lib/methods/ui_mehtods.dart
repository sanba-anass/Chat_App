import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UiMethods {
  static void showalert(String message, BuildContext context, [String? title]) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title ?? '',
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.raleway(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.teal),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.raleway(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static File? docfile;
  static Future<void> pickpdf() async {
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    ).then((value) {
      if (value != null) docfile = File(value.paths[0]!);
    });
  }

  static void showmodal(
      setuserImagefromcamera, setuserImagefromgallery, BuildContext context,
      [setvideo]) {
    showModalBottomSheet<Null>(
      context: context,
      builder: (context) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 30,
            runSpacing: 15,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      setuserImagefromcamera();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Camera',
                    style: GoogleFonts.raleway(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setuserImagefromgallery();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple, shape: BoxShape.circle),
                      height: 43,
                      width: 43,
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Gallery',
                    style: GoogleFonts.raleway(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setvideo(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.video_library,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'video',
                    style: GoogleFonts.raleway(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setvideo(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'videocam',
                    style: GoogleFonts.raleway(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await pickpdf();
                      final db = FirebaseFirestore.instance;
                      final currrentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      final userData = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currrentUserId)
                          .get();

                      final ref =
                          FirebaseStorage.instance.ref().child('pdfs').child(
                                currrentUserId +
                                    (Random().nextDouble() * 1000000000000000)
                                        .toString() +
                                    '.pdf',
                              );

                      await ref.putFile(
                        docfile!,
                        SettableMetadata(contentType: 'pdfs/pdf'),
                      );
                      final url = await ref.getDownloadURL();
                      await db
                          .collection('users')
                          .doc("CYOkFu52HkfBD1fxYYOGzUvYbTl2")
                          .collection('messages')
                          .add({
                        'message': '',
                        'userId': currrentUserId,
                        'timestamp': Timestamp.now(),
                        'userImage': userData['userImageUrl'],
                        'userName': userData['userName'],
                        'imageMessage': '',
                        'videoMessage': '',
                        'audioMessage': '',
                        'video call message': '',
                        'pdfMessage': url,
                      });
                    },
                    child: Container(
                      height: 43,
                      width: 43,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.file_copy,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Document',
                    style: GoogleFonts.raleway(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ),
        height: 200,
        width: 100,
      ),
    );
  }

  static void showModal(
      context, Function()? pickfromcamera, Function()? pickfromgallery) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: pickfromcamera,
            leading: Icon(
              Icons.camera_alt,
              color: Colors.deepPurple.shade400,
            ),
            title: Text(
              'pick a picture',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            onTap: pickfromgallery,
            leading: Icon(
              Icons.image,
              color: Colors.deepPurple.shade400,
            ),
            title: Text(
              'choose from gallery',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
