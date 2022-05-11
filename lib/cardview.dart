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

  var today_date;  // 오늘 날짜 받아옴
  var saveEndTime; //
  var sendWorkTime; // 야근 시간
  var titleController;


  CardViewScreen(
      {Key? key,
        this.saveEndTime,
        this.sendWorkTime,
        this.titleController,
        this.today_date})
      : super(key: key);


  @override
  _CardViewScreen createState() => _CardViewScreen();
}

class _CardViewScreen extends State<CardViewScreen> {

  var myList = <String>[]; // 날짜데이터
  var sendWorkTimeList = <String>[];
  var nowTimeList = <String>[];
  var nowTimeVar; // 현재 시간 저장 데이터

  var titleController = TextEditingController();
  var titleList = <String>[];

  //
  // var textDatailDataList = <String>[];
  //
  // var textController = TextEditingController();



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
        title: Text('데이터 리스트'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                ListTile(
                 
                  title: Text('${titleList[index]}'),

                  subtitle: Text(
                    '날짜-${myList[index]} ${nowTimeList[index]}'
                        ' 야근시간- ${sendWorkTimeList[index]}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),


                // ButtonBar(
                //   children: <Widget>[
                //     TextButton(
                //       child: Text('저장'),
                //       onPressed: () {
                //         // _incrementCounter();
                //         // showPerformanceDialog(context);
                //
                //         // setState(() {
                //         //
                //         // });
                //
                //
                //       },
                //     )
                //   ],
                // )
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













