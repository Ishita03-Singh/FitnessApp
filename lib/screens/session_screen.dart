import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/session.dart';
import 'package:flutter_application_1/data/sp_helper.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final SpHelper helper = SpHelper();
  List<Session> sessions = [];

  @override
  void initState() {
    helper.init().then((_) {
      updateSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Training')),
        body: ListView(children: getContent()),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showSessionDialog(context);
            }));
  }

  Future<dynamic> showSessionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insert Training Data'),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(
                  controller: txtDescription,
                  decoration:
                      InputDecoration(hintText: 'Training Description '),
                ),
                TextField(
                  controller: txtDuration,
                  decoration: InputDecoration(hintText: 'Training Duration '),
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    txtDescription.text = '';
                    txtDuration.text = '';
                  },
                  child: Text('Cancel')),
              ElevatedButton(onPressed: saveSession, child: Text('Save'))
            ],
          );
        });
  }

  Future saveSession() async {
    DateTime now = DateTime.now();
    String today = '${now.year}-${now.month}-${now.day}';
    int id = helper.getCounter() + 1;

    Session newSession = Session(
        id, today, txtDescription.text, int.tryParse(txtDuration.text) ?? 0);

    helper.writeSession(newSession).then((_) {
      updateSession();
      helper.setCounter();
    });
    txtDescription.text = '';
    txtDuration.text = '';
    Navigator.pop(context);
  }

  List<Widget> getContent() {
    List<Widget> tiles = [];
    sessions.forEach((session) {
      tiles.add(Dismissible(
        key: UniqueKey(),
        onDismissed: (_) {
          helper.deleteSession(session.id).then((value) {
            updateSession();
          });
        },
        child: ListTile(
            title: Text(session.description),
            subtitle:
                Text('${session.date}   duration:${session.duration} mins')),
      ));
    });

    return tiles;
  }

  void updateSession() {
    sessions = helper.getSession();
    setState(() {});
  }
}
