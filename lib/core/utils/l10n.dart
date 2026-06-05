class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome Back!',
      'new_order': 'New Order',
      'wallet_balance': 'Wallet Balance',
    },
    'sw': {
      'welcome': 'Karibu Tena!',
      'new_order': 'Agizo Jipya',
      'wallet_balance': 'Salio la Wallet',
    },
  };

  static String get(String key, String locale) {
    return _localizedValues[locale]?[key] ?? key;
  }
}
