class AIService {
  // Mock AI Demand Forecasting
  static Future<Map<String, dynamic>> forecastDemand(String branchId) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'expected_orders': 45,
      'peak_hours': '10:00 AM - 2:00 PM',
      'recommended_staff': 4,
      'confidence': 0.85,
    };
  }

  // Mock AI Stain Detection
  static Future<List<String>> detectStains(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2));
    return ['Oil Stain', 'Coffee Spill'];
  }
}
