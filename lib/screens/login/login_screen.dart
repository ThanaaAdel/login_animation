import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_animation/animation_enum.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandUp;
  late RiveAnimationController controllerHandDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "sanaaadel@gmail.com";
  String testPassword = "123456";
  final passwordFocusNode = FocusNode();
  bool isLookLeft = false;
  bool isLookRight = false;
  void removeAllController() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerHandDown);
    riveArtboard?.artboard.removeController(controllerHandUp);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookLeft = false;
    isLookRight = false;
  }

  void addIdleController() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint("idleState");
  }

  void addSuccessController() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint("SuccessState");
  }

  void addFailController() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint("FailState");
  }

  void addHandUpController() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandUp);
    debugPrint("HandUpState");
  }

  void addHandDownController() {
    removeAllController();
    riveArtboard?.artboard.addController(controllerHandDown);
    debugPrint("HandDownState");
  }

  void addLookRightController() {
    removeAllController();
    isLookRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);

    debugPrint("LookRightState");
  }

  void addLookLeftController() {
    removeAllController();
    isLookLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);

    debugPrint("LookLeftState");
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerHandDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    rootBundle.load('assets/3287-6917-headless-bear.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    checkForPasswordFocusNodeToChangeInitialState();
  }

  void checkForPasswordFocusNodeToChangeInitialState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandDownController();
      }
    });
  }

  void validateEmailAndPassword() {
  Future.delayed(

      Duration(seconds: 1),(){
    if (formKey.currentState!.validate()) {
      addSuccessController();
    } else if (!formKey.currentState!.validate()) {
      addFailController();
    }
  });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: riveArtboard != null
                  ? Rive(artboard: riveArtboard!)
                  : SizedBox.shrink(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 18),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email : ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !isLookLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !isLookRight) {
                          addLookRightController();
                        }
                      },
                      validator: (value) =>
                          value != testEmail ? "Wrong Email" : null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
                    TextFormField(
                      focusNode: passwordFocusNode,
                      validator: (value) =>
                          value != testPassword ? "Wrong password" : null,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password : ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 12),
                    Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 8),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 14)),
                              onPressed: () {
                                passwordFocusNode.unfocus();
                                validateEmailAndPassword();
                                // checkForPasswordFocusNodeToChangeInitialState();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                        )),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
