class ApiEndPoints {

  ApiEndPoints._();

  static bool isInitialised = false;

  static String baseUrl = 'https://consumerapp.livesorted.com';

  // static String baseUrl = 'https://consumerapp-dev.livesorted.com';
  static String createUser = '/auth/user/create';
  static String sendOtp = '/auth/otp';
  static String verifyOtp = '/auth/verify-otp';
  static String consumer = '/api/rest/consumer';
  static String profileUpdate = '/auth/user';
  static String addresses = '/auth/addresses';
  static String refresh = "/auth/refresh";
}