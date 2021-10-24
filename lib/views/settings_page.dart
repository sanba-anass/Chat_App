import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Fontsize'),
            subtitle: Text(context.watch<DataProvider>().value),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => StatefulBuilder(builder: (context, setState) {
                  return SimpleDialog(
                    title: Text('FontSize'),
                    children: [
                      ListTile(
                        title: Text('Small'),
                        leading: Checkbox(
                          value: context.watch<DataProvider>().isSmall,
                          onChanged: (_) {
                            context.read<DataProvider>().value = 'Small';
                            this.setState(() {});
                            setState(() {
                              context.read<DataProvider>().isSmall =
                                  !context.read<DataProvider>().isSmall;
                              context.read<DataProvider>().isLarge = false;
                              context.read<DataProvider>().isMedium = false;
                              context.read<DataProvider>().mediumFont = 14;
                            });
                          },
                        ),
                      ),
                      ListTile(
                          title: Text('Medium'),
                          leading: Checkbox(
                            value: context.watch<DataProvider>().isMedium,
                            onChanged: (_) {
                              context.read<DataProvider>().value = 'Medium';
                              this.setState(() {});
                              setState(() {
                                context.read<DataProvider>().isMedium =
                                    !context.read<DataProvider>().isMedium;
                                context.read<DataProvider>().isLarge = false;
                                context.read<DataProvider>().isSmall = false;
                                context.read<DataProvider>().mediumFont = 16;
                              });
                            },
                          )),
                      ListTile(
                          title: Text('Large'),
                          leading: Checkbox(
                            value: context.watch<DataProvider>().isLarge,
                            onChanged: (_) {
                              context.read<DataProvider>().value = 'Large';
                              this.setState(() {});
                              setState(() {
                                context.read<DataProvider>().isLarge =
                                    !context.read<DataProvider>().isLarge;
                                context.read<DataProvider>().isSmall = false;
                                context.read<DataProvider>().isMedium = false;
                                context.read<DataProvider>().mediumFont = 21;
                              });
                            },
                          )),
                    ],
                  );
                }),
              );
            },
          ),
          ListTile(
            title: Text('Textcolor'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: Colors.green,
                      onColorChanged: (Color selectedcolor) {
                        context.read<DataProvider>().textColor = selectedcolor;
                        setState(() {});
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text('message bg color'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: Colors.green,
                      onColorChanged: (Color selectedcolor) {
                        context.read<DataProvider>().messageBg = selectedcolor;
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text('FontFamily'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => StatefulBuilder(builder: (context, setState) {
                  return SimpleDialog(
                    title: Text('FontFamily'),
                    children: [
                      ListTile(
                        title: Text('source code pro'),
                        leading: Checkbox(
                          value: context.watch<DataProvider>().isSourceCode,
                          onChanged: (_) {
                            this.setState(() {
                              context.read<DataProvider>().textStyle =
                                  GoogleFonts.sourceCodePro(
                                fontWeight: FontWeight.w600,
                                color: context.read<DataProvider>().textColor,
                                fontSize:
                                    context.read<DataProvider>().mediumFont,
                              );
                            });
                            setState(() {
                              context.read<DataProvider>().isSourceCode =
                                  !context.read<DataProvider>().isSourceCode;
                              context.read<DataProvider>().isAbeezee = false;
                              context.read<DataProvider>().isdefault = false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                          title: Text('aBeeZee'),
                          leading: Checkbox(
                            value: context.watch<DataProvider>().isAbeezee,
                            onChanged: (_) {
                              this.setState(() {
                                context.read<DataProvider>().textStyle =
                                    GoogleFonts.alef(
                                  color: context.read<DataProvider>().textColor,
                                  fontSize:
                                      context.read<DataProvider>().mediumFont,
                                  fontWeight: FontWeight.w600,
                                );
                              });
                              setState(() {
                                context.read<DataProvider>().isAbeezee =
                                    !context.read<DataProvider>().isAbeezee;
                                context.read<DataProvider>().isSourceCode =
                                    false;
                                context.read<DataProvider>().isdefault = false;
                              });
                            },
                          )),
                      ListTile(
                          title: Text('Default'),
                          leading: Checkbox(
                            value: context.watch<DataProvider>().isdefault,
                            onChanged: (_) {
                              this.setState(() {
                                context.read<DataProvider>().textStyle =
                                    GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600,
                                  color: context.read<DataProvider>().textColor,
                                  fontSize:
                                      context.read<DataProvider>().mediumFont,
                                );
                              });
                              setState(() {
                                context.read<DataProvider>().isdefault =
                                    !context.read<DataProvider>().isdefault;
                                context.read<DataProvider>().isSourceCode =
                                    false;
                                context.read<DataProvider>().isAbeezee = false;
                              });
                            },
                          )),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
