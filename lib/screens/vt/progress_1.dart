import 'package:flutter/material.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/widgets/progress_app_bar.dart';
import 'package:pathpal/widgets/stepper.dart';

class VtProgress extends StatefulWidget {
  @override
  State<VtProgress> createState() => _VtProgressState();
}

class _VtProgressState extends State<VtProgress> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProgressAppBar(),
      body: Builder(
        builder: (BuildContext context) {
          final double appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
          final double screenHeight = MediaQuery.of(context).size.height;
          final double stepperHeight = (screenHeight - appBarHeight) * 0.2;

          return Column(
            children: [
              Container(
                height: stepperHeight,
                child: CustomStepper(
                  steps: ['가는중', '도착 완료'],
                  currentStep: _currentStep,
                ),
              ),
              NextButton(
                title: "도착 완료",
                onPressed: (){
                  setState(() {
                    if (_currentStep < 1) {
                      _currentStep++;
                    }
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
