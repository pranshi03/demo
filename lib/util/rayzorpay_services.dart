import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// A reusable Razorpay service that can be used across the project.
class RazorpayService {
  Razorpay? _razorpay;

  /// Callbacks
  final void Function(PaymentSuccessResponse)? onPaymentSuccess;
  final void Function(PaymentFailureResponse)? onPaymentError;
  final void Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayService({
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onExternalWallet,
  }) {
    _razorpay = Razorpay();

    // Register event listeners
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Opens the Razorpay checkout screen.
  void openCheckout({
    required String apiKey,
    required String orderId, // Generated from backend
    required String amount, // in paisa (e.g., 100 INR = 10000)
    required String name,
    required String description,
    required String contact,
    required String email,
    String currency = "INR",
    Map<String, dynamic>? additionalOptions,
  }) {
    try {
      var options = {
        'key': apiKey,
        'order_id': orderId,
        'amount': amount,
        'currency': currency,
        'name': name,
        'description': description,
        'prefill': {
          'contact': contact,
          'email': email,
        },
        'theme': {
          'color': '#3399cc',
        },
      };


      _razorpay?.open(options);
    } catch (e) {
      debugPrint("Razorpay Checkout Error: $e");
    }
  }

  /// Success Handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Success: ${response.paymentId}");
    onPaymentSuccess?.call(response);
  }

  /// Error Handler
  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Error: ${response.code} - ${response.message}");
    onPaymentError?.call(response);
  }

  /// External Wallet Handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
    onExternalWallet?.call(response);
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay?.clear();
  }
}
