import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_auth/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => LoginProvider(),
        child: Consumer<LoginProvider>(
          builder: (context, provider, _) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/logo.png'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: 'Phone Number',
                          prefixText: '+91 ',
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFF5862A), // orange color
                              width: 2,
                            ),
                          ),
                          floatingLabelStyle:
                              TextStyle(color: Color(0xFFF5862A)),
                        ),
                        cursorColor: const Color(0xFFF5862A),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Conditional rendering of the OTP TextField based on state
                    if (provider.showOtpField)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: otpController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            labelText: 'OTP',
                            floatingLabelStyle:
                                TextStyle(color: Color(0xFFF5862A)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: Color(0xFFF5862A), // orange color
                                width: 2,
                              ),
                            ),
                          ),
                          cursorColor: const Color(0xFFF5862A),
                        ),
                      ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFF5862A),
                          ),
                          onPressed: () {
                            if (provider.showOtpField) {
                              // Verify OTP
                              provider.verifyOtp(context, otpController.text);
                            } else {
                              // Request OTP
                              // Concatenate the prefix "+91" with the phone number
                              final fullPhoneNumber =
                                  '+91 ${phoneController.text}';
                              provider.requestOtp(context, fullPhoneNumber);
                            }
                          },
                          child: Text(
                            provider.showOtpField ? 'Verify' : 'Request OTP',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
