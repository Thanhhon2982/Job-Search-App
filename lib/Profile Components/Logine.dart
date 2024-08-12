// ignore_for_file: unused_import, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/Components/Homepage.dart';
import 'package:my_flutter_app/Profile%20Components/ForgotPassword.dart';
import 'package:my_flutter_app/Profile%20Components/Helps.dart';
import 'package:my_flutter_app/Profile%20Components/ProfilePage.dart';
import 'package:my_flutter_app/Profile%20Components/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Color.fromARGB(255, 6, 60, 74),
      ),
      backgroundColor: Color.fromARGB(255, 4, 80, 101),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Lottie Animation
              Container(
                height: 200,
                child: Lottie.asset('assets/animation_lm0js4z1.json'),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 60, 135, 205),
                      Color.fromARGB(255, 28, 189, 168)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 190, 101, 19),
                          ),
                          fillColor: Color.fromARGB(173, 212, 189, 189),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Vui lòng điền email chính xác';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 54, 184, 19),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          fillColor: Color.fromARGB(173, 212, 189, 189),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Mật khẩu phải chứa 6 kí tự trở lên';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    // Navigate to the homepage upon successful login
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobProfilePage(),
                                      ),
                                    );
                                  } catch (e) {
                                    // Handle login errors here
                                    String errorMessage =
                                        "Một lỗi đã xảy ra. Vui lòng kiểm tra thông tin đăng nhập của bạn.";
                                    if (e is FirebaseAuthException) {
                                      if (e.code == 'user-not-found') {
                                        errorMessage =
                                            "Không tìm thấy người dùng nào với email đó.";
                                      } else if (e.code == 'wrong-password') {
                                        errorMessage =
                                            "Sai mật khẩu. Vui lòng thử lại.";
                                      }
                                    }
                                    _showErrorDialog(context, errorMessage);
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 6, 60, 74),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0,
                          ),
                        ),
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 60, 74),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Chưa có tài khoản? Đăng ký",
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 60, 74),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Help',
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 60, 74),
                            decoration: TextDecoration.underline,
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
      ),
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Đăng nhập lỗi'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
