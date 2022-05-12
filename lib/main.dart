import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nightwork_timer_memo/bottom.dart';
import 'package:nightwork_timer_memo/cardview.dart';
import 'package:nightwork_timer_memo/secondpage.dart';

/** 2022-05-06 code design: jongdroid
 *  해당 서비스는 타이머로 시간을 기록하고, 간단한 메모를 로컬에 저장할 수 있음
 *  해당 페이지에서는 타이머와 관련된 로직을 작성하고, 시간 저장을 하였을때 다음 페이지로 타이머 시간을 전달함
 *  [개선사항] -> 상태관리가 전혀 안되어있고, Getx등을 사용하여 코드 간결화 및 개선 필요
 */

void main() {
  runApp(const MyApp());
}

var today_date = DateFormat('yyyy.MM.dd').format(DateTime.now()); //오늘 날짜 저장 변수
var showNowState = '대기중'; //현재 상태를 보여줌(야근 시작 / 중지)

// 다음페이지로 넘겨주는 데이터, 대기중은 초기값을 의미
var saveNowTime = '대기중'; // 야근 시작 버튼 눌렀을때 시점의 시간 저장
var saveWorkTime = '대기중'; // 야근한 시간 저장
var saveEndTime = '대기중'; // 야근 종료한 시점의 시간을 저장

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => MyApp(),
        '/data': (context) => SaveTodayData(),
        '/details': (context) => CardView(),
      },
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  var second = 0;
  var min = 0;
  var hour = 0;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('야근 타이머'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 3,
            ),
          ),
          width: 350,
          height: 300,
          child: Column(
            children: [
              Container(
                color: Colors.grey,
                height: 35,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      showNowState,
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$hour',
                      style: TextStyle(fontSize: 60, color: Color(0xff448AFF)),
                    ),
                    Text(
                      '시간',
                      style: TextStyle(fontSize: 30, color: Colors.purple),
                    ),
                    Text(
                      '$min',
                      style: TextStyle(fontSize: 60, color: Color(0xff448AFF)),
                    ),
                    Text(
                      '분',
                      style: TextStyle(fontSize: 30, color: Colors.purple),
                    ),
                    Text(
                      '$second',
                      style: TextStyle(fontSize: 60, color: Color(0xff448AFF)),
                    ),
                    Text(
                      '초',
                      style: TextStyle(fontSize: 30, color: Colors.purple),
                    ),
                  ],
                ),
              ),
              Text(
                '오늘도 힘내세요!',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 1.0,
                margin: EdgeInsets.all(3),
                width: 500.0,
                color: Colors.grey,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      '야근 시작',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      saveNowTime = DateFormat('HH:mm').format(DateTime.now());  // 야근 시작 버튼을 눌렀을때 즉시 시간 기록(시:분만 저장)
                      showNowState = "야근중"; // 현재 상태를 저장하는 변수
                      startTimerBtn(); // 타이머 시작 함수 호출
                      Navigator.pushNamed(context, '/DetailWork', // 다음 페이지로 위에서 저장한 야근 버튼 눌렀을때 시간 전달
                          arguments: saveNowTime);
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '야근 중지',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      showNowState = "중지";
                      timer.cancel();
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '시간 저장',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      showSaveMessageToast(); //저장 완료를 알림
                      showNowState = "저장완료"; //저장 완료 상태임을 나타냄
                      saveWorkTime = '${hour}시간 ${min}분'; // 타이머로 측정한 시간을 시간과 분만 저장함
                      saveEndTime = DateFormat('HH:mm').format(DateTime.now()); // 야근을 종료한 시간을 기록함
                      resetTimerBtn(); // 타이머를 중단하고, 타이머 초기화

                      // 다음페이지로 저장 버튼을 누른 당일의 날짜, 야근한 시간 데이터 전달
                      Navigator.pushNamed(context, '/DetailWork',
                          arguments: today_date);
                      Navigator.pushNamed(context, '/DetailWork',
                          arguments: saveWorkTime);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MenuBottom(),
    );
  }

  void startTimerBtn() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      second++;
      setState(() {
        if (second == 60) {
          second = 0;
          min++;
        }
        if (min == 60) {
          min = 0;
          hour++;
        }
      });
    });
  }

  void resetTimerBtn() {
    setState(() {
      hour = 0;
      second = 0;
      min = 0;
      timer.cancel();
    });
  }

  void showSaveMessageToast() {
    Fluttertoast.showToast(
      msg: '저장을 완료하였습니다.',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
