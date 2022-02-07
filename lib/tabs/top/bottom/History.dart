import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Websearch.dart';

class History extends StatelessWidget {
  final String text;
  final String link;
  const History({Key? key, required this.text, required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFF151515);
    final barColor = const Color(0xFFE94C21);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          children: [
            TextFormField(
              initialValue: text,
              showCursor: true,
              readOnly: true,
              cursorColor: Colors.black,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              minLines: 1,
              maxLines: 22,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(20, 80, 20, 80),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                //borderSide: BorderSide(color: Colors.orange)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 2.0)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          backgroundColor: barColor,
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GoogleScreen(
                      link: link,
                    )));
            Clipboard.setData(ClipboardData(text: text));
          },
          heroTag: null,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(padding: const EdgeInsets.all(8.0)),
        FloatingActionButton(
          backgroundColor: barColor,
          child: Icon(Icons.copy),
          onPressed: () async {
            Clipboard.setData(ClipboardData(text: text));
            Scaffold.of(context).showSnackBar(SnackBar(
                duration: Duration(microseconds: 1000),
                content: Text('Copied to Clipboard')));
          },
          heroTag: null,
        )
      ]),
    );
  }
}
