import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/methods/ui_mehtods.dart';
import 'package:fun_chat_app/providers/auth_provider.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerficationPage extends StatefulWidget {
  @override
  State<VerficationPage> createState() => _VerficationPageState();
}

class _VerficationPageState extends State<VerficationPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final otpCode = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).otpCode;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                maxLength: 6,
                cursorColor: Colors.deepPurple.shade400,
                controller: otpCode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Code',
                  counterStyle: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade400,
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.deepPurple.shade400, width: 1.5),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple.shade400,
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  await context
                      .read<FirebaseAuthService>()
                      .verifyotp(otpCode.text.trim(), context);
                } catch (e) {
                  UiMethods.showalert('invalid code verification pls try again',
                      context, 'Oops!');
                  setState(() {
                    isLoading = false;
                  });
                }

                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
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
    );
  }
}
