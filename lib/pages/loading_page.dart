import 'package:fetachiappmovil/pages/Auth/login_page.dart';
import 'package:fetachiappmovil/pages/Home/home_page.dart';
import 'package:fetachiappmovil/services/auth_service.dart';
import 'package:flutter/material.dart';


class LoadingPage extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) {
         return Container(
              padding: EdgeInsets.symmetric(vertical: 200.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                ),
              ),
            );
        },
        
      ),
   );
  }

  Future checkLoginState( BuildContext context ) async {

    final authService  = new AuthServices();

    final autenticado = await authService.refreshToken();

    if ( autenticado ) {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => HomePage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }

  }

}