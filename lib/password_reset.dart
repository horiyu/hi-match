import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  String infoText = '';
  String resetEmail = '';

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
                          resetEmail = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: resetEmail.isNotEmpty
                            ? () async {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: resetEmail);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'invalid-email') {
                                    // 無効なメールアドレス
                                    infoText = '無効なメールアドレスです';
                                  } else if (e.code == 'user-not-found') {
                                    // ユーザーが存在しない
                                    infoText = 'ユーザーが存在しません';
                                  } else {
                                    // その他の失敗
                                    infoText = 'エラーが発生しました';
                                  }
                                } on Exception {
                                  // その他の失敗
                                  infoText = 'エラーが発生しました';
                                }
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text('送信'),
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
            ],
          ),
        ),
      ),
    );
  }
}
