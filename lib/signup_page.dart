import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_web_app/name_reg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              // // 名前
              // TextFormField(
              //   decoration: const InputDecoration(labelText: '名前'),
              //   obscureText: true,
              //   onChanged: (String value) {
              //     setState(() {
              //       password = value;
              //     });
              //   },
              // ),

              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),

              SizedBox(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: const Text('新規登録'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 38, 173, 252), // foreground
                  ),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // ユーザー登録に成功した場合、現在のユーザーを取得
                      User? user = auth.currentUser;

                      if (user != null) {
                        // メール確認用のリンクを送信
                        await user.sendEmailVerification();
                        setState(() {
                          infoText = "確認メールを送信しました。メールを確認してください。";
                        });
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NameReg(),
                              settings:
                                  const RouteSettings(name: '/name_reg')));
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                // 戻る
                child: ElevatedButton(
                  child: const Text('戻る'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 177, 190, 197), // foreground
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
