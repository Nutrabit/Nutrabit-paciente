import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<bool?> getdontShowAgain() async {
    final prefs = await SharedPreferences.getInstance();
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
}