import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypto_helper.dart';

late PreferenceManager _preferenceManagerInstance;

PreferenceManager get _preferenceManager => _preferenceManagerInstance;

Future<void> initPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _preferenceManagerInstance = PreferenceManagerImpl(prefs);
}

var preferenceManagerProvider = Provider(
      (ref) {
    return _preferenceManager;
  },
);

class PreferenceManagerImpl implements PreferenceManager {
  final SharedPreferences? _pref;

  PreferenceManagerImpl(this._pref);

  @override
  Future<bool> removePreference(String key) {
    try {
      return _pref?.remove(key) ?? Future.value(false);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> saveString(String key, String value) {
    try {
      String encryptValue = CryptoHelper.encryptText(value);
      return _pref?.setString(key, encryptValue) ?? Future.value(false);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  String? getStringOrNull(String key) {
    try {
      String? encryptValue = _pref?.getString(key);
      return encryptValue != null ? CryptoHelper.decryptText(encryptValue) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  String getStringOrEmpty(String key) {
    try {
      var value = _pref?.getString(key);
      return value != null ? CryptoHelper.decryptText(value) : "";
    } catch (e) {
      return "";
    }
  }

  @override
  Future<bool> saveInt(String key, int value) {
    var response = _pref?.setInt(key, value) ?? Future.value(false);
    return response;
  }

  @override
  int getInt(String key) {
    try {
      var value = _pref?.getInt(key);
      if (value != null) {
        if (kDebugMode) print("Preference initialized");
        return value;
      } else {
        throw Exception("No key available for fetching preference data");
      }
    } catch (e) {
      debugPrint(e.toString());
      return -1;
    }
  }

  @override
  Future<bool> removeAllPreference() {
    return _pref!.clear();
  }

  @override
  bool getBool(String key) {
    try {
      var value = _pref?.getBool(key);
      return value ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveBool(String key, bool value) {
    var response = _pref?.setBool(key, value) ?? Future.value(false);
    return response;
  }
}
