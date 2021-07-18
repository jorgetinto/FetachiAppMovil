import 'dart:async';

import 'package:fetachiappmovil/models/version_model.dart';
import 'package:fetachiappmovil/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;

import 'Auth/login_page.dart';
import 'Home/home_page.dart';

class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  final String _version                       = Constants.VERSION_APP;
  final authService                           = new AuthServices();
  VersionModel versionAPI                     = new VersionModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();    

  @override
  void initState() {
    super.initState();   
    asyncInitState();
  }

  void asyncInitState() async {    
    final versionAPI = await authService.getVersion();

    if (_version.compareTo(versionAPI.version) == 0 ) {

        final autenticado = await authService.refreshToken();
    
          if ( autenticado ) {
            Timer.run(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            });
          } else {
              Timer.run(() {
                Navigator.pushReplacement(
                              context, 
                              PageRouteBuilder(
                                pageBuilder: ( _, __, ___ ) => LoginPage(),
                                transitionDuration: Duration(milliseconds: 0)
                              )
                            );
              });
          }
    }else{
       Timer.run(() {
              Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                  pageBuilder: ( _, __, ___ ) => LoginPage(),
                  transitionDuration: Duration(milliseconds: 0)
                )
              );
          });         
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child:  Container(
                padding: EdgeInsets.symmetric(vertical: 200.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                  ),
                ),
              )
      ),
   );
  }
}