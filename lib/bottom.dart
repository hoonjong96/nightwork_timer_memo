import 'package:flutter/material.dart';
import 'package:nightwork_timer_memo/main.dart';
import 'package:nightwork_timer_memo/secondpage.dart';



class MenuBottom extends StatelessWidget {
  const MenuBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey,  //Bar의 배경색
      selectedItemColor: Colors.white,  //선택된 아이템의 색상
      unselectedItemColor: Colors.white.withOpacity(.60),  //선택 안된 아이템의 색상
      selectedFontSize: 14,  //선택된 아이템의 폰트사이즈
      unselectedFontSize: 14,  //선택 안된 아이템의 폰트사이즈

      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;

          case 1:
            Navigator.pushNamed(context, '/data');
            break;

          case 2:
            Navigator.pushNamed(context, '/details');
            break;
          default:
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.save_outlined), label: '일일 데이터'),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: '상세보기'),
      ],


    );
  }
}
