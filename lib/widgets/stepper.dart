import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';
import 'package:provider/provider.dart';

class CustomStepper extends StatefulWidget {
  final List<String> steps;
  late final int currentStep;

  CustomStepper({
    required this.steps,
    this.currentStep = 0,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  void incrementStep() {
    setState(() {
      widget.currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left: 50.0),
            height: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.steps.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String step = entry.value;

                  Color color = idx <= widget.currentStep
                      ? appColorScheme().onPrimary
                      : Colors.grey;

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
                              if (idx != widget.steps.length - 1)
                                Container(
                                  height: constraints.maxHeight *
                                      0.4 /
                                      (widget.steps.length - 1),
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
                              child: Text(
                                step,
                                style: TextStyle(color: color),
                              ),
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

