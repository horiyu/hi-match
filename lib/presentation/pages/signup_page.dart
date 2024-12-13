import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_web_app/name_reg.dart';

import '../widgets/pill_outlined_button.dart';
import '../widgets/rounded_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String infoText = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

  bool _isObscure = true;
  bool _isObscureConfirm = true;

  bool _isButtonAbleEmail = false;
  bool _isButtonAblePassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

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
                      controller: emailController,
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                          _isButtonAbleEmail = value.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    RoundedFormField(
                      hintText: 'パスワード',
                      height: 50,
                      width: double.infinity,
                      controller: passwordController,
                      obscureText: _isObscure,
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
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    RoundedFormField(
                      hintText: 'パスワード（確認）',
                      height: 50,
                      width: double.infinity,
                      controller: passwordConfirmController,
                      obscureText: _isObscureConfirm,
                      suffixIcon: passwordConfirm.isNotEmpty
                          ? IconButton(
                              icon: Icon(_isObscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscureConfirm = !_isObscureConfirm;
                                });
                                if (!_isObscureConfirm) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      _isObscureConfirm = true;
                                    });
                                  });
                                }
                              },
                            )
                          : null,
                      onChanged: (String value) {
                        setState(() {
                          passwordConfirm = value;
                          if (value != password) {
                            infoText = 'パスワードが一致しません';
                            _isButtonAblePassword = false;
                          } else {
                            infoText = '';
                            _isButtonAblePassword = true;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _isButtonAbleEmail && _isButtonAblePassword
                            ? () async {
                                try {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  User? user = auth.currentUser;

                                  if (user != null) {
                                    await user.sendEmailVerification();
                                    setState(() {
                                      infoText = "確認メールを送信しました。メールを確認してください";
                                    });
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NameReg(),
                                      settings: const RouteSettings(
                                          name: '/name_reg'),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() {
                                    infoText = "登録に失敗しました。もう一度お試しください";
                                  });
                                }
                              }
                            : null,
                        child: const Text('新規登録'),
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('ログイン'),
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
