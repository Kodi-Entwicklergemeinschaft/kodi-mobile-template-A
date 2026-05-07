abstract class PreferenceManager {
  /// Function to add/set a string in preference
  Future<bool> saveString(String key, String value);
  Future<bool> saveBool(String key, bool value);

  /// Function to remove [key] from preference
  Future<bool> removePreference(String key);

  /// Function to remove all [key] from preference
  Future<bool> removeAllPreference();

  /// Function to read a string from preference using [key],
  /// it returns stored value if exist otherwise returns null
  String? getStringOrNull(String key);

  /// Function to return the value for [key] if exist otherwise it will return empty string
  String getStringOrEmpty(String key);

  /// Function to save the integer value in preference
  Future<bool> saveInt(String key, int value);

  /// Function to get the integer value from preference,
  /// in case of any error it will return default value (i.e. -1)
  int getInt(String key);

  bool getBool(String key);
}
