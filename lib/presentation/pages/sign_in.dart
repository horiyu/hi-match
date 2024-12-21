import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../router/page_path.dart';
import '../widgets/pill_elavated_button.dart';
import '../widgets/pill_outlined_button.dart';
import '../widgets/rounded_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String infoText = '';
  String email = '';
  String password = '';

  bool _isObscure = true;

  bool _isButtonAbleEmail = false;
  bool _isButtonAblePassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go(PagePath.viewPage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/ひマッチ@4x.png'),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedFormField(
                      hintText: 'メールアドレス',
                      height: 50,
                      width: double.infinity,
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                          _isButtonAbleEmail = value.isNotEmpty;
                        });
                      },
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    RoundedFormField(
                      hintText: 'パスワード',
                      height: 50,
                      width: double.infinity,
                      obscureText: _isObscure,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                          _isButtonAblePassword = value.isNotEmpty;
                        });
                      },
                      controller: _passwordController,
                      suffixIcon: password.isNotEmpty
                          ? IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                                if (!_isObscure) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      _isObscure = true;
                                    });
                                  });
                                }
                              },
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: PillElevatedButton(
                        onPressed: _isButtonAbleEmail && _isButtonAblePassword
                            ? () async {
                                try {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  await auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  context.go(PagePath.viewPage.path);
                                } catch (e) {
                                  setState(() {
                                    infoText = "ログインに失敗しました。もう一度お試しください";
                                  });
                                }
                              }
                            : null,
                        child: const Text('ログイン'),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 15,
                      child: Text(
                        infoText.isNotEmpty ? infoText : '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        context.push(PagePath.signUp.path);
                      },
                      child: const Text('パスワードをお忘れですか？'),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: PillOutlinedButton(
                      onPressed: () {
                        context.push(PagePath.signUp.path);
                      },
                      child: const Text('新規登録'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
