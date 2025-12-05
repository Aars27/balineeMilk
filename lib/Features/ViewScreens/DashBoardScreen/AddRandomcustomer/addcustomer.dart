import 'package:balineemilk/Core/Constant/app_colors.dart';
import 'package:balineemilk/Core/Constant/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../Components/Savetoken/SaveToken.dart';

// Add Customer Screen
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController();

  bool _isLoading = false;
  String _latitude = "";
  String _longitude = "";
  bool _fetchingLocation = false;

  // Category & Product
  List<dynamic> _categories = [];
  List<dynamic> _products = [];
  bool _loadingCategories = false;
  bool _loadingProducts = false;

  int? _selectedCategoryId;
  int? _selectedProductId;
  double _pricePerLiter = 0.0;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchCategories();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // Fetch Categories
  Future<void> _fetchCategories() async {
    setState(() => _loadingCategories = true);

    try {
      final dio = await TokenHelper().getDioClient();
      final response = await dio.get('/category_master');

      if (response.statusCode == 200 && response.data["flag"] == true) {
        setState(() {
          _categories = response.data["data"];
        });
      }
    } catch (e) {
      print("❌ Error fetching categories: $e");
      Fluttertoast.showToast(
        msg: "Failed to load categories",
        backgroundColor: Colors.red,
      );
    }

    setState(() => _loadingCategories = false);
  }

  // Fetch Products by Category
  Future<void> _fetchProducts(int categoryId) async {
    setState(() {
      _loadingProducts = true;
      _products = [];
      _selectedProductId = null;
      _pricePerLiter = 0.0;
      _totalPrice = 0.0;
      _quantityController.clear();
    });

    try {
      final dio = await TokenHelper().getDioClient();
      final response = await dio.get('/products/$categoryId');

      if (response.statusCode == 200 && response.data["flag"] == true) {
        setState(() {
          _products = response.data["data"];
        });
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
      Fluttertoast.showToast(
        msg: "Failed to load products",
        backgroundColor: Colors.red,
      );
    }

    setState(() => _loadingProducts = false);
  }

  // Calculate total price
  void _calculateTotal() {
    if (_quantityController.text.isNotEmpty && _pricePerLiter > 0) {
      setState(() {
        _totalPrice = double.parse(_quantityController.text) * _pricePerLiter;
      });
    } else {
      setState(() => _totalPrice = 0.0);
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() => _fetchingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude.toStringAsFixed(6);
        _longitude = position.longitude.toStringAsFixed(6);
      });

      Fluttertoast.showToast(
        msg: "Location fetched successfully",
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to get location: $e",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      print("❌ Location error: $e");
    }

    setState(() => _fetchingLocation = false);
  }

  // Submit form
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude.isEmpty || _longitude.isEmpty) {
      Fluttertoast.showToast(
        msg: "Location not available. Please try again.",
        backgroundColor: Colors.orange,
      );
      _getCurrentLocation();
      return;
    }

    if (_selectedProductId == null) {
      Fluttertoast.showToast(
        msg: "Please select a product",
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = await TokenHelper().getDioClient();

      final requestData = {
        "first_name": _firstNameController.text.trim().toString(),
        "last_name": _lastNameController.text.trim().toString(),
        "mobile_no": _mobileController.text.trim().toString(),
        "address": _addressController.text.trim().toString(),
        "lat": _latitude.toString(),
        "lng": _longitude.toString(),
        "category_id": _selectedCategoryId,
        "product_id": _selectedProductId,
        "rate": _pricePerLiter,
        "amount": _totalPrice,
        "ordered_qty": double.parse(_quantityController.text.trim()),
        "payment_mode": "Cash",
        "payment_status": "Delivered".toString(),
      };

      print("📤 Sending customer data: $requestData");

      final response = await dio.post(
        '/random-customer',
        data: requestData,
      );

      print("📥 Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData["flag"] == true) {
          Fluttertoast.showToast(
            msg: "Customer added successfully",
            backgroundColor: Colors.green,
          );

          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          throw Exception(responseData["message"] ?? "Failed to add customer");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Add customer error: $e");
      Fluttertoast.showToast(
        msg: "Failed to add customer: $e",
        backgroundColor: Colors.red,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Add New Customer",
          style: TextConstants.headingStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.1), Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fill in the information below",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_fetchingLocation)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Getting location...",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_latitude.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Located",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            _buildTextField(
              controller: _firstNameController,
              label: "First Name",
              hint: "Enter first name",
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "First name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField(
              controller: _lastNameController,
              label: "Last Name",
              hint: "Enter last name",
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Last name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Mobile Number
            _buildTextField(
              controller: _mobileController,
              label: "Mobile Number",
              hint: "Enter 10 digit mobile number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Mobile number is required";
                }
                if (value.length != 10) {
                  return "Mobile number must be 10 digits";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              label: "Address",
              hint: "Enter complete address",
              icon: Icons.location_on,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Address is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Product Selection Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shopping_bag, color: Colors.purple.shade700, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Product Selection",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category Dropdown
                  _buildDropdownField(
                    label: "Select Category",
                    hint: "Choose a category",
                    icon: Icons.category,
                    value: _selectedCategoryId,
                    items: _categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category['id'],
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: _loadingCategories
                        ? null
                        : (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                      if (value != null) {
                        _fetchProducts(value);
                      }
                    },
                    isLoading: _loadingCategories,
                  ),
                  const SizedBox(height: 16),

                  // Product Dropdown
                  _buildDropdownField(
                    label: "Select Product",
                    hint: "Choose a product",
                    icon: Icons.inventory,
                    value: _selectedProductId,
                    items: _products.map((product) {
                      return DropdownMenuItem<int>(
                        value: product['id'],
                        child: Text(
                          "${product['name']} - ₹${product['consumer_rate']}/${product['unit']}",
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: _loadingProducts || _products.isEmpty
                        ? null
                        : (value) {
                      setState(() {
                        _selectedProductId = value;
                        final product = _products.firstWhere((p) => p['id'] == value);
                        _pricePerLiter = double.parse(product['consumer_rate'].toString());
                      });
                      _calculateTotal();
                    },
                    isLoading: _loadingProducts,
                  ),
                  const SizedBox(height: 16),

                  // Quantity and Price Section
                  if (_selectedProductId != null) ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _quantityController,
                            label: "Quantity (Liters)",
                            hint: "Enter quantity",
                            icon: Icons.format_list_numbered,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                            onChanged: (value) => _calculateTotal(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                  "Price per Liter",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Center(
                                  child: Text(
                                    "₹$_pricePerLiter",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Total Price Display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade50, Colors.green.shade100],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt_long, color: Colors.green.shade700),
                              const SizedBox(width: 12),
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "₹${_totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade700],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Add Customer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            counterText: "",
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?)? onChanged,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonFormField<int>(
            value: value,
            items: items,
            onChanged: onChanged,
            isExpanded: true,
            hint: isLoading
                ? Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Text("Loading..."),
              ],
            )
                : Text(hint, style: TextStyle(color: Colors.grey[400])),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}