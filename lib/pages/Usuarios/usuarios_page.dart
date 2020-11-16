import 'package:fetachiappmovil/pages/Usuarios/usuariosAdd_page.dart';
import 'package:flutter/material.dart';

import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final scaffoldKey          = GlobalKey<ScaffoldState>();

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Usuarios'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
          Column(
              children: [

                SizedBox(height: 20.0),
                  utils.buildTitle("Usuarios"),
                  SizedBox(height: 5.0),
              ],
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, router.SlideRightRoute(widget: UsuariosAddPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
   );
  }
}