import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/request_items.dart';
import 'package:pathpal/widgets/request_items_vt.dart';

class VtRequests extends StatefulWidget {
  const VtRequests({super.key});

  @override
  State<VtRequests> createState() => _RequestsState();
}

class _RequestsState extends State<VtRequests> {

  int? buttonState;

  @override
  void initState() {
    super.initState();
    buttonState = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "봉사 내역",
            style: appTextTheme().titleMedium,
          ),
        ),
        body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity, //가능한 가장 큰 너비
                height: 40,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        border:Border(
                          bottom: BorderSide(
                            color:buttonState == 0? mainAccentColor: Colors.transparent,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () =>
                        buttonState==1
                            ? setState(() {
                          buttonState = 0;
                        })
                            : null,
                        child: Center(
                          child: Text(
                            "차량서비스",
                            style: appTextTheme()
                                .bodyMedium!
                                .copyWith(color: buttonState==0? mainAccentColor: gray400),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        border:Border(
                          bottom: BorderSide(
                            color:buttonState == 1? mainAccentColor: Colors.transparent,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () =>
                        buttonState == 0
                            ? setState(() {
                          buttonState = 1;
                        })
                            : null,
                        child: Center(
                          child: Text(
                            "도보서비스",
                            style: appTextTheme()
                                .bodyMedium!
                                .copyWith(color: buttonState==1? mainAccentColor: gray400),
                          ),
                        ),
                      ),
                    ),
                  ],),
              ),
              Expanded(
                child: VtRequestItems(category: buttonState == 0 ? "car" : "walk"),
              )
            ])

    );
  }
}