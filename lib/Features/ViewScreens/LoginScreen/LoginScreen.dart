import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../Components/Providers/LoginProviders.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import 'loginController/LoginController.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Column(
                  children: [
                    // ---------------------- TOP HEADER ----------------------
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/vector.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: constraints.maxHeight * 0.30,
                        ),
                        Positioned(
                          bottom: 10,
                          child: Image.asset(
                            'assets/milk.gif',
                            width: 90,
                          ),
                        ),
                      ],
                    ),

                    // ---------------------- FORM SECTION ----------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 30),

                            Text(
                              'Username',
                              style: TextConstants.smallTextStyle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 8),

                            _buildTextField(
                              onChanged: controller.setUsername,
                              hintText: 'Enter your mobile',
                              validator: (value) =>
                              (value == null || value.isEmpty) ? 'Please enter your username.' : null,
                            ),

                            const SizedBox(height: 15),

                            Text(
                              'Password',
                              style: TextConstants.smallTextStyle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 8),

                            Consumer<LoginController>(
                              builder: (_, c, __) => _buildPasswordField(
                                onChanged: c.setPassword,
                                hintText: 'Enter your password',
                                isVisible: c.isPasswordVisible,
                                onToggleVisibility: c.togglePasswordVisibility,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters.';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // REMEMBER / FORGOT ----------------------
                            Consumer<LoginController>(
                              builder: (_, c, __) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: const CircleBorder(),
                                        value: c.model.rememberMe,
                                        onChanged: c.toggleRememberMe,
                                        activeColor: Colors.green,
                                        checkColor: AppColors.white,
                                      ),
                                      Text('Remember Me', style: TextConstants.smallTextStyle),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => Fluttertoast.showToast(msg: 'Forget Password soon..'),
                                    child: Text('Forgot Password', style: TextConstants.smallTextStyle),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            //  LOGIN BUTTON
                            Consumer<LoginController>(
                              builder: (_, c, __) => Center(
                                child: SizedBox(
                                  width: 180,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: c.isLoading ? null : () => c.login(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: c.isLoading
                                        ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    )
                                        : Text(
                                      'Log In',
                                      style: TextConstants.bodyStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // FOOTER
                    Image.asset(
                      'assets/genslogo.png',
                      height: 20,
                      color: AppColors.black,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //  TEXT FIELD
  Widget _buildTextField({
    required Function(String) onChanged,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        hintText: hintText,
        fillColor: AppColors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  // ---------------------- PASSWORD FIELD ----------------------
  Widget _buildPasswordField({
    required Function(String) onChanged,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        hintText: hintText,
        fillColor: AppColors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.black.withOpacity(0.6),
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
