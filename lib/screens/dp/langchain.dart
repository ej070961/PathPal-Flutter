import 'package:http/http.dart' as http;
import 'dart:convert';

// 네트워크 서비스를 위한 클래스
class NetworkService {
  // 서버로부터 응답을 가져오는 매소드
  static Future<String> getResponse(String question) async {
    // Flask 서버의 URL
    final String url = 'http://10.0.2.2:8000/get-response/';
    try {
      // 서버에 POST 요청
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      // 요청이 성공적이면 응답을 파싱하여 반환
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        // 에러 발생 시 에러 메시지를 반환
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      // 네트워크 요청 중 예외 발생 시 예외 메시지를 반환
      return 'Error: ${e.toString()}';
    }
  }
}
