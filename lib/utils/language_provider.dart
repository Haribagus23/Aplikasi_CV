import 'package:flutter/material.dart';
import 'app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isIndonesian = false;

  bool get isIndonesian => _isIndonesian;

  AppStrings get strings => AppStrings(_isIndonesian);

  void toggleLanguage() {
    _isIndonesian = !_isIndonesian;
    notifyListeners();
  }
}

class LanguageScope extends InheritedWidget {
  final LanguageProvider notifier;

  const LanguageScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  static LanguageProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LanguageScope>();
    assert(scope != null, 'No LanguageScope found in context');
    return scope!.notifier;
  }

  @override
  bool updateShouldNotify(LanguageScope oldWidget) {
    return notifier != oldWidget.notifier;
  }
}
