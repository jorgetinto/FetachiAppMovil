import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;

import 'package:flutter/material.dart';

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
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.centerStart,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          secondaryBackground: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.delete_sharp,
                color: Colors.white,
              ),
            ),

        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Atención!"),
                  content: const Text("Esta seguro que desea eliminar esta escuela?"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                          escuelaProvider.deleteEscuela(escuela.idEscuela);
                          return Navigator.of(context).pop(true);
                        },
                      child: const Text("ELIMINAR")
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                  ],
                );
              },
            );
          }else{
            final escuelaInstructorJson = escuelaPorIdInstructorModelToJson(escuela);
            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EscuelaAddPage(),
                              settings: RouteSettings(
                                arguments: escuelaModelFromJson(escuelaInstructorJson),
                              ),
                            ),
                          );  
            return false;
          }
        },          
          child: Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: escuela.logo !=null? NetworkImage(escuela.logo): AssetImage('assets/img/FETACHI50.png'),// escuela.logo?? NetworkImage(escuela.logo),
                          backgroundColor: Colors.black,
                        ),
                        title: Text('${ escuela.nombre }'),
                        subtitle: Text( '${ escuela.nombreInstructor }  /n ${ escuela.direccion }'),
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
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).copyWith().size.height / 1.4,
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
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
        child: Stack(
          children: <Widget>[
          Column(
              children: [

                SizedBox(height: 20.0),
                  utils.buildTitle("Mis Escuelas"),
                  SizedBox(height: 5.0),
                  _featuredListHorizontal()
              ],
            ),
          ]
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