import 'package:flutter/material.dart';
import 'langchain.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  // 사용자의 질문에 대한 응답을 서버로부터 받아오는 메소드
  Future<void> _getResponse() async {
    final String question = _controller.text; // 현재 텍스트 필드의 내용
    if (question.isEmpty) {
      return;
    }

    setState(() {
      _response = '잠시만 기다려주세요...'; // 사용자에게 응답이 처리되고 있음을 알림
      _isLoading = true; // 로딩 상태를 true로 설정해 로딩 인디케이터를 활성화
    });

    final String response = await NetworkService.getResponse(question); // 서버로부터 응답을 비동기적으로 받아옴

    setState(() {
      _response = response; // 받아온 응답을 화면에 표시
      _isLoading = false; // 로딩 상태를 false로 설정해 로딩 인디케이터를 비활성화
    });

    // 응답을 받은 후 10초를 기다림.
    Future.delayed(Duration(seconds: 10), () {
      // 10초 후에 상태를 초기화.
      if (mounted) {
        setState(() {
          _controller.clear(); // 입력 필드를 초기화.
          _response = ''; // 응답 텍스트를 초기화.
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챗봇 서비스'),
        actions: <Widget>[
          if (_isLoading)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _response,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '근처에 편의시설을 물어보세요',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _getResponse, // 사용자가 '보내기' 버튼을 누를 때 호출될 메소드
                ),
              ),
              onSubmitted: (value) => _getResponse(), // 키보드에서 '완료'를 누를 때 호출될 메소드
            ),
          ),
        ],
      ),
    );
  }
}
