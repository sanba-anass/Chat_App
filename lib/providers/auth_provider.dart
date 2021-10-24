import 'package:flutter/cupertino.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final phoneNumber = TextEditingController();
  final countryNumber = TextEditingController();
  final otpCode = TextEditingController();
  final userName = TextEditingController();
  final usermessage = TextEditingController();

  bool isLoading = false;
}
