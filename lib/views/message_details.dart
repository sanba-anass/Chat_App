import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';
import 'package:fun_chat_app/widgets/dropDown.dart';
import 'package:fun_chat_app/widgets/messages.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/widgets/message_text_feild.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessageDetailsPage extends StatefulWidget {
  MessageDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  static final db = FirebaseFirestore.instance;
  Stream<User?>? userAuth;

  @override
  void initState() {
    super.initState();
    /* FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MessageDetailsPage(),
          ),
          (route) => false,
        );
    }); */

    userAuth = FirebaseAuth.instance.authStateChanges();
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  static final currrentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final loading = Provider.of<DataProvider>(context).isloadingImage;
    final user = Provider.of<FirebaseAuthService>(context, listen: false).user;

    /*  final listOfUsers =
        Provider.of<DataProvider>(context, listen: false).listOfUsers; */
    // final index = Provider.of<DataProvider>(context, listen: false).index;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/buimade52352.jpg',
                height: double.infinity,
                width: double.infinity,
              ).image,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.0),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.deepPurple.shade400,
                  actions: [
                    DropDown(),
                    loading
                        ? Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 26,
                            width: 26,
                            child: FittedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 5.0,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                  title: Text('rodemon'),
                ),
                body: StreamBuilder<User?>(
                    stream: userAuth,
                    builder: (context, snapshot) {
                      if (snapshot.data != null)
                        return Column(
                          children: [
                            Expanded(
                              child: Messages(),
                            ),
                            MessageTextFeild(),
                          ],
                        );
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ));
  }
  //final _infoStrings = <String>[];

  //FlutterSoundRecorder? _myRecorder;
  File? audioFile;
  //final _channelController = TextEditingController();
  //final _users = <int>[];

  bool muted = false;
  //late RtcEngine _engine;

  // ClientRole? _role = ClientRole.Broadcaster;
  bool isloading = false;

  /* void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }
 */
  /* Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(Token, 'chatChannel', null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  @override
  void dispose() {
    super.dispose();

    _channelController.dispose();
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  } */

  Future<void> onJoin() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.purpleAccent.shade400,
                    strokeWidth: 3.0,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'processing...',
                  style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        });
    //await _handleCameraAndMic(Permission.camera);
    //await _handleCameraAndMic(Permission.microphone);
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currrentUserId)
        .get();

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
      'video call message':
          userData['userName'].toString() + ' is calling you...',
    });
    Navigator.pop(context);
    /* await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: "chatChannel",
          role: _role,
        ),
      ),
    );
   
  } */
  }
}
