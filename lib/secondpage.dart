import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightwork_timer_memo/bottom.dart';
import 'package:nightwork_timer_memo/cardview.dart';
import 'package:nightwork_timer_memo/main.dart';

/** 2022-05-06 code design: jongdroid
 *  해당 페이지는 메인으로 부터 전달 받은 시간 데이터를 간단한 텍스트와 함께 저장한다.
 *  텍스트는 TextField를 통해 입력받는다.
 *  ListView로 저장되는 모든 데이터를 '상세보기' 에 전달하여 카드뷰 형태로 출력한다.
 *  [개선사항] -> 일일 단위로 데이터를 자동으로 초기화 할 수 있도록 개선이 필요해보인다.
 */

class SaveTodayData extends StatelessWidget {
  const SaveTodayData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailWork(),
      routes: {
        '/home': (context) => MyApp(),
        '/data': (context) => SaveTodayData(),
        '/details': (context) => CardView(),
      },
    );
  }
}

class DetailWork extends StatefulWidget {

  // 전달받은 데이터 (야근 시작 시간, 야근 종료 시간, 야근한 시간, 야근한 날짜)
  var saveNowTime;
  var saveEndTime;
  var saveWorkTime;
  var today_date;

  DetailWork(
      {Key? key,
      this.saveNowTime,
      this.saveEndTime,
      this.saveWorkTime,
      this.today_date})
      : super(key: key);

  @override
  State<DetailWork> createState() => _DetailWorkState();
}

class _DetailWorkState extends State<DetailWork> {

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

  // TextField를 통해 입력 받은 텍스트 Controller
  var titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
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

      print('$dateList' + 'test임');
    });
  }

  _incrementCounter() async {
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
        title: Text('일일 기록'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
              ),
            ),
            width: 350,
            height: 500,
            child: Column(
              children: [
                Container(
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        today_date,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '시작 시간',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        '$saveNowTime',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '종료 시간',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        '$saveEndTime',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '야근 시간',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        '$saveWorkTime',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text(
                        '초기화',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      onPressed: () {
                        allReset();
                        setState(() {});
                      },
                    ),
                    TextButton(
                      child: Text(
                        '저장',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // _incrementCounter();
                        showPerformanceDialog(context);

                        setState(() {});
                      },
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '* 초 단위는 기록되지 않아요. ex- 0시간 00분',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
                Container(
                  height: 1.0,
                  width: 500.0,
                  color: Colors.grey,
                ),
                Container(
                    height: 250,
                    margin: EdgeInsets.all(5),
                    child: ListView.builder(
                        itemCount: dateList.length,
                        itemBuilder: (context, int index) {
                          return ListTile(
                            title: Text('${titleList[index]}'),
                            subtitle: Text(
                              '날짜-${dateList[index]} ${getNowtimeList[index]}'
                              ' 야근시간- ${worktimeList[index]}',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        })

                    // Text('$realDate' ' 야근 시간-\[${timeData}\]',),
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MenuBottom(),
    );
  }

  void allReset() {
    saveNowTime = '0';
    saveEndTime = '0';
    saveWorkTime = '0';
  }

  Future<dynamic> showPerformanceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('기록하기'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: '무엇을 하셨나요?'),
                    controller: titleController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  titleController.text = '';
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  Navigator.pop(context);
                  _incrementCounter();
                  sendAllDataNextPage();
                  titleController.clear();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  // 다음페이지로 데이터 전달
  void sendAllDataNextPage() {
    Navigator.pushNamed(context, '/CardViewScreen', arguments: today_date);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: saveWorkTime);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: nowTimeVar);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: titleController);
  }
}