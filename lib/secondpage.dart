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
 *  마찬가지로 입력받은 데이터를 '상세보기' 에 전달하여 카드뷰 형태로 출력한다.
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

  var getNowTime;
  var saveEndTime;
  var sendWorkTime;
  var today_date;

  DetailWork(
      {Key? key,
      this.getNowTime,
      this.saveEndTime,
      this.sendWorkTime,
      this.today_date})
      : super(key: key);

  @override
  State<DetailWork> createState() => _DetailWorkState();
}

class _DetailWorkState extends State<DetailWork> {

  var myList = <String>[]; // 날짜데이터
  var sendWorkTimeList = <String>[];
  var nowTimeList = <String>[];
  var nowTimeVar; // 현재 시간 저장 데이터

  var titleController = TextEditingController();
  var titleList = <String>[];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      myList = (prefs.getStringList("myList"))!;
      prefs.setStringList("myList", myList);

      sendWorkTimeList = (prefs.getStringList("worktimekey"))!;
      prefs.setStringList("worktimekey", sendWorkTimeList);

      nowTimeList = (prefs.getStringList("nowtimekey"))!;
      prefs.setStringList("nowtimekey", nowTimeList);

      titleList = (prefs.getStringList("titlekey"))!;
      prefs.setStringList("titlekey", titleList);

      print('$myList' + 'test임');
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {



    myList.add(today_date);
    prefs.setStringList("myList", myList);

    sendWorkTimeList.add(sendWorkTime);
    prefs.setStringList("worktimekey", sendWorkTimeList);

    nowTimeVar = DateFormat('HH:mm:ss').format(DateTime.now());
    nowTimeList.add('${nowTimeVar}');
    prefs.setStringList("nowtimekey", nowTimeList);


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
                        '$getNowTime',
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
                        '$sendWorkTime',
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

                        setState(() {

                        });
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
                        itemCount: myList.length,
                        itemBuilder: (context, int index) {
                          return ListTile(
                            title: Text('${titleList[index]}'),

                            subtitle: Text(

                              '날짜-${myList[index]} ${nowTimeList[index]}'
                              ' 야근시간- ${sendWorkTimeList[index]}',
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
    getNowTime = '0';
    saveEndTime = '0';
    sendWorkTime = '0';
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
                setState((){
                });

              },
            ),
          ],
        );
      });
}




   // 다음페이지로 데이터 전달
  void sendAllDataNextPage() {

    Navigator.pushNamed(context, '/CardViewScreen', arguments: today_date);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: sendWorkTime);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: nowTimeVar);
    Navigator.pushNamed(context, '/CardViewScreen', arguments: titleController);

  }

}
