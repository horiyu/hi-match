import 'package:flutter/material.dart';
import 'package:my_web_app/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_web_app/password_reset.dart';
import 'package:my_web_app/presentation/widgets/pill_elavated_button.dart';
import 'package:my_web_app/presentation/widgets/pill_outlined_button.dart';
import 'package:my_web_app/presentation/widgets/rounded_form_field.dart';
import 'package:my_web_app/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';

  bool _isObscure = true;

  bool _isButtonAbleEmail = false;
  bool _isButtonAblePassword = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NextPage(),
          settings: const RouteSettings(name: '/next_page'),
        ),
      );
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
                      controller: TextEditingController(),
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
                      controller: TextEditingController(),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NextPage(),
                                      settings: const RouteSettings(
                                          name: '/next_page'),
                                    ),
                                  );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasswordResetPage(),
                            settings:
                                const RouteSettings(name: '/password_reset'),
                          ),
                        );
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                              settings: const RouteSettings(name: '/signup'),
                            ));
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
