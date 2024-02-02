import 'package:flutter/material.dart';
import 'package:pathpal/models/walk_state.dart';
import 'package:pathpal/widgets/next_button.dart';
class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {

  final _requestController = TextEditingController(text: WalkServiceState().content);

  @override
  void initState() {
    super.initState();
    _requestController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            '도움 요청사항',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: TextField(
                controller: _requestController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                  ),
              
                ),
              ),
            
            
            ),
              
              NextButton(
                  title: "작성완료",
                  onPressed: _requestController.text.isNotEmpty
                      ? () => {
                        setState(() {
                        WalkServiceState().content = _requestController.text;
                        }),
                        Navigator.pop(context)
                      }
                      : null,
              )
          ],
        )
                
    );
  }
}