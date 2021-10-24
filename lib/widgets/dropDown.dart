import 'package:flutter/material.dart';
import 'package:fun_chat_app/views/profile_page.dart';
import 'package:fun_chat_app/views/settings_page.dart';

/// This is the stateful widget that the main application instantiates.
class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

/// This is the private State class that goes with DropDown.
class _DropDownState extends State<DropDown> {
  String dropdownValue = 'Settings';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? newValue) {
          /* setState(() {
            dropdownValue = newValue!;
          }); */
          if (newValue == 'Settings') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsPage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(),
              ),
            );
          }
        },
        items: <String>[
          'Profile',
          'Settings',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
