import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:fun_chat_app/providers/auth_provider.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';
import 'package:fun_chat_app/views/home_page.dart';
import 'package:fun_chat_app/views/message_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final countryNumber =
        Provider.of<AuthProvider>(context, listen: false).countryNumber;
    final phoneNumber =
        Provider.of<AuthProvider>(context, listen: false).phoneNumber;
    final verfiyNumber =
        Provider.of<FirebaseAuthService>(context, listen: false)
            .verifyPhoneNumber;
    return StreamBuilder<User?>(
        stream: userAuth,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return  MessageDetailsPage();
          }  
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple.shade400,
              centerTitle: true,
              title: Text(
                'Enter your phone number',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  Consumer<AuthProvider>(builder: (context, snapshot, child) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            cursorColor: Colors.deepPurple.shade400,
                            keyboardType: TextInputType.phone,
                            controller: countryNumber,
                            decoration: InputDecoration(
                              hintText: '+...',
                              contentPadding: EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400,
                                    width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 280,
                          child: TextField(
                            cursorColor: Colors.deepPurple.shade400,
                            keyboardType: TextInputType.phone,
                            controller: phoneNumber,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400,
                                    width: 1.5),
                              ),
                              hintText: 'phone number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple.shade400,
                        ),
                        child: context.watch<DataProvider>().isloading
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
                        onPressed: () async {
                          if (countryNumber.text.isEmpty ||
                              phoneNumber.text.isEmpty ||
                              countryNumber.text[0] != '+') {
                            UiMethods.showalert(
                                "you have entered an invalid phone number.Please try again.",
                                context,
                                'Oops!');
                          } else
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                contentPadding:
                                    EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                                actions: [
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                        Colors.deepPurple.shade400,
                                      ),
                                    ),
                                    child: Text(
                                      'EDIT',
                                      style: GoogleFonts.raleway(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Colors.deepPurple.shade400,
                                        ),
                                      ),
                                      child: Text(
                                        "OK",
                                        style: GoogleFonts.raleway(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Provider.of<DataProvider>(context,
                                                listen: false)
                                            .isloadingtotrue();
                                        Navigator.pop(context);
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await verfiyNumber(
                                          '${countryNumber.text.trim()} ${phoneNumber.text.trim()}',
                                          context,
                                        );
                                      }),
                                ],
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'You entered the phone number:',
                                      style: GoogleFonts.raleway(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${countryNumber.text.trim()} ${phoneNumber.text.trim()}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'is this OK?,or would you like to edit the number',
                                      style: GoogleFonts.raleway(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
