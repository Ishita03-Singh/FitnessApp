import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';
import 'dart:convert';

class SpHelper {
  static late SharedPreferences pref;

  Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  Future writeSession(Session session) async {
    pref.setString(session.id.toString(), json.encode(session.toJson()));
  }

  List<Session> getSession() {
    List<Session> sessions = [];
    Set<String> keys = pref.getKeys();
    keys.forEach((String key) {
      if (key != 'counter') {
        Session session =
            Session.fromJson(json.decode(pref.getString(key) ?? ' '));
        sessions.add(session);
      }
    });

    return sessions;
  }

  Future setCounter() async {
    int counter = pref.getInt('counter') ?? 0;
    counter++;
    await pref.setInt('counter', counter);
  }

  int getCounter() {
    return pref.getInt('counter') ?? 0;
  }

  Future deleteSession(int id) async {
    pref.remove(id.toString());
  }
}
