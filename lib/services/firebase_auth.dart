import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/views/user_info.dart';
import 'package:fun_chat_app/views/verificationpage.dart';
import 'package:provider/provider.dart';

class FirebaseAuthService with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  String verificationId = '';
  String? result = '';
  String userId = '';
  var user;
  /*  */
  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        this.result = e.code;
        notifyListeners();
        print(e.code);
        print(e.message);
        switch (e.code) {
          case "invalid-phone-number":
            UiMethods.showalert(
                "you have entered an invalid phone number.Please try again.",
                context,
                'Oops!');
            Provider.of<DataProvider>(context, listen: false)
                .isloadingtofalse();
            break;
          case 'network-request-failed':
            UiMethods.showalert(
              'Please check your connection status and try again!',
              context,
              'No internet',
            );
            Provider.of<DataProvider>(context, listen: false)
                .isloadingtofalse();
            break;
          default:
            {
              UiMethods.showalert(
                  'something went wrong pls try again!', context);
              Provider.of<DataProvider>(context, listen: false)
                  .isloadingtofalse();
            }

            break;
        }
      },
      codeSent: (String id, int? resendToken) {
        this.verificationId = id;
        notifyListeners();
        print('code sent!!!');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => VerficationPage(),
            ),
            (route) => false);
      },
      codeAutoRetrievalTimeout: (String id) {
        this.verificationId = id;
        notifyListeners();
      },
    );
  }

  Future<void> verifyotp(String otp, BuildContext context) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otp);
    final data = await auth.signInWithCredential(credential);

    this.userId = data.user!.uid;
    this.user = data.user;
    print(this.user.toString() + ',,,,,,,,');
    notifyListeners();

    print(this.userId);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => UserInfoPage(),
        ),
        (route) => false);
  }
}
