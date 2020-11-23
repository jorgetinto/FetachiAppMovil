import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;
import 'package:fetachiappmovil/services/usuario_service.dart';

import 'package:flutter/material.dart';

class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final escuelaProvider                                   = new EscuelaServices();
  final scaffoldKey                                       = new GlobalKey<ScaffoldState>();
  UsuarioServices usuarioProvider                         = new UsuarioServices();
  TextEditingController editingController                 = new TextEditingController();
  Future<List<UsuarioPorIdEscuelaModel>>   listaUsuarios;  
  Future<List<DropDownModel>>   selectEscuela;

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
  void initState() { 
    selectEscuela = escuelaProvider.getEscuelaPorIdUsuario();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final EscuelaPorIdInstructorModel userData  = ModalRoute.of(context).settings.arguments;
    listaUsuarios                               = usuarioProvider.getUsuariosByIdEscuela(userData.idEscuela);     

    Widget _crearItem(BuildContext context, UsuarioPorIdEscuelaModel usuario ) {

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
                Icons.delete,
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
                  content: const Text("Esta seguro que desea eliminar este usuario?"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                          usuarioProvider.deleteUsuario(usuario.id);
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

            // Debo crear un endpoint que retorne los mismos datos que cuando creo un usuario 


            // final usuarioDetails = usuarioPorIdEscuelaModelToJson(usuario);
            // Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => UsuariosAddPage(),
            //                   settings: RouteSettings(
            //                     arguments: userForRegisterModelToJson(usuarioDetails),
            //                   ),
            //                 ),
            //               );  
            return false;
          }
        },          
          child: Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: usuario.imagen !=null? NetworkImage(usuario.imagen): AssetImage('assets/img/FETACHI50.png'),// escuela.logo?? NetworkImage(escuela.logo),
                          backgroundColor: Colors.black,
                        ),
                       title: Text('${ usuario.nombres }'),
                        subtitle: Text('${ usuario.gradoActual }'),
                        trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                      ),
              ],
            ),
          )
        ); 
    }

    Widget _featuredListHorizontal()  {     
      
      return (listaUsuarios != null ) ?   
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).copyWith().size.height / 1.4,
        child: FutureBuilder(
          future: listaUsuarios,
          builder: (BuildContext context, AsyncSnapshot<List<UsuarioPorIdEscuelaModel>> listData) { 

            if (!listData.hasData || listData.data.length < 1) {
              new Future.delayed(const Duration(seconds : 2));
              return Center(child: Text("No se encontraron usuarios"));
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
      ): Container(height: 0, width: 0,);  
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
                  utils.buildTitle("Mis Usuarios"),
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