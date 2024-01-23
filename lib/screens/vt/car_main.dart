import 'package:flutter/material.dart';

class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  String otherWidgetText = 'Other Widget';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PathPal"),
      ),
      body: Column(
        children: [
          Container(
            height: 460,  // 다른 위젯의 높이 설정
            color: Colors.red,  // 다른 위젯의 배경색 설정
            child: Center(child: Text(otherWidgetText)),  // 다른 위젯의 내용 설정
          ),
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                    onTap: () {
                      setState(() {
                        otherWidgetText = 'Item $index was tapped';  // 리스트 아이템이 눌렸을 때 Other Widget의 Text 업데이트
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
