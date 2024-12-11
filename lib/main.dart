import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_web_app/firebase/analytics_repository.dart';
import 'package:my_web_app/list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_web_app/name_reg.dart';
import 'package:my_web_app/signup_page.dart';
import 'package:my_web_app/user_page.dart';
import 'firebase_options.dart';
import 'package:my_web_app/login_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var analytics = ref.watch(analyticsRepository);
    var analyticsObserver = ref.watch(analyticsObserverRepository);

    analytics.logAppOpen();

    return MaterialApp(
      title: 'ひマッチ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/next_page': (context) => const NextPage(),
      },
      navigatorObservers: [analyticsObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = "ひマッチ";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'pupupu-free', // 正しいフォントファミリー名を指定
            fontSize: 60,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Set background color here
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('images/ひマッチ@4x.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                          settings: const RouteSettings(name: '/login'),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 38, 173, 252), // foreground
                  ),
                  child: const Text('ログイン'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                          settings: const RouteSettings(name: '/signup'),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 38, 173, 252), // foreground
                  ),
                  child: const Text('新規登録'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 38, 173, 252), // foreground
                  ),
                  child: const Text('ログアウト'),
                  onPressed: () async {
                    try {
                      // ログアウト
                      await FirebaseAuth.instance.signOut();
                      // ユーザー登録に成功した場合
                      Navigator.of(context).pop();
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {});
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NameReg(),
                          settings: const RouteSettings(name: '/namereg'),
                        ));
                  },
                  child: null,
                ),
              ],
            )
          ])
        ],
      ),
    );
  }
}
