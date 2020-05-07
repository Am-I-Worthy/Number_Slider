import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

double offsetDx = 0.0;
double startValue = 0.0;
double diff = 0.0;
int index = 1;
double containerWidth = 100.0;
int count = 0;
int direction = 0;

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller1;
  SequenceAnimation sequenceAnimation1;
  AnimationController _controller2;
  SequenceAnimation sequenceAnimation2;

  @override
  void initState() {
    super.initState();
    _controller1 =
        AnimationController(duration: Duration(milliseconds: 375), vsync: this);
    sequenceAnimation1 = new SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0.0, end: -1.5),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 200),
          tag: "container",
          curve: Curves.easeIn,
        )
        .addAnimatable(
            animatable: Tween<double>(begin: 1.0, end: 0.0),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 200),
            tag: "containerOpacity")
        .addAnimatable(
            animatable: Tween<double>(begin: -1.5, end: 1.5),
            from: const Duration(milliseconds: 200),
            to: const Duration(milliseconds: 201),
            tag: "container")
        .addAnimatable(
          animatable: Tween<double>(begin: 1.5, end: 0.0),
          from: const Duration(milliseconds: 201),
          to: const Duration(milliseconds: 500),
          tag: "container",
          curve: Curves.easeIn,
        )
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 1.0),
            from: const Duration(milliseconds: 201),
            to: const Duration(milliseconds: 500),
            tag: "containerOpacity")
        .animate(_controller1);

    _controller2 =
        AnimationController(duration: Duration(milliseconds: 375), vsync: this);
    sequenceAnimation2 = new SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0.0, end: 1.5),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 200),
          tag: "container",
          curve: Curves.easeIn,
        )
        .addAnimatable(
            animatable: Tween<double>(begin: 1.0, end: 0.0),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 200),
            tag: "containerOpacity")
        .addAnimatable(
            animatable: Tween<double>(begin: 1.5, end: -1.5),
            from: const Duration(milliseconds: 200),
            to: const Duration(milliseconds: 201),
            tag: "container")
        .addAnimatable(
          animatable: Tween<double>(begin: -1.5, end: 0.0),
          from: const Duration(milliseconds: 201),
          to: const Duration(milliseconds: 500),
          tag: "container",
          curve: Curves.easeIn,
        )
        .addAnimatable(
            animatable: Tween<double>(begin: 0.0, end: 1.0),
            from: const Duration(milliseconds: 201),
            to: const Duration(milliseconds: 500),
            tag: "containerOpacity")
        .animate(_controller2);

    _controller1.addListener(() {
      setState(() {
        print("view....${_controller1.value}");
        if (_controller1.value > 0.6 && count == 0) {
          index++;
          count++;
        }
        if (_controller1.isCompleted) {
          _controller1.reset();
          count = 0;
          if (offsetDx != 0.0) {
            _controller1.forward();
          }
        }
      });
    });

    _controller2.addListener(() {
      setState(() {
        print("view....${_controller2.value}");
        if (_controller2.value > 0.6 && count == 0) {
          index--;
          count++;
        }
        if (_controller2.isCompleted) {
          _controller2.reset();
          count = 0;
          if (offsetDx != 0.0) {
            _controller2.forward();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onHorizontalDragStart: (value) {
                    startValue = value.localPosition.distance / 1000;
                  },
                  onHorizontalDragUpdate: (value) {
                    diff = startValue + value.localPosition.distance / 1000;
                    setState(() {
                      if (startValue > value.localPosition.distance / 1000) {
                        offsetDx = -(0.62 - diff);
                        print(offsetDx);
                        direction = -1;
                        _controller2.forward();
                      } else if (startValue <
                          value.localPosition.distance / 1000) {
                        offsetDx = (-0.26 + diff);
                        print(offsetDx);
                        _controller1.forward();
                        print('.....');
                        direction = 1;
                      }
                    });
                  },
                  onHorizontalDragEnd: (value) {
                    setState(() {
                      count = 0;
                      offsetDx = 0.0;
                      print(offsetDx);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 120.0,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(0.5, 0.0),
                          child: Container(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[300],
                              size: 40.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(-0.5, 0.0),
                          child: Container(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey[300],
                              size: 40.0,
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          curve: Curves.elasticOut,
                          duration: Duration(milliseconds: 900),
                          alignment: Alignment(offsetDx.clamp(-2.2, 2.2), 0.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 375),
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue[300],
                                      offset: Offset(0.0, 15.0),
                                      blurRadius: 20.0,
                                      spreadRadius: 0.0)
                                ]),
                            child: Align(
                              alignment: Alignment(
                                  (direction == -1)
                                      ? sequenceAnimation2['container'].value
                                      : sequenceAnimation1['container'].value,
                                  0.0),
                              child: Opacity(
                                opacity: (direction == -1)
                                    ? sequenceAnimation2['containerOpacity']
                                        .value
                                    : sequenceAnimation1['containerOpacity']
                                        .value,
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                      fontSize: 43.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
