import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Service/GoogleSignInService.dart';
import 'package:news_reading_application/Screen/HomeScreen.dart';
import 'package:news_reading_application/CODE/Service/login.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool isRegister = false;
  bool isChecked = false; // Thêm cho tính năng Remember Me

  final GoogleSignInService _googleSignInService = GoogleSignInService();

  void _toggleAuthMode() {
    setState(() {
      isRegister = !isRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isRegister
              ? 'assets/images/register.jpg'
              : 'assets/images/login.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 5),
              child: Text(
                isRegister ? 'Create\nAccount' : 'Welcome Back',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          if (isRegister)
                            TextField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          if (isRegister) SizedBox(height: 30),
                          TextField(
                            controller: _emailController,
                            style: TextStyle(
                                color:
                                    isRegister ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              fillColor:
                                  isRegister ? null : Colors.grey.shade100,
                              filled: !isRegister,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: isRegister
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color:
                                      isRegister ? Colors.white : Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: _passwordController,
                            style: TextStyle(
                                color:
                                    isRegister ? Colors.white : Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor:
                                  isRegister ? null : Colors.grey.shade100,
                              filled: !isRegister,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: isRegister
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color:
                                      isRegister ? Colors.white : Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          if (!isRegister)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Remember Me",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isRegister ? 'Sign Up' : 'Sign in',
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: isRegister
                                      ? () => registerWithEmailPassword(
                                            context,
                                            _emailController.text,
                                            _passwordController.text,
                                            _usernameController.text,
                                          )
                                      : () => signInWithEmailPassword(
                                            context,
                                            _emailController.text,
                                            _passwordController.text,
                                          ),
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () =>
                                _googleSignInService.signInWithGoogle(context),
                            child: Text('Sign in with Google'),
                          ),
                          ElevatedButton(
                            onPressed: () => signInAnonymously(context),
                            child: Text('Sign in Anonymously'),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _toggleAuthMode,
                                child: Text(
                                  isRegister
                                      ? 'Already have an account? \nSign In'
                                      : 'Don\'t have an account? \nSign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (!isRegister)
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
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
}
