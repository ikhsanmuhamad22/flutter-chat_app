import 'package:flutter/material.dart';

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreensState();
  }
}

class _AuthScreensState extends State<AuthScreens> {
  final _key = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _onSubmit() {
    final isValid = _key.currentState!.validate();

    if (isValid) {
      _key.currentState!.save();
      print(_enteredEmail);
      print(_enteredPassword);
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
                        key: _key,
                        child: Column(
                          children: [
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
                                    : 'have an account'))
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
