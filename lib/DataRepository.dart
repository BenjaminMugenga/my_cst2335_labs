import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

// Repository pattern: one class that holds the user's data
// and knows how to load and save it.
class DataRepository {
  static String loginName = "";
  static String firstName = "";
  static String lastName = "";
  static String phoneNumber = "";
  static String emailAddress = "";

  // ONE shared EncryptedSharedPreferences object for the whole app
  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Load the variables from EncryptedSharedPreferences
  static Future<void> loadData() async {
    try {
      firstName = await _prefs.getString("firstName");
      lastName = await _prefs.getString("lastName");
      phoneNumber = await _prefs.getString("phoneNumber");
      emailAddress = await _prefs.getString("emailAddress");
      print("LOADED: $firstName | $lastName | $phoneNumber | $emailAddress");
    } catch (e) {
      print("LOAD ERROR: $e");
    }
  }

  // Save the variables to EncryptedSharedPreferences
  static Future<void> saveData() async {
    try {
      await _prefs.setString("firstName", firstName);
      await _prefs.setString("lastName", lastName);
      await _prefs.setString("phoneNumber", phoneNumber);
      await _prefs.setString("emailAddress", emailAddress);
      print("SAVED: $firstName | $lastName | $phoneNumber | $emailAddress");
    } catch (e) {
      print("SAVE ERROR: $e");
    }
  }
}