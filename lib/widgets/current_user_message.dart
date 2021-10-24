import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/utils/date.dart';
import 'package:fun_chat_app/views/pdf_page.dart';
import 'package:fun_chat_app/views/record.dart';
import 'package:fun_chat_app/widgets/video_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CurrentUserMessage extends StatelessWidget {
  final QuerySnapshot<Map<String, dynamic>> messages;
  final int index;

  CurrentUserMessage({Key? key, required this.messages, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listOfUsers =
        Provider.of<DataProvider>(context, listen: false).listOfUsers;
    final userindex = Provider.of<DataProvider>(context, listen: false).index;

    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Flexible(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: FadeInImage.assetNetwork(
                height: 35,
                width: 35,
                fit: BoxFit.cover,
                placeholder: 'assets/load.gif',
                image: messages.docs[index].data()['userImage'],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          'warning!',
                          style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Do you want to remove this message?',
                          style: GoogleFonts.raleway(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.raleway(
                                color: Colors.deepPurple.shade400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              await messages.docs[index].reference.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 1400),
                                  content: Text(
                                    'message has been removed!',
                                    style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Remove',
                              style: GoogleFonts.raleway(
                                color: Colors.deepPurple.shade400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.watch<DataProvider>().messageBg),
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
                          Text(messages.docs[index]['message'],
                              style: context.watch<DataProvider>().textStyle,),
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
                        if (messages.docs[index]
                                .data()['message']
                                .toString()
                                .isEmpty &&
                            messages.docs[index]
                                .data()['pdfMessage']
                                .toString()
                                .isEmpty &&
                            messages.docs[index]
                                .data()['videoMessage']
                                .toString()
                                .isEmpty &&
                            messages.docs[index]
                                .data()['audioMessage']
                                .toString()
                                .isEmpty)
                          Container(
                            height: 180,
                            width: 700,
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return Scaffold(
                                          extendBodyBehindAppBar: true,
                                          backgroundColor: Colors.transparent,
                                          appBar: AppBar(
                                              titleSpacing: 5,
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              leading: GestureDetector(
                                                child: Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: Colors.white,
                                                  size: 23,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              )),
                                          body: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: InteractiveViewer(
                                              child: FadeInImage.assetNetwork(
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: 'assets/load.gif',
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
                                width: 700,
                                fit: BoxFit.cover,
                                placeholder: 'assets/load.gif',
                                placeholderScale: 0.5,
                                image:
                                    messages.docs[index].data()['imageMessage'],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
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
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.access_time,
                    color: Colors.grey.shade600,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
