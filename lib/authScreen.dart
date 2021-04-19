import 'package:flutter/material.dart';
import 'package:lmgmt/utils/authentication.dart';
import 'package:lmgmt/widgets/google_sign_in_button.dart';
import 'package:lmgmt/widgets/responsive.dart';

class CallAuth extends StatefulWidget {
  @override
  _CallAuthState createState() => _CallAuthState();
}

class _CallAuthState extends State<CallAuth> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context)
        ? MobileAuth()
        : AuthScreen();
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController textControllerEmail;
  FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  TextEditingController textControllerPassword;
  FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String loginStatus;
  Color loginStringColor = Colors.green;

  String _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      }
    }

    return null;
  }

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = null;
    textControllerPassword.text = null;
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: backgroundDecoration,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenSize.height / 5),
            ResponsiveHeight.isSmallHeight(context)
                ? SizedBox()
                : Text(
                    'QUANTRICS',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Anton',
                      letterSpacing: 1,
                      fontSize: 20,
                    ),
                  ),
            SizedBox(height: screenSize.height / 45),
            Container(
              height: screenSize.height / 1.5,
              width: screenSize.width / 4.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                // color: Colors.white,
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: Colors.black),
                    controller: textControllerEmail,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingEmail = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeEmail.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
                    },
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenSize.height / 45,
                        horizontal: screenSize.width / 45,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800],
                          width: 4,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Email",
                      fillColor: Colors.white,
                      errorText: _isEditingEmail
                          ? _validateEmail(textControllerEmail.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    controller: textControllerPassword,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingPassword = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodePassword.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
                    },
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenSize.height / 45,
                        horizontal: screenSize.width / 45,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800],
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Password",
                      fillColor: Colors.white,
                      errorText: _isEditingPassword
                          ? _validatePassword(textControllerPassword.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: screenSize.width / 10, height: 35),
                        child: OutlinedButton(
                          // child: Text('Sign In'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.deepOrangeAccent,
                            // backgroundColor: Colors.teal,
                            side:
                                BorderSide(color: Colors.pink[800], width: 1.5),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoggingIn = true;
                              textFocusNodeEmail.unfocus();
                              textFocusNodePassword.unfocus();
                            });
                            if (_validateEmail(textControllerEmail.text) ==
                                    null &&
                                _validatePassword(
                                        textControllerPassword.text) ==
                                    null) {
                              await signInWithEmailPassword(
                                      textControllerEmail.text,
                                      textControllerPassword.text)
                                  .then((result) {
                                print(result);
                                setState(() {
                                  loginStatus =
                                      'You have successfully logged in';
                                  loginStringColor = Colors.green;
                                });
                                Future.delayed(Duration(milliseconds: 1000),
                                    () {
                                  Navigator.pushNamed(context, '/home');
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   fullscreenDialog: true,
                                  //   builder: (context) => HomePage(),
                                  // ));
                                });
                              }).catchError((error) {
                                print('Login Error: $error');
                                setState(() {
                                  loginStatus =
                                      'Error occured while logging in';
                                  loginStringColor = Colors.red;
                                });
                              });
                            } else {
                              setState(() {
                                loginStatus = 'Please enter email & password';
                                loginStringColor = Colors.red;
                              });
                            }
                            setState(() {
                              _isLoggingIn = false;
                              textControllerEmail.text = '';
                              textControllerPassword.text = '';
                              _isEditingEmail = false;
                              _isEditingPassword = false;
                            });
                          },
                          child: _isLoggingIn
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width / 80,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: screenSize.width / 10, height: 35),
                        child: OutlinedButton(
                          // child: Text('Sign Up'),
                          child: _isRegistering
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.deepOrangeAccent,
                            // backgroundColor: Colors.teal,
                            side:
                                BorderSide(color: Colors.pink[800], width: 1.5),
                          ),
                          onPressed: () async {
                            setState(() {
                              textFocusNodeEmail.unfocus();
                              textFocusNodePassword.unfocus();
                            });
                            if (_validateEmail(textControllerEmail.text) ==
                                    null &&
                                _validatePassword(
                                        textControllerPassword.text) ==
                                    null) {
                              setState(() {
                                _isRegistering = true;
                              });
                              await registerWithEmailPassword(
                                      textControllerEmail.text,
                                      textControllerPassword.text)
                                  .then((result) {
                                setState(() {
                                  loginStatus =
                                      'You have registered successfully';
                                  loginStringColor = Colors.green;
                                });
                                print(result);
                              }).catchError((error) {
                                print('Registration Error: $error');
                                setState(() {
                                  loginStatus =
                                      'Error occured while registering';
                                  loginStringColor = Colors.red;
                                });
                              });
                            } else {
                              setState(() {
                                loginStatus = 'Please enter email & password';
                                loginStringColor = Colors.red;
                              });
                            }
                            setState(() {
                              _isRegistering = false;

                              textControllerEmail.text = '';
                              textControllerPassword.text = '';
                              _isEditingEmail = false;
                              _isEditingPassword = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height / 90),
                  loginStatus != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: Text(
                              loginStatus,
                              style: TextStyle(
                                color: loginStringColor,
                                fontSize: 10,
                                // letterSpacing: 3,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: screenSize.height / 45,
                        ),
                  Center(
                      child: ResponsiveHeight.isSmallHeight(context)
                          ? SizedBox()
                          : GoogleButton()),
                  SizedBox(height: screenSize.height / 90),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ResponsiveHeight.isSmallHeight(context)
                        ? SizedBox()
                        : Text(
                            'By proceeding, you agree to our Terms of Use and confirm you have read our Privacy Policy.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileAuth extends StatefulWidget {
  @override
  _MobileAuthState createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {
  TextEditingController textControllerEmail;
  FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  TextEditingController textControllerPassword;
  FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String loginStatus;
  Color loginStringColor = Colors.green;

  String _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      }
    }

    return null;
  }

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = null;
    textControllerPassword.text = null;
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: backgroundDecoration,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenSize.height / 5),
            Text(
              'QUANTRICS',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Anton',
                letterSpacing: 1,
                fontSize: 25,
              ),
            ),
            SizedBox(height: screenSize.height / 45),
            Container(
              height: screenSize.height / 1.5,
              width: screenSize.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                // color: Colors.white,
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: Colors.black),
                    controller: textControllerEmail,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingEmail = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodeEmail.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
                    },
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenSize.height / 45,
                        horizontal: screenSize.width / 45,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800],
                          width: 4,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Email",
                      fillColor: Colors.white,
                      errorText: _isEditingEmail
                          ? _validateEmail(textControllerEmail.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    controller: textControllerPassword,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _isEditingPassword = true;
                      });
                    },
                    onSubmitted: (value) {
                      textFocusNodePassword.unfocus();
                      FocusScope.of(context)
                          .requestFocus(textFocusNodePassword);
                    },
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenSize.height / 45,
                        horizontal: screenSize.width / 45,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800],
                          width: 3,
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.blueGrey[300],
                      ),
                      hintText: "Password",
                      fillColor: Colors.white,
                      errorText: _isEditingPassword
                          ? _validatePassword(textControllerPassword.text)
                          : null,
                      errorStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 45,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: screenSize.width / 2.1, height: 35),
                        child: OutlinedButton(
                          // child: Text('Sign In'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.deepOrangeAccent,
                            // backgroundColor: Colors.teal,
                            side:
                                BorderSide(color: Colors.pink[800], width: 1.5),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoggingIn = true;
                              textFocusNodeEmail.unfocus();
                              textFocusNodePassword.unfocus();
                            });
                            if (_validateEmail(textControllerEmail.text) ==
                                    null &&
                                _validatePassword(
                                        textControllerPassword.text) ==
                                    null) {
                              await signInWithEmailPassword(
                                      textControllerEmail.text,
                                      textControllerPassword.text)
                                  .then((result) {
                                print(result);
                                setState(() {
                                  loginStatus =
                                      'You have successfully logged in';
                                  loginStringColor = Colors.green;
                                });
                                Future.delayed(Duration(milliseconds: 1000),
                                    () {
                                  Navigator.pushNamed(context, '/home');
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   fullscreenDialog: true,
                                  //   builder: (context) => HomePage(),
                                  // ));
                                });
                              }).catchError((error) {
                                print('Login Error: $error');
                                setState(() {
                                  loginStatus =
                                      'Error occured while logging in';
                                  loginStringColor = Colors.red;
                                });
                              });
                            } else {
                              setState(() {
                                loginStatus = 'Please enter email & password';
                                loginStringColor = Colors.red;
                              });
                            }
                            setState(() {
                              _isLoggingIn = false;
                              textControllerEmail.text = '';
                              textControllerPassword.text = '';
                              _isEditingEmail = false;
                              _isEditingPassword = false;
                            });
                          },
                          child: _isLoggingIn
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height / 90,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: screenSize.width / 2.1, height: 35),
                        child: OutlinedButton(
                          // child: Text('Sign Up'),
                          child: _isRegistering
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.deepOrangeAccent,
                            // backgroundColor: Colors.teal,
                            side:
                                BorderSide(color: Colors.pink[800], width: 1.5),
                          ),
                          onPressed: () async {
                            setState(() {
                              textFocusNodeEmail.unfocus();
                              textFocusNodePassword.unfocus();
                            });
                            if (_validateEmail(textControllerEmail.text) ==
                                    null &&
                                _validatePassword(
                                        textControllerPassword.text) ==
                                    null) {
                              setState(() {
                                _isRegistering = true;
                              });
                              await registerWithEmailPassword(
                                      textControllerEmail.text,
                                      textControllerPassword.text)
                                  .then((result) {
                                setState(() {
                                  loginStatus =
                                      'You have registered successfully';
                                  loginStringColor = Colors.green;
                                });
                                print(result);
                              }).catchError((error) {
                                print('Registration Error: $error');
                                setState(() {
                                  loginStatus =
                                      'Error occured while registering';
                                  loginStringColor = Colors.red;
                                });
                              });
                            } else {
                              setState(() {
                                loginStatus = 'Please enter email & password';
                                loginStringColor = Colors.red;
                              });
                            }
                            setState(() {
                              _isRegistering = false;

                              textControllerEmail.text = '';
                              textControllerPassword.text = '';
                              _isEditingEmail = false;
                              _isEditingPassword = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height / 90),
                  loginStatus != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: Text(
                              loginStatus,
                              style: TextStyle(
                                color: loginStringColor,
                                fontSize: 10,
                                // letterSpacing: 3,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: screenSize.height / 45,
                        ),
                  Center(
                      child: ResponsiveHeight.isSmallHeight(context)
                          ? SizedBox()
                          : GoogleButton()),
                  SizedBox(height: screenSize.height / 90),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ResponsiveHeight.isSmallHeight(context)
                        ? SizedBox()
                        : Text(
                            'By proceeding, you agree to our Terms of Use and confirm you have read our Privacy Policy.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.blueGrey,
      Colors.black,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);
