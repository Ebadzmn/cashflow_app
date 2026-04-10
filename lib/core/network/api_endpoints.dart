class ApiEndpoints {
  static const String baseUrl = 'http://10.10.7.106:5001/api/v1';
  static const String login = '/auth/login';
  static const String signup = '/user'; // Updated for registration API
  static const String profile = '/user/profile';
  static const String income = '/income';
  static const String expense = '/expense';
  static const String incomeHistory = '/income/history';
  static const String expenseHistory = '/expense/history';
  static const String ocrAnalyze = '/ocr/analyze';
  static const String termsConditions = '/terms-and-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String bankTransaction = '/bank-transaction';
  static const String verifyEmail = '/auth/verify-email';
  static const String refreshToken = '/auth/refresh';
}
