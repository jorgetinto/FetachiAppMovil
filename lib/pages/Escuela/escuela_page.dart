import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:flutter/material.dart';

import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;



class EscuelaPage extends StatefulWidget {

  @override
  _EscuelaPageState createState() => _EscuelaPageState();
}

class _EscuelaPageState extends State<EscuelaPage> {
  EscuelaBloc   escuelaBloc;  
  Future<List<EscuelaPorIdInstructorModel>>   escuelasLista;
  final escuelaProvider      = new EscuelaServices();

  final scaffoldKey          = GlobalKey<ScaffoldState>();

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

    escuelaBloc = ProviderBloc.escuelaBloc(context);

    setState(() {
          escuelasLista = escuelaProvider.getEscuelaByIdInstructor();
    });

    Widget _crearItem(BuildContext context, EscuelaPorIdInstructorModel escuela ) {

        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: ( direccion ){
            //productosProvider.borrarProducto(producto.id);
          },
          child: Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        //leading: FlutterLogo(size: 72.0),
                        leading: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: escuela.logo !=null? NetworkImage(escuela.logo): AssetImage('assets/img/FETACHI50.png'),// escuela.logo?? NetworkImage(escuela.logo),
                          backgroundColor: Colors.black,
                        ),
                        title: Text('${ escuela.nombre }'),
                        subtitle: Text( '${ escuela.nombreInstructor }  n\ ${ escuela.direccion }'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),

              ],
            ),
          )
        ); 
    }

    Widget _featuredListHorizontal()  {   
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 300.0,
        child: FutureBuilder(
          future: escuelasLista,
          builder: (BuildContext context, AsyncSnapshot<List<EscuelaPorIdInstructorModel>> listData) {
            if (!listData.hasData) {

              new Future.delayed(const Duration(seconds : 2));
              return Center(child: CircularProgressIndicator());


            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: listData.data.length,
                itemBuilder: (BuildContext context, int position) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[                     
                      _crearItem(context, listData.data[position] )
                    ],
                  );
                },
              );
            }
          },
        ),   
      ); 
    }

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
                _featuredListHorizontal()
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