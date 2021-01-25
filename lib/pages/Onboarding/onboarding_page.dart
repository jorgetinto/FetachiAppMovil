import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/pages/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';

import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';


class OnBoardingPage extends StatelessWidget {

  final pages = [
    SkOnboardingModel(
        title: 'Bienvenido a FetachiApp',
        description:
            'Podras utilizar esta aplicación como credencial',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/img/FETACHI.png'),
    SkOnboardingModel(
        title: 'Fetachi es Taekwon-do ITF',
        description:
            'We make ordering fast, simple and free-no matter if you order online or cash',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/img/ITF.png'),
    SkOnboardingModel(
        title: 'Recuerda cambiar tu contraseña',
        description: 'recuerda si es primera vez que ingresas debes cambiar tu contraseña',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/img/password.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: const Color(0xFF0a0a96),
        pages: pages,
        skipClicked: (value) {
            Navigator.pushReplacement(context, SlideRightSinOpacidadRoute(widget: HomePage()));
        },
        getStartedClicked: (value) {
          Navigator.pushReplacement(context, SlideRightSinOpacidadRoute(widget: HomePage()));
        },
      ),
    );
  }
}