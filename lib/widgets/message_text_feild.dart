import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:fun_chat_app/providers/auth_provider.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/widgets/widget_video_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class MessageTextFeild extends StatefulWidget {
  const MessageTextFeild({
    Key? key,
  }) : super(key: key);
  @override
  State<MessageTextFeild> createState() => _MessageTextFeildState();
}

class _MessageTextFeildState extends State<MessageTextFeild> {
  bool _isglowing = false;
  File? _userImageMessage;
  Duration duration = Duration();
  Timer? timer;
  bool _isRecording = false;
  bool isloading3 = false;
  Color _color = Colors.grey;
  FlutterSoundRecorder? _myRecorder;
  File? audioFile;
  File? _pickedvideo;

  var _isenabled = true;

  bool isenabled = true;

  Future<void> record() async {
    Directory dir = Directory(path.dirname(audioFile!.path));
    if (!dir.existsSync()) {
      dir.createSync();
    }
    _myRecorder!.openAudioSession();
    await _myRecorder!.startRecorder(
      toFile: audioFile!.path,
      codec: Codec.pcm16WAV,
    );
  }

  void startTimerRecord() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  void initState() {
    super.initState();
    startIt();
  }

  Text buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(
      duration.inMinutes.remainder(60),
    );
    final seconds = twoDigits(
      duration.inSeconds.remainder(60),
    );
    return Text(
      '$minutes:$seconds',
      style: GoogleFonts.raleway(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _myRecorder!.closeAudioSession();
    _myRecorder = null;
  }

  void startIt() async {
    audioFile = File('/sdcard/Download/temp.wav');
    _myRecorder = FlutterSoundRecorder();

    await _myRecorder!.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _myRecorder!.setSubscriptionDuration(Duration(milliseconds: 10));

    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<String?> stopRecord() async {
    _myRecorder!.closeAudioSession();

    return await _myRecorder!.stopRecorder();
  }

  void pickvideo(ImageSource source) async {
    final pickedVideo = await ImagePicker().pickVideo(source: source);
    if (pickedVideo != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: VideoFileWidget(
                        file: _pickedvideo!,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<DataProvider>().toggletotrue();
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currrentUserId)
                            .get();

                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('videos')
                            .child(
                              currrentUserId +
                                  (Random().nextDouble() * 1000000000000000)
                                      .toString() +
                                  '.mp4',
                            );

                        await ref.putFile(
                          _pickedvideo!,
                          SettableMetadata(contentType: 'video/mp4'),
                        );
                        final url = await ref.getDownloadURL();
                        await db.collection('messages').add({
                          'message': '',
                          'userId': currrentUserId,
                          'timestamp': Timestamp.now(),
                          'userImage': userData['userImageUrl'],
                          'userName': userData['userName'],
                          'imageMessage': '',
                          'videoMessage': url,
                          'audioMessage': '',
                          'video call message': '',
                          'pdfMessage': '',
                        });
                        context.read<DataProvider>().toggletofalse();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, right: 10),
                        height: 43,
                        width: 43,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }
    setState(() {
      _pickedvideo = File(pickedVideo!.path);
    });
  }

/*  
                   */
  void setuserImagefromcamera() async {
    final userimage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (userimage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        _userImageMessage!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<DataProvider>().toggletotrue();
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currrentUserId)
                            .get();

                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('image_Message')
                            .child(currrentUserId +
                                (Random().nextDouble() * 1000000000000)
                                    .toString() +
                                '.jpg');

                        await ref.putFile(_userImageMessage!);

                        final url = await ref.getDownloadURL();

                        await db.collection('messages').add({
                          'message': '',
                          'userId': currrentUserId,
                          'timestamp': Timestamp.now(),
                          'userImage': userData['userImageUrl'],
                          'userName': userData['userName'],
                          'imageMessage': url,
                          'videoMessage': '',
                          'audioMessage': '',
                          //'video call message': '',
                          'pdfMessage': '',
                        });
                        context.read<DataProvider>().toggletofalse();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, right: 10),
                        height: 43,
                        width: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.shade400,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }

    setState(() {
      _userImageMessage = File(userimage!.path);
    });
  }

  void setuserImagefromgallery() async {
    final userimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (userimage != null)
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        _userImageMessage!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<DataProvider>().toggletotrue();
                        final userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currrentUserId)
                            .get();

                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('image_Message')
                            .child(currrentUserId +
                                (Random().nextDouble() * 1000000000000)
                                    .toString() +
                                '.jpg');

                        await ref.putFile(_userImageMessage!);

                        final url = await ref.getDownloadURL();

                        await db.collection('messages').add({
                          'message': '',
                          'userId': currrentUserId,
                          'timestamp': Timestamp.now(),
                          'userImage': userData['userImageUrl'],
                          'userName': userData['userName'],
                          'imageMessage': url,
                          'videoMessage': '',
                          'audioMessage': '',
                          //video call message': '',
                          'pdfMessage': '',
                        });
                        context.read<DataProvider>().toggletofalse();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, right: 10),
                        height: 43,
                        width: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.shade400,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    setState(() {
      _userImageMessage = File(userimage!.path);
    });
  }

  bool _isloadingAudio = false;
  static final db = FirebaseFirestore.instance;
  static final currrentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final userMessage = Provider.of<AuthProvider>(context).usermessage;

    return Container(
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            padding: EdgeInsets.only(
              right: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.055,
            margin: EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            width: MediaQuery.of(context).size.width * 0.83,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black12,
                  offset: Offset(-5, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (_) {
                      setState(() {
                        _color = Colors.deepPurple.shade400;
                      });
                    },
                    autocorrect: false,
                    cursorColor: Colors.black,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      enabled: _isenabled,
                      hintText: _isRecording
                          ? buildTime().data
                          : 'Type your message...',
                      contentPadding: EdgeInsets.only(left: 20, bottom: 8),
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.raleway(
                        color: Colors.grey,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    controller: userMessage,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                _isRecording
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            duration = Duration(
                              minutes: 0,
                              seconds: 0,
                            );
                            timer!.cancel();
                            setState(() {
                              _isRecording = false;
                              _isRecording = false;
                              isenabled = true;
                              _isenabled = true;
                              stopRecord();
                            });
                          });
                        },
                        child: Text(
                          'cancel',
                          style: GoogleFonts.raleway(
                            color: Colors.deepPurple.shade400,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          UiMethods.showmodal(setuserImagefromcamera,
                              setuserImagefromgallery, context, pickvideo);
                        },
                        child: Icon(
                          FontAwesomeIcons.paperclip,
                          color: Colors.grey.shade400,
                          size: 22,
                        ),
                      ),
                SizedBox(
                  width: 15,
                ),
                _isRecording
                    ? TextButton(
                        onPressed: (_isRecording && isenabled)
                            ? null
                            : () async {
                                if (this.mounted)
                                  context.read<DataProvider>().toggletotrue();
                                setState(() {
                                  _isRecording = false;
                                  isenabled = true;
                                  _isenabled = true;
                                  duration = Duration(
                                    minutes: 0,
                                    seconds: 0,
                                  );
                                  timer!.cancel();
                                  stopRecord();
                                });

                                final userData = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(currrentUserId)
                                    .get();

                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('audios')
                                    .child(
                                      currrentUserId +
                                          (Random().nextDouble() *
                                                  1000000000000000)
                                              .toString() +
                                          '.aac',
                                    );

                                await ref.putFile(
                                  audioFile!,
                                  SettableMetadata(contentType: 'audio/mp3'),
                                );
                                final url = await ref.getDownloadURL();
                                await db.collection('messages').add({
                                  'message': '',
                                  'userId': currrentUserId,
                                  'timestamp': Timestamp.now(),
                                  'userImage': userData.get('userImageUrl'),
                                  'userName': userData['userName'],
                                  'imageMessage': '',
                                  'videoMessage': '',
                                  'audioMessage': url,
                                  'video call message': '',
                                  'pdfMessage': '',
                                });
                                context.read<DataProvider>().toggletofalse();
                              },
                        child: Text(
                          'send',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: (_isRecording && isenabled)
                                ? Colors.grey.shade400
                                : Colors.deepPurple.shade400,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          final String output =
                              userMessage.text.replaceAll(' ', '');
                          if (output == '') {
                            return;
                          }
                          final userData = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currrentUserId)
                              .get();
                          setState(() {
                            _color = Colors.grey;
                          });

                          await db.collection('messages').add({
                            'message': userMessage.text.trim(),
                            'userId': currrentUserId,
                            'timestamp': Timestamp.now(),
                            'userImage': userData['userImageUrl'],
                            'userName': userData['userName'],
                            'videoMessage': '',
                            'audioMessage': '',
                            //'video call message': '',
                            'pdfMessage': '',
                          });
                          _userImageMessage = null;
                          userMessage.clear();
                          // context.read<DataProvider>().setanmationtotrue();

                          final document = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currrentUserId);
                          final doc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currrentUserId)
                              .get();

                          await document.update({
                            'countMessage': doc['countMessage'] + 1,
                          });
                          context.read<DataProvider>().toggleisvisibletotrue();
                        },
                        child: Icon(
                          Icons.send,
                          color: userMessage.text.trim().isEmpty
                              ? Colors.grey.shade400
                              : Colors.deepPurple.shade400,
                          size: 24,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.018,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                stopRecord();
                setState(() {
                  timer!.cancel();
                  isenabled = false;
                });
              },
              onLongPress: () async {
                userMessage.clear();
                this.setState(() {
                  _isRecording = true;
                  _isenabled = false;
                });

                startTimerRecord();
                record();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _isRecording
                      ? Text(
                          'stop',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      : Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 25,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
