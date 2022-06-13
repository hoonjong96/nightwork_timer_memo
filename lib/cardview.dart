import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightwork_timer_memo/bottom.dart';
import 'package:nightwork_timer_memo/main.dart';
import 'package:nightwork_timer_memo/secondpage.dart';

/** 2022-05-06 code design: jongdroid
 *  해당 페이지는 일일 기록으로 부터 전달받은 데이터를 누적하여 기록한다.
 *  [개선사항] -> 해당 페이지에서 그래프와 같은 수단을 통하여 일일/주간/월간 단위로 야근 통계를 볼 수 있도록 개선 필요
 */

class CardView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => MyApp(),
        '/data': (context) => SaveTodayData(),
        '/details': (context) => CardView(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CardViewScreen(),
    );
  }
}

class CardViewScreen extends StatefulWidget {

  // 이전페이지에서 받아온 데이터입니다. (날짜, 데이터저장한시간, 야근한 시간, 야근 입력 텍스트)
  var today_date;
  var saveEndTime;
  var saveWorkTime;
  var titleController;

  CardViewScreen(
      {Key? key,
        this.saveEndTime,
        this.saveWorkTime,
        this.titleController,
        this.today_date})
      : super(key: key);

  @override
  _CardViewScreen createState() => _CardViewScreen();
}

class _CardViewScreen extends State<CardViewScreen> {

  // 야근 시간 저장한 날짜 저장 리스트
  List<String> dateList = [];

  // 야근한 시간을 저장하는 리스트
  List<String> worktimeList = [];

  // 야근 시간을 저장한 날짜의 시간 저장 리스트
  // 예 - 23:58분에 저장했다면 해당 시간 기록
  List<String> getNowtimeList = [];

  // 야근 task 기록 text save list
  List<String> titleList = <String>[];

  var nowTimeVar; // 현재 시간 저장 데이터
  var titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataList();
  }

  getDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      dateList = (prefs.getStringList("myList"))!;
      prefs.setStringList("myList", dateList);

      worktimeList = (prefs.getStringList("worktimekey"))!;
      prefs.setStringList("worktimekey", worktimeList);

      getNowtimeList = (prefs.getStringList("nowtimekey"))!;
      prefs.setStringList("nowtimekey", getNowtimeList);

      titleList = (prefs.getStringList("titlekey"))!;
      prefs.setStringList("titlekey", titleList);
    });
  }

  setDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      dateList.add(today_date);
      prefs.setStringList("myList", dateList);

      worktimeList.add(saveWorkTime);
      prefs.setStringList("worktimekey", worktimeList);

      nowTimeVar = DateFormat('HH:mm:ss').format(DateTime.now());
      getNowtimeList.add('${nowTimeVar}');
      prefs.setStringList("nowtimekey", getNowtimeList);

      titleList.add(titleController.text);
      prefs.setStringList("titlekey", titleList);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('데이터 리스트'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('${titleList[index]}'),
                  subtitle: Text(
                    '날짜-${dateList[index]} ${getNowtimeList[index]}'
                        ' 야근시간- ${worktimeList[index]}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      bottomNavigationBar: MenuBottom(),
    );
  }
}