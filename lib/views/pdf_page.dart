import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFPage extends StatefulWidget {
  final String url;
  const PDFPage({Key? key, required this.url}) : super(key: key);
  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void requestPersmission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPersmission();
    getFileFromUrl(widget.url).then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = true;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
      return Stack(
        children: [
          Container(
            height: 80,
            width: 250,
            child: PDFView(
              filePath: urlPDFPath,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              onError: (e) {
                /*  */
              },
              onRender: (_pages) {
                setState(() {
                  _totalPages = _pages!;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                setState(() {
                  _pdfViewController = vc;
                });
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                });
              },
              onPageError: (page, e) {},
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Page(
                          url: widget.url,
                        )),
              );
            },
            child: Text(
              'open pdf',
              style: TextStyle(color: Colors.greenAccent.shade400),
            ),
          )
        ],
      );
    }
    return Container(
      height: 80,
      width: 250,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  final String url;
  const Page({Key? key, required this.url}) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void requestPersmission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPersmission();
    getFileFromUrl(widget.url).then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = true;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController!.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController!.setPage(_currentPage);
                  }
                });
              },
            ),
          ],
        ),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {},
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages!;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page!;
            });
          },
          onPageError: (page, e) {},
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}
