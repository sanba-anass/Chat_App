import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataProvider extends ChangeNotifier {
  int? index;
  var listOfUsers;
  bool issent = false;
  int? index2;
  bool isloadingImage = false;
  bool isloadingVideocall = false;
  bool isvisible = false;
  int count = 0;
  bool isloading = false;
  bool isSmall = false;
  bool isLarge = false;
  bool isMedium = true;
  double smallFont = 14;
  double mediumFont = 18;
  double lARGEFont = 21;
  String value = 'Medium';
  Color textColor = Colors.white;
  bool isSourceCode = false;
  bool isAbeezee = false;
  bool isdefault = true;
  TextStyle textStyle = GoogleFonts.raleway(
    color: Colors.white,
    fontSize: 16,
     fontWeight: FontWeight.w600,
  );
  Color messageBg = Colors.deepPurple.shade400;
  void setanmationtoflase() {
    issent = false;
    notifyListeners();
  }

  void setanmationtotrue() {
    issent = true;
    notifyListeners();
  }

  void togglevctofalse() {
    isloadingVideocall = false;
    notifyListeners();
  }

  void togglevctotrue() {
    isloadingVideocall = true;
    notifyListeners();
  }

  void toggletofalse() {
    isloadingImage = false;
    notifyListeners();
  }

  void toggletotrue() {
    isloadingImage = true;
    notifyListeners();
  }

  void toggleisvisibletotrue() {
    isvisible = true;
    notifyListeners();
  }

  void toggleisvisibletofalse() {
    isvisible = false;
    notifyListeners();
  }

  void increasecount() {
    count++;
    notifyListeners();
  }

  void resetcount() {
    count = 0;
    notifyListeners();
  }

  void isloadingtofalse() {
    isloading = false;
    notifyListeners();
  }

  void isloadingtotrue() {
    isloading = true;
    notifyListeners();
  }
}
