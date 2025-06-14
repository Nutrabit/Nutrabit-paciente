import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<bool?> getdontShowAgain() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('dontShowAgain') == null){
      setdontShowAgain(false);
    }
    return prefs.getBool('dontShowAgain');
  }


  Future<void> setdontShowAgain(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dontShowAgain', value);
  }

  Future<void> dontShowAgain(bool isSelected) async {
    final value = await getdontShowAgain();
    if (isSelected == true &&  value == false) {
      await setdontShowAgain(true);
    } else {
      await setdontShowAgain(false);
    }
  }  

  Future<void> setLastSeenNotifications(DateTime lastSeen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSeenNotf', lastSeen.toIso8601String());
  }

  Future<DateTime> getLastSeenNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeenNots = prefs.getString('lastSeenNotf');
    return lastSeenNots != null ? DateTime.parse(lastSeenNots) : DateTime.parse('1900-01-01');
  }
}