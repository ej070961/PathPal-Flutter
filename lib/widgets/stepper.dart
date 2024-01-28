import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';

class CustomStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  CustomStepper({
    required this.steps,
    this.currentStep = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left:50.0),
            height: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: steps.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String step = entry.value;

                  Color color = idx <= currentStep ? Colors.green : Colors.grey;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: color,
                              ),
                              if (idx != steps.length - 1)
                                Container(
                                  height: constraints.maxHeight * 0.4 / (steps.length - 1),
                                  width: 1,
                                  color: color,
                                ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Baseline(
                              baseline: 0,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(step),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
