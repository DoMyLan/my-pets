import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/custom_widget/banner_card_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        _controllers[i]
            .forward()
            .then((value) => _controllers[i].repeat(reverse: true));
      });
      _controllers.add(AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      ));
      _animations.add(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeInOut,
      ));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                      height: 470,
                      alignment: Alignment.bottomCenter,
                      child: bannerCard()),
                ),
                Center(
                  child: Container(
                    height: 350,
                    child: Image.asset('assets/images/dog_banner.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  10, // Generate 10 widgets
                  (index) => index % 2 == 0
                      ? AnimatedBuilder(
                          animation: _animations[index ~/ 2],
                          builder: (context, child) => Transform.translate(
                            offset:
                                Offset(0, -15 * _animations[index ~/ 2].value),
                            child: child,
                          ),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : SizedBox(
                          width:
                              15), // Add a SizedBox with width 20 between dots
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
