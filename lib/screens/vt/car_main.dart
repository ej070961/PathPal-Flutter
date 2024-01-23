import 'package:flutter/material.dart';

class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  final ScrollController _listScrollController = ScrollController();
  String otherWidgetText = 'Other Widget';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PathPal"),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 460,  // 다른 위젯의 높이 설정
              color: Colors.red,  // 다른 위젯의 배경색 설정
              child: Center(child: Text(otherWidgetText)),  // 다른 위젯의 내용 설정
            ),
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.blue[100],
                  child: ListView.builder(
                    controller: scrollController,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
