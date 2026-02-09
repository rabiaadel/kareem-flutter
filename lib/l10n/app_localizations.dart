import 'package:flutter/material.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // All localized strings
  String get appName;
  String get welcome;
  String get getStarted;
  String get skip;
  String get next;
  String get back;
  String get done;
  String get save;
  String get cancel;
  String get delete;
  String get edit;
  String get share;
  String get send;
  String get confirm;
  String get yes;
  String get no;
  String get ok;
  String get close;
  String get loading;
  String get error;
  String get success;
  String get tryAgain;

  String get onboarding1Title;
  String get onboarding1Description;
  String get onboarding2Title;
  String get onboarding2Description;
  String get onboarding3Title;
  String get onboarding3Description;

  String get selectRole;
  String get iAmParent;
  String get iAmDoctor;
  String get parentDescription;
  String get doctorDescription;

  String get login;
  String get signup;
  String get logout;
  String get email;
  String get password;
  String get confirmPassword;
  String get name;
  String get phone;
  String get forgotPassword;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get signupNow;
  String get loginNow;

  String get home;
  String get community;
  String get chats;
  String get aiHelper;
  String get analysis;
  String get profile;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'ar') {
      return AppLocalizationsAr();
    }
    return AppLocalizationsEn();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}