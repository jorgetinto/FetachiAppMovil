import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:flutter/material.dart';

import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;



class EscuelaPage extends StatelessWidget {

  final scaffoldKey                 = GlobalKey<ScaffoldState>();

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Escuelas'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

               SizedBox(height: 20.0),
                utils.buildTitle("Mis Escuelas"),
                SizedBox(height: 5.0),

              // ListView(
              //     children: const <Widget>[
              //       Card(
              //         child: ListTile(
              //           leading: FlutterLogo(size: 72.0),
              //           title: Text('Three-line ListTile'),
              //           subtitle: Text(
              //             'A sufficiently long subtitle warrants three lines.'
              //           ),
              //           trailing: Icon(Icons.more_vert),
              //           isThreeLine: true,
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
      



      

     floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, router.SlideRightRoute(widget: EscuelaAddPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
   );
  }
}