import 'package:flutter/material.dart';

class SignUpDetail extends StatefulWidget {
  const SignUpDetail({super.key});

  @override
  State<SignUpDetail> createState() => _SignUpDetailState();
}

class _SignUpDetailState extends State<SignUpDetail> {
  String name = '';
  String infoText = '';

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('名前登録'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '名前を入力してください',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '名前',
                ),
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: name.isNotEmpty
                      ? () {
                          // Handle name registration logic here
                          FocusScope.of(context).unfocus();
                          setState(() {
                            // infoText = '名前が登録されました: $name';
                          });
                          Navigator.pushNamed(context, '/list');
                        }
                      : null,
                  child: const Text('登録'),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 15,
                child: Text(
                  infoText.isNotEmpty ? infoText : '',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
