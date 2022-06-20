import 'dart:ui';

import 'package:pizza_animation/common_components/loading_widget.dart';
import 'package:pizza_animation/routes/route_names.dart';
import 'package:pizza_animation/routes/routes.dart';
import 'package:pizza_animation/services/firebase_service.dart';
import 'package:pizza_animation/utils/colors.dart';
import 'package:pizza_animation/utils/text_styles.dart';
import 'package:pizza_animation/view_models/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  late AnimationController _phoneNoController, _otpController;
  late bool _isPhoneNumberScreen;
  late TextEditingController _phoneNumberController, _otpNumberController;
  String _errorText = '';
  @override
  void initState() {
    _isPhoneNumberScreen = true;
    _phoneNoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _otpController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _phoneNumberController = TextEditingController();
    _otpNumberController = TextEditingController();

    super.initState();
  }

  _animateToPhoneNumber({bool isReverse = false}) async {
    if (!isReverse) {
      _phoneNoController.forward();
      return;
    }
    _phoneNoController.reverse();
  }

  _animateToOtp({bool isReverse = false}) async {
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _errorText = 'Phone number cannot be empty';
      });
      return;
    } else {
      setState(() {
        _errorText = '';
      });
    }

    /// To move phone number and bring otp
    if (!isReverse) {
      LoadingDialog().show(text: 'Verifying Phone Number');

      var _isValid = await _verifyPhoneNumber();

      LoadingDialog().hide();

      if (_isValid) {
        _animateToPhoneNumber();
        _otpController.forward();
        setState(() {
          _isPhoneNumberScreen = false;
        });
      } else {
        setState(() {
          _errorText = 'Phone number not valid';
        });
      }
      return;
    }

    setState(() {
      _isPhoneNumberScreen = true;
    });
    _animateToPhoneNumber(isReverse: isReverse);
    _otpController.reverse();
  }

  Future<bool> _verifyPhoneNumber() async {
    var _result =
        await FirebaseService().verifyPhoneNumber(_phoneNumberController.text);

    return _result;
  }

  _verifyOTPNumber() async {
    if (_otpNumberController.text.isEmpty) {
      setState(() {
        _errorText = 'OTP cannot be empty';
      });
      return;
    } else {
      setState(() {
        _errorText = '';
      });
    }

    LoadingDialog().show(text: 'Verifying OTP');

    var _result = await FirebaseService().verifyOTP(_otpNumberController.text);

    LoadingDialog().hide();

    if (_result != null) {
      LoadingDialog().show(text: 'Fetching user details');
      var _userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      await _userDataProvider.getUserDetails();

      LoadingDialog().hide();
      if (_userDataProvider.userData == null) {
        SetupRoutes.pushAndRemoveAll(context, Routes.USER_FORM);
      } else {
        SetupRoutes.pushAndRemoveAll(context, Routes.HOME);
      }
    } else {
      setState(() {
        _errorText = 'OTP verification failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15.0, top: 30.0),
          decoration: BoxDecoration(
              border: const Border(), borderRadius: BorderRadius.circular(30)),
          height: _isPhoneNumberScreen ? 0 : 80,
          child: _isPhoneNumberScreen
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: ColorConstants.black,
                  ),
                  iconSize: 40,
                  padding: const EdgeInsets.all(0),
                  onPressed: () => _animateToOtp(isReverse: true)),
        ),
        _isPhoneNumberScreen
            ? SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0),
                  end: const Offset(-1, 0),
                ).animate(_phoneNoController),
                child: phoneNumberScreen(),
              )
            : SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(_otpController),
                child: otpScreen(),
              ),
        _errorText.length != 0
            ? Text(
                '$_errorText',
                style: CustomTextStyles.customTextStyle(ColorConstants.red,
                    size: 16),
              )
            : const SizedBox(),
        _errorText.length != 0 ? const SizedBox(height: 7) : const SizedBox(),
        TextButton(
          onPressed: () async {
            if (_isPhoneNumberScreen) {
              /// Check mobile no is valid & send an OTP, then
              await _animateToOtp();
            } else {
              /// verify otp entered is correct, then
              await _verifyOTPNumber();
            }
          },
          child: Container(
            alignment: Alignment.center,
            width: 140,
            height: 50,
            child: Text(
              _isPhoneNumberScreen ? 'Next' : 'Submit',
              style: const TextStyle(
                color: ColorConstants.white,
                fontSize: 20,
              ),
            ),
            decoration: BoxDecoration(
                color: ColorConstants.Blue_Gray,
                border: const Border(),
                borderRadius: BorderRadius.circular(20)),
          ),
        )
      ],
    );
  }

  phoneNumberScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30.0, top: 30.0),
          child: const Text("Phone Number",
              style: TextStyle(
                color: ColorConstants.DARK_GREY,
                fontSize: 20,
              )),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: TextFormField(
            autofocus: false,
            textInputAction: TextInputAction.next,
            controller: _phoneNumberController,
            // textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: ColorConstants.black,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              // hintTextDirection: TextDirection.rtl,
              prefixText: '+91 ',
              prefixStyle: const TextStyle(color: Colors.black, fontSize: 16),
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Enter Phone Number",
              hintStyle: const TextStyle(
                color: ColorConstants.LIGHT_GREY,
                fontSize: 16,
              ),
              contentPadding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFEBEBEB), width: 2)),
            ),
            // onChanged: (val) {
            //   if (_phoneNumberController.text.isEmpty) {
            //     setState(() {
            //       _errorText = 'Phone number cannot be empty';
            //     });
            //     return;
            //   } else {
            //     setState(() {
            //       _errorText = '';
            //     });
            //   }
            // },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Can't leave this empty";
              }
              return null;
            },
          ),
        ),
        Container(
          height: 30,
        ),
      ],
    );
  }

  otpScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: 30,
        // ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30.0, top: 30.0),
          child: const Text("Otp",
              style: TextStyle(
                color: ColorConstants.DARK_GREY,
                fontSize: 20,
              )),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: TextFormField(
            autofocus: false,
            textInputAction: TextInputAction.next,
            controller: _otpNumberController,
            style: const TextStyle(
              color: ColorConstants.black,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: "Enter OTP",
              hintStyle: const TextStyle(
                color: ColorConstants.LIGHT_GREY,
                fontSize: 16,
              ),
              contentPadding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFEBEBEB), width: 2)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Can't leave this empty";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
