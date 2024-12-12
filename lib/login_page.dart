import 'package:flutter/material.dart';
import 'package:my_web_app/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_web_app/password_reset.dart';
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
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'メールアドレス',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                        if (value.isNotEmpty) {
                          _isButtonAbleEmail = true;
                        } else {
                          _isButtonAbleEmail = false;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'パスワード',
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                        if (value.isNotEmpty) {
                          _isButtonAblePassword = true;
                        } else {
                          _isButtonAblePassword = false;
                        }
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
                    child: OutlinedButton(
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
                  )
                ],
              ),
            ],
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     // メールアドレス入力
          //     TextFormField(
          //       decoration: const InputDecoration(labelText: 'メールアドレス'),
          //       onChanged: (String value) {
          //         setState(() {
          //           email = value;
          //         });
          //       },
          //     ),
          //     // パスワード入力
          //     TextFormField(
          //       decoration: const InputDecoration(labelText: 'パスワード'),
          //       obscureText: true,
          //       onChanged: (String value) {
          //         setState(() {
          //           password = value;
          //         });
          //       },
          //     ),

          //     Container(
          //       padding: const EdgeInsets.all(8),
          //       // メッセージ表示
          //       child: Text(infoText),
          //     ),
          //     SizedBox(
          //       width: double.infinity,
          //       // ログインボタン
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor:
          //               const Color.fromARGB(255, 38, 173, 252), // foreground
          //         ),
          //         onPressed: () async {
          //           try {
          //             // メール/パスワードでログイン
          //             final FirebaseAuth auth = FirebaseAuth.instance;
          //             await auth.signInWithEmailAndPassword(
          //               email: email,
          //               password: password,
          //             );
          //             // ユーザー登録に成功した場合
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => const NextPage(),
          //                   settings: const RouteSettings(name: '/next_page'),
          //                 ));
          //           } catch (e) {
          //             // ユーザー登録に失敗した場合
          //             setState(() {
          //               infoText = "ログインに失敗しました：${e.toString()}";
          //             });
          //           }
          //         },
          //         child: const Text('ログイン'),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 8,
          //     ),
          //     SizedBox(
          //       width: double.infinity,
          //       // ログアウトボタン
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor:
          //               const Color.fromARGB(255, 177, 190, 197), // foreground
          //         ),
          //         onPressed: () async {
          //           try {
          //             // ログアウト
          //             await FirebaseAuth.instance.signOut();
          //             // ユーザー登録に成功した場合
          //             Navigator.of(context).pop();
          //           } catch (e) {
          //             // ユーザー登録に失敗した場合
          //             setState(() {
          //               infoText = "ログアウトに失敗しました：${e.toString()}";
          //             });
          //           }
          //         },
          //         child: const Text('ログアウト'),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 8,
          //     ),
          //     SizedBox(
          //       width: double.infinity,
          //       // 戻る
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor:
          //               const Color.fromARGB(255, 177, 190, 197), // foreground
          //         ),
          //         onPressed: () async {
          //           Navigator.of(context).pop();
          //         },
          //         child: const Text('戻る'),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
