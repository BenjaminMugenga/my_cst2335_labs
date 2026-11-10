// The current language for the whole app ("en" or "fr")
String currentLanguage = "en";

// Every piece of text in the app, in both languages
const Map<String, Map<String, String>> _text = {
  "en": {
    "title": "Login Page",
    "loginName": "Login name",
    "password": "Password",
    "loginButton": "Login",
    "switchButton": "Français",
    "profileTitle": "Profile Page",
    "welcomeBack": "Welcome Back",
    "firstName": "First Name",
    "lastName": "Last Name",
    "phoneNumber": "Phone Number",
    "emailAddress": "Email address",
    "notSupportedTitle": "Not supported",
    "notSupportedMsg": "This URL is not supported on this device:",
    "ok": "OK",
  },
  "fr": {
    "title": "Page de connexion",
    "loginName": "Nom d'utilisateur",
    "password": "Mot de passe",
    "loginButton": "Connexion",
    "switchButton": "English",
    "profileTitle": "Page de profil",
    "welcomeBack": "Bon retour",
    "firstName": "Prénom",
    "lastName": "Nom de famille",
    "phoneNumber": "Numéro de téléphone",
    "emailAddress": "Adresse email",
    "notSupportedTitle": "Non pris en charge",
    "notSupportedMsg": "Cette URL n'est pas prise en charge sur cet appareil :",
    "ok": "OK",
  },
};

// Looks up a word in the current language.
// Example: translate("firstName") -> "First Name" or "Prénom"
String translate(String key) {
  return _text[currentLanguage]![key] ?? key;
}

// Flips between English and French
void switchLanguage() {
  currentLanguage = (currentLanguage == "en") ? "fr" : "en";
}