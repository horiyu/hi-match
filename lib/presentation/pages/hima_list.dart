import 'package:flutter/material.dart';
import 'package:my_web_app/presentation/widgets/user_icon.dart';

class HimaListPage extends StatefulWidget {
  const HimaListPage({super.key});

  @override
  State<HimaListPage> createState() => _HimaListPageState();
}

class _HimaListPageState extends State<HimaListPage> {
  bool _isMeHima = false;

  List<Map<String, dynamic>> chats = [
    {
      'name': 'ハイブリッドアート演習Eチーム',
      'message': '',
      'time': '2000-01-01 00:00:00',
      'icon': Icons.group
    },
    {
      'name': 'Horiyu',
      'message': '英語はスライドを全翻訳',
      'time': '2023-12-05 00:00:00',
      'icon': Icons.person
    },
    {
      'name': 'システム開発研究会',
      'message': '中山先生おやすみ，槙井先生出張により今日の活動はお休みです',
      'time': '2023-12-05 14:41:00',
      'icon': Icons.work
    },
    {
      'name': 'Zoff',
      'message': '[MAX50%OFF] 冬セールスタート！',
      'time': '2023-12-05 12:30:00',
      'icon': Icons.shopping_bag
    },
    {
      'name': 'FlutterDeveloper',
      'message': '多分あんまり使いこなせてないんだろーな，私',
      'time': '2023-12-05 11:02:00',
      'icon': Icons.code
    },
    {
      'name': 'NFTオープチャ',
      'message': '当オプチャでは大きなイベントが3つあります☆イベントについてのルールもありますので，各自ルール...',
      'time': '2023-12-05 08:00:00',
      'icon': Icons.monetization_on
    },
    {
      'name': 'キッズファーム 畑サポーターズ',
      'message': 'おはようございます．明日の参加予定は今の所4名です．今日ランチ会の買い出しするので，参加出来る...',
      'time': '2023-12-05 05:59:00',
      'icon': Icons.local_florist
    },
    {
      'name': 'DNG Alumni',
      'message': '@All みなさんお疲れ様です！毎年恒例の集合写真撮影の時期がやってまいりました🎂今年はまだ...',
      'time': '2023-12-04 23:59:00',
      'icon': Icons.school
    },
    {
      'name': 'Apple',
      'message': 'あの人にぴったりのギフトを用意しよう．Apple Watch Studioなら思いのままです．',
      'time': '2023-12-04 23:59:00',
      'icon': Icons.apple
    },
  ];

  String sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserIcon(
          size: 100,
          isDisplayedStatus: true,
          isStatus: _isMeHima,
          // onTap: () => setState(() {
          //   _isMeHima = !_isMeHima;
          // }),
        ),
      )),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Icon(chat['icon'], size: 40),
            title: Text(chat['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat['message']),
            trailing: Text(chat['time']),
            onTap: () {
              // Handle chat click
            },
          );
        },
      ),
    );
  }
}
