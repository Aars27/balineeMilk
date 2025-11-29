// import 'package:flutter/material.dart';
//
// import '../../../../Core/Constant/ApiServices.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final ApiService _apiService = ApiService();
//   final _formKey = GlobalKey<FormState>();
//
//   // --- Initial Data (Replace with actual data fetched from your ProfileProvider/Storage) ---
//   String _firstName = 'Rahul';
//   String _lastName = 'Sharma';
//   String _mobileNo = '9876543220';
//   String _email = 'rahul@gmail.com';
//
//   bool _isLoading = false;
//
//   // --- Form Controllers ---
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _mobileNoController;
//   late TextEditingController _emailController;
//
//   @override
//   void initState() {
//     super.initState();
//     _firstNameController = TextEditingController(text: _firstName);
//     _lastNameController = TextEditingController(text: _lastName);
//     _mobileNoController = TextEditingController(text: _mobileNo);
//     _emailController = TextEditingController(text: _email);
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _mobileNoController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   // --- Submission Logic ---
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         final response = await _apiService.updateProfile(
//           firstName: _firstNameController.text.trim(),
//           lastName: _lastNameController.text.trim(),
//           mobileNo: _mobileNoController.text.trim(),
//           email: _emailController.text.trim(),
//         );
//
//         // Success notification
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(response['message'] ?? 'Profile Updated!')),
//           );
//           // Update local state and potentially refresh the ProfileScreen data here
//           // Navigator.pop(context); // Optional: Go back to the previous screen
//         }
//       } catch (e) {
//         // Error notification
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.toString().replaceFirst('Exception: ', '')),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   // --- Widget Builders ---
//
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     String? Function(String?)? validator,
//     TextInputType keyboardType = TextInputType.text,
//     bool readOnly = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0),
//       child: TextFormField(
//         controller: controller,
//         validator: validator,
//         keyboardType: keyboardType,
//         readOnly: readOnly,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey.shade700),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         backgroundColor: const Color(0xFFFF9800),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // Profile Picture Placeholder (Optional, but good for UI)
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey.shade300,
//                       child: Icon(Icons.person, size: 50, color: Colors.grey.shade600),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: const Color(0xFFFF9800), width: 2),
//                         ),
//                         child: const Icon(
//                           Icons.camera_alt,
//                           color: Color(0xFFFF9800),
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               // First Name Field
//               _buildTextField(
//                 label: 'First Name',
//                 controller: _firstNameController,
//                 validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
//               ),
//
//               // Last Name Field
//               _buildTextField(
//                 label: 'Last Name',
//                 controller: _lastNameController,
//                 validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
//               ),
//
//               // Mobile Number Field (Often read-only or with specific edit flow)
//               _buildTextField(
//                 label: 'Mobile Number',
//                 controller: _mobileNoController,
//                 keyboardType: TextInputType.phone,
//                 // Assuming mobile number is non-editable for this app
//                 readOnly: true,
//                 validator: (value) => value == null || value.length < 10 ? 'Enter a valid mobile number' : null,
//               ),
//
//               // Email Field
//               _buildTextField(
//                 label: 'Email',
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Email is required';
//                   if (!value.contains('@')) return 'Enter a valid email address';
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 30),
//
//               // Save Button
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF9800),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//                     : const Text(
//                   'Save Changes',
//                   style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }