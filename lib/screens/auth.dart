import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreensState();
  }
}

class _AuthScreensState extends State<AuthScreens> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _isSending = false;
  var _enterdUsername = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _onSubmit() async {
    setState(() {
      _isSending = true;
    });
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'name': _enterdUsername,
          'email': _enteredEmail,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authenticated failed')));
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                width: 200,
                child: Image(image: AssetImage('assets/images/chat.png')),
              ),
              Card(
                margin: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(22),
                    child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            if (!_isLogin)
                              TextFormField(
                                decoration:
                                    InputDecoration(label: Text('Username')),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 3) {
                                    return 'please enter the valid username';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    _enterdUsername = newValue!,
                              ),
                            TextFormField(
                              decoration:
                                  InputDecoration(label: Text('Email Address')),
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'please enter the valid email address';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _enteredEmail = newValue!,
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(label: Text('Password')),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'please enter the valid password';
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  _enteredPassword = newValue!,
                            ),
                            SizedBox(height: 12),
                            if (_isSending) CircularProgressIndicator(),
                            if (!_isSending)
                              ElevatedButton(
                                  onPressed: _onSubmit,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Text(_isLogin ? 'Login' : 'Signup')),
                            TextButton(
                              onPressed: () => setState(() {
                                _isLogin = !_isLogin;
                              }),
                              child: Text(_isLogin
                                  ? 'create an account'
                                  : 'have an account'),
                            )
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
