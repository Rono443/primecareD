import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio = Dio();
  
  // Mock M-Pesa STK Push
  Future<bool> initiateStkPush(String phoneNumber, double amount) async {
    // In a real app, you'd call your backend which interacts with Safaricom Daraja API
    print('Initiating STK Push to $phoneNumber for KES $amount');
    
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Return true for success mock
    return true;
  }

  Future<String?> checkTransactionStatus(String checkoutRequestId) async {
    // Mock status check
    return 'Success';
  }
}
