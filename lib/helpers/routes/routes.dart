import 'package:fetachiappmovil/pages/resetPassword_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fetachiappmovil/pages/home_page.dart';

final pageRoutes = <_Route>[
      _Route(FontAwesomeIcons.userCircle, 'Perfil', HomePage()),
      _Route(FontAwesomeIcons.lock, 'Cambiar Contraseña', Resetpassword()),
  ];

  class _Route {
    final IconData icon;
    final String titulo;
    final Widget page;
    _Route(this.icon, this.titulo, this.page);  
  }

  class SlideRightRoute extends PageRouteBuilder {
    final Widget widget;
    SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
          
          final curveAnimarion = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return SlideTransition(
            position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero).animate(curveAnimarion),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curveAnimarion),
                child: child
              )
          );
        } 
      );
  }

  class SlideRightSinOpacidadRoute extends PageRouteBuilder {
    final Widget widget;
    SlideRightSinOpacidadRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
          
          final curveAnimarion = CurvedAnimation(parent: animation, curve: Curves.decelerate);

          return SlideTransition(
            position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero).animate(curveAnimarion),
            child: child
          );
        } 
      );
  }