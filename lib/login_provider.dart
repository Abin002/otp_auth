// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_auth/screens/homescreen.dart';

class LoginProvider extends ChangeNotifier {
  bool _showOtpField = false;
  String _verificationId = '';
  bool get showOtpField => _showOtpField;

  void requestOtp(BuildContext context, String phoneNumber) async {
    // Request OTP from Firebase
    try {
      print('Requesting OTP for phone number: $phoneNumber');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print('OTP verification completed automatically.');
          // Automatically sign in the user when OTP is verified
          FirebaseAuth.instance.signInWithCredential(credential).then((_) {
            // Navigate to HomeScreen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenHome(),
                ));
            print('Navigating to HomeScreen...');
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          // Handle verification failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Code sent. Verification ID: $verificationId');
          // Store the verificationId for later verification
          _verificationId = verificationId;
          // Show the OTP field and update the button text
          _showOtpField = true;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(
              'Code auto-retrieval timeout. Verification ID: $verificationId');
          // Handle timeout
        },
      );
    } catch (e) {
      print('Failed to request OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request OTP: $e')),
      );
    }
  }

  void verifyOtp(BuildContext context, String otp) async {
    try {
      print('Verifying OTP: $otp');
      // Create the credential using verificationId and otp
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('OTP verified. Navigating to HomeScreen...');
      // Navigate to HomeScreen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenHome(),
          ));
    } catch (e) {
      print('Failed to verify OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    }
  }
}
