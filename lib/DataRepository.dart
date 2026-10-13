import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

// Repository pattern: one class that holds the user's data
// and knows how to load and save it.
class DataRepository {
  static String loginName = "";
  static String firstName = "";
  static String lastName = "";
  static String phoneNumber = "";
  static String emailAddress = "";

  // Load the variables from EncryptedSharedPreferences
  static Future<void> loadData() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    firstName = await prefs.getString("firstName");
    lastName = await prefs.getString("lastName");
    phoneNumber = await prefs.getString("phoneNumber");
    emailAddress = await prefs.getString("emailAddress");
  }

  // Save the variables to EncryptedSharedPreferences
  static void saveData() {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    prefs.setString("firstName", firstName);
    prefs.setString("lastName", lastName);
    prefs.setString("phoneNumber", phoneNumber);
    prefs.setString("emailAddress", emailAddress);
  }
}