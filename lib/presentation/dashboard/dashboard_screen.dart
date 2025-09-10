import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../util/map_services.dart';
import '../../util/rayzorpay_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MapServices _mapServices = MapServices.instance;
  late RazorpayService _razorpayService;
  bool _isLoading = false;
  String _address = '';
  double? _latitude;
  double? _longitude;
  String _errorMessage = '';
  DateTime? _lastUpdated;
  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService(
      onPaymentSuccess: (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Success: ${success.paymentId}")),
        );
      },
      onPaymentError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: ${error.message}")),
        );
      },
      onExternalWallet: (wallet) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("External Wallet: ${wallet.walletName}")),
        );
      },
    );
  }

  void _startPayment() {
    _razorpayService.openCheckout(
      apiKey: "rzp_test_xxxxxxxxxx", // Replace with your key
      orderId: "order_DBJOWzybf0sJbb", // From backend
      amount: "10000", // 100 INR in paisa
      name: "Testing App",
      description: "Test Transaction",
      contact: "9999999999",
      email: "test@example.com",
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _startPayment,
                child: const Text("Pay ₹100"),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 50,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Find My Location',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Get your current address instantly',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            
                    const SizedBox(height: 30),
            
                    // Get Location Button
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _getCurrentLocation,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.my_location),
                      label: Text(_isLoading ? 'Getting Location...' : 'Get Current Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                    ),
            
                    const SizedBox(height: 30),
            
                    // Location Information Card
                    if (_address.isNotEmpty || _errorMessage.isNotEmpty)
                      Expanded(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Error Message
                                  if (_errorMessage.isNotEmpty) ...[
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.red.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error, color: Colors.red.shade600),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _errorMessage,
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
            
                                  // Success Information
                                  if (_address.isNotEmpty) ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade600,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Location Found!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
            
                                    // Address
                                    _buildInfoRow('Address', _address, Icons.location_on),
                                    const SizedBox(height: 15),
            
                                    // Coordinates
                                    if (_latitude != null && _longitude != null) ...[
                                      _buildInfoRow(
                                          'Latitude',
                                          _latitude!.toStringAsFixed(6),
                                          Icons.explore
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInfoRow(
                                          'Longitude',
                                          _longitude!.toStringAsFixed(6),
                                          Icons.explore_outlined
                                      ),
                                      const SizedBox(height: 15),
                                    ],
            
                                    // Last Updated
                                    if (_lastUpdated != null) ...[
                                      _buildInfoRow(
                                          'Last Updated',
                                          '${_lastUpdated!.hour.toString().padLeft(2, '0')}:${_lastUpdated!.minute.toString().padLeft(2, '0')}:${_lastUpdated!.second.toString().padLeft(2, '0')}',
                                          Icons.access_time
                                      ),
                                      const SizedBox(height: 20),
                                    ],
            
                                    // Copy Address Button
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _copyToClipboard(_address),
                                        icon: const Icon(Icons.copy),
                                        label: const Text('Copy Address'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green.shade600,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _address = '';
      _latitude = null;
      _longitude = null;
      _lastUpdated = null;
    });

    try {
      Map<String, dynamic> result = await _mapServices.getCurrentLocationAddress();

      if (result['success']) {
        setState(() {
          _address = result['address'];
          _latitude = result['latitude'];
          _longitude = result['longitude'];
          _lastUpdated = DateTime.now();
        });
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Unknown error occurred';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Address copied to clipboard!'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}