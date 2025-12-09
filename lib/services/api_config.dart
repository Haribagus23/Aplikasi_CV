class ApiConfig {
  // Toggle this for production
  static const bool isProduction = true;

  static const String _baseUrlDev =
      "https://nonpunitory-longstanding-iesha.ngrok-free.dev";
  static const String _baseUrlProd = "https://haribagusdev.my.id";

  static String get baseUrl => isProduction ? _baseUrlProd : _baseUrlDev;

  static String get ratingsEndpoint => "$baseUrl/api/rating";
}
