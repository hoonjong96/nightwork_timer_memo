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

var now_hour = DateFormat('HH').format(DateTime.now());
var now_min = DateFormat('mm').format(DateTime.now());
var nowTime = '${now_hour}시 ${now_min}분';
var nowTimeList = ['야근 시작 시간', '$nowTime'];

var end_hour = DateFormat('HH').format(DateTime.now());
var end_min = DateFormat('mm').format(DateTime.now());
var endTime = '${end_hour}시 ${end_min}분';
var endTimeList = ['야근 종료 시간', '$endTime'];

var saveTime;

var getState = '대기중';

// 넘겨주는 데이터
var getNowTime = '대기중';
var sendEndTime = '대기중';
var saveEndTime = '대기중';
var sendWorkTime = '대기중';

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

//현재 날짜 출력 년-월-일 format
var today_date = DateFormat('yyyy.MM.dd').format(DateTime.now());

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  var second = 0; //타이머의 초
  var min = 0; // 분
  var hour = 0; // 시간

  var nowTimeIndex = 0;
  var endTimeIndex = 0;

  var saveDataList = [];
  var counterTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 야근'),
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
                      style: TextStyle( fontSize: 18,
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                      '${getState}',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
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
                      style:
                      TextStyle(fontSize: 60, color: Color(0xff448AFF)),
                    ),
                    Text(
                      '시간',
                      style: TextStyle(fontSize: 30, color: Colors.purple),
                    ),
                    Text(
                      '$min',
                      style:
                      TextStyle(fontSize: 60, color: Color(0xff448AFF)),
                    ),
                    Text(
                      '분',
                      style: TextStyle(fontSize: 30, color: Colors.purple),
                    ),
                    Text(
                      '$second',
                      style:
                      TextStyle(fontSize: 60, color: Color(0xff448AFF)),
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
                style: TextStyle( fontSize: 16,
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),

              Container( height:1.0, margin: EdgeInsets.all(3),
                width:500.0,
                color:Colors.grey,),

              
              Container(
                margin: EdgeInsets.all(8),
              ),
              
              ButtonBar(
                alignment:
                MainAxisAlignment.spaceEvenly, //ButtonBar 버튼들이 중앙으로 이동

                children: [
                  ElevatedButton(
                    child: Text(
                      '야근 시작',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {

                      setState(() {
                        getNowTime = DateFormat('hh:mm').format(DateTime.now());
                        getState = "야근중";
                        startTimerBtn();
                        Navigator.pushNamed(context, '/DetailWork', arguments: getNowTime);
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '야근 중지',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        getState = "중지";
                        pushEndBtn();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '시간 저장',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      ShowToast();
                      pushResetBtn();
                      setState(() {
                        getState = "저장완료";
                        sendWorkTime = '${hour}시간 ${min}분';
                        saveEndTime = DateFormat('hh:mm').format(DateTime.now());
                        today_date = DateFormat('yyyy.MM.dd').format(DateTime.now());
                        Navigator.pushNamed(context, '/DetailWork', arguments: sendEndTime);
                        Navigator.pushNamed(context, '/DetailWork', arguments: sendWorkTime);
                        Navigator.pushNamed(context, '/DetailWork', arguments: today_date);
                      });
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

  void pushEndBtn() {
    timer.cancel();
  }

  void pushResetBtn() {
    setState(() {
      hour = 0;
      second = 0;
      min = 0;
      timer.cancel();
    });
  }

  void ShowToast() {
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
