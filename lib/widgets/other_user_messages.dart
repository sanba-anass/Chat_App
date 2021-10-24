import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fun_chat_app/utils/date.dart';
import 'package:fun_chat_app/views/pdf_page.dart';
import 'package:fun_chat_app/views/record.dart';
import 'package:fun_chat_app/widgets/video_widget.dart';
import 'package:provider/src/provider.dart';

class OtherUserMessages extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> messages;
  final int index;
  OtherUserMessages({
    Key? key,
    required this.messages,
    required this.index,
  }) : super(key: key);
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  //ClientRole? _role = ClientRole.Broadcaster;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      end: Alignment.bottomRight,
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.grey.shade200.withOpacity(0.2),
                        Colors.grey.shade200.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (messages.docs[index]
                              .data()['message']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                                  .data()['imageMessage']
                                  .toString() ==
                              '' &&
                          messages.docs[index]
                              .data()['audioMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['videoMessage']
                              .toString()
                              .isEmpty)
                        PDFPage(
                          url: messages.docs[index]
                              .data()['pdfMessage']
                              .toString(),
                        ),
                      /* if (messages.docs[index]
                          .data()['video call message']
                          .toString()
                          .isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              messages.docs[index]
                                  .data()['video call message']
                                  .toString(),
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                shape: CircleBorder(),
                                child: Builder(builder: (context) {
                                  return Icon(Icons.call, color: Colors.white);
                                }),
                                onPressed: () async {
                                  /* await _handleCameraAndMic(Permission.camera);
                                  await _handleCameraAndMic(
                                      Permission.microphone);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallPage(
                                        channelName: "chatChannel",
                                        role: _role,
                                      ),
                                    ),
                                  ); */
                                },
                                fillColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: RawMaterialButton(
                                shape: CircleBorder(),
                                child:
                                    Icon(Icons.call_end, color: Colors.white),
                                onPressed: () {},
                                fillColor: Colors.red,
                              ),
                            ),
                          ],
                        ), */
                      if (messages.docs[index]
                              .data()['message']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                                  .data()['imageMessage']
                                  .toString() ==
                              '' &&
                          messages.docs[index]
                              .data()['audioMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['pdfMessage']
                              .toString()
                              .isEmpty)
                        VideoWidget(
                          url: messages.docs[index]
                              .data()['videoMessage']
                              .toString(),
                        ),
                      if (!messages.docs[index]
                          .data()['message']
                          .toString()
                          .isEmpty)
                        Text(
                          messages.docs[index]['message'],
                          style: context.watch<DataProvider>().textStyle,
                        ),
                      if (messages.docs[index]
                              .data()['message']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['videoMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['audioMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['pdfMessage']
                              .toString()
                              .isEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          child: Container(
                            height: 200,
                            width: 450,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return Scaffold(
                                          extendBodyBehindAppBar: true,
                                          backgroundColor: Colors.transparent,
                                          appBar: AppBar(
                                            leading: GestureDetector(
                                              child: Icon(
                                                Icons.arrow_back_ios_new,
                                                color: Colors.white,
                                                size: 23,
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            titleSpacing: 5,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            /* title: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      height: 30,
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          'assets/loading-gif-.gif',
                                                      image:
                                                          listOfUsers[userindex]
                                                              ['userImageUrl'],
                                                    ),),
                                              ), */
                                          ),
                                          body: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: InteractiveViewer(
                                              child: FadeInImage.assetNetwork(
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    'assets/loading-gif-.gif',
                                                image: messages.docs[index]
                                                    .data()['imageMessage'],
                                              ),
                                            ),
                                          ));
                                    },
                                  ),
                                );
                              },
                              child: FadeInImage.assetNetwork(
                                height: 250,
                                width: 450,
                                fit: BoxFit.cover,
                                placeholder: 'assets/load.gif',
                                image:
                                    messages.docs[index].data()['imageMessage'],
                              ),
                            ),
                          ),
                        ),
                      if (messages.docs[index]
                              .data()['message']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['videoMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['imageMessage']
                              .toString()
                              .isEmpty &&
                          messages.docs[index]
                              .data()['pdfMessage']
                              .toString()
                              .isEmpty)
                        AudioComp(
                          url: messages.docs[index]
                              .data()['audioMessage']
                              .toString(),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          Dtime.formatYMED(
                            messages.docs[index]['timestamp'],
                          ),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.aBeeZee(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 2,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                  placeholder: 'assets/load.gif',
                  image: messages.docs[index].data()['userImage'],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
