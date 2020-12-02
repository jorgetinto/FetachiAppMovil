import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/userForRegister_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuariosAdd_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
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
  UserForRegisterModel register                           = new UserForRegisterModel();
  TextEditingController controller                        = new TextEditingController();

  List<UsuarioPorIdEscuelaModel>   listaResultadoOriginal  = new  List<UsuarioPorIdEscuelaModel>();
   List<UsuarioPorIdEscuelaModel>   listaResultado         = new  List<UsuarioPorIdEscuelaModel>();
  List<UsuarioPorIdEscuelaModel>   listaResultadocopia     = new  List<UsuarioPorIdEscuelaModel>();

  Future<List<UsuarioPorIdEscuelaModel>>   listaUsuarios;
  EscuelaPorIdInstructorModel userData;
  String searchString = "";


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

       Future.delayed(Duration.zero,(){
         setState(() {
          userData                                    = ModalRoute.of(context).settings.arguments;
          listaResultado                              = new  List<UsuarioPorIdEscuelaModel>();
          listaUsuarios                               = usuarioProvider.getUsuariosByIdEscuela(userData.idEscuela);

          listaUsuarios.then((value) => {
            if (value != null)  listaResultadoOriginal.addAll(value)
          });

         });
       });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<Null> _handleRefresh() async {
        await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              listaUsuarios                               = usuarioProvider.getUsuariosByIdEscuela(userData.idEscuela); 
              listaUsuarios.then((value) => {
                if (value != null)  listaResultadoOriginal.addAll(value)
              });    
            });
        });
      }

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
            final usuarioDetails = await usuarioProvider.getUsuarioByIdUsuario(usuario.id);
            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsuariosAddPage(),
                              settings: RouteSettings(
                                arguments: usuarioDetails,
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
                          backgroundImage: usuario.imagen !=null && usuario.imagen != ""
                                ? NetworkImage(usuario.imagen)
                                : AssetImage('assets/img/FETACHI50.png'),
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
              return Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: RefreshIndicator(
                        child: 

                        (searchString == "" || searchString == null) 
                        ?  ListView.builder(
                          shrinkWrap: true,
                          itemCount: listData.data.length,
                          itemBuilder: (BuildContext context, int position) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[       
                                _crearItem(context, listData.data[position])
                              ],
                            );
                          },
                        ) :
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listaResultado.length,
                          itemBuilder: (BuildContext context, int position) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[       
                                _crearItem(context, listaResultado[position])
                              ],
                            );
                          },
                        ),
                       onRefresh: _handleRefresh,
                    ),
                  ),
                ],
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
                  new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              
                               
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<UsuarioPorIdEscuelaModel>();
                                listaResultadocopia = listaResultadoOriginal.where((u) => (u.nombres.toLowerCase().contains(searchString.toLowerCase()))).toList();

                                if (listaResultadocopia.length > 0)
                                    listaResultado = listaResultadocopia;

                                if (searchString == "" || searchString == null)
                                    listaResultado = listaResultadoOriginal;  
                              }else{
                                  searchString = "";
                                  listaResultado = listaResultadoOriginal; 
                              }

                            });
                          },
                        ),
                      trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                          setState(() {
                            controller.clear();
                            searchString = ""; 
                            listaResultado = listaResultadoOriginal;                           
                          });
                      },),
                    ),
                  ),
                ),

                  SizedBox(height: 20.0),
                  utils.buildTitle("Mis Usuarios"),
                  SizedBox(height: 5.0),
                  _featuredListHorizontal(),
                  SizedBox(height: 80.0),
              ],
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           register.idEscuela = userData.idEscuela;
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuariosAddPage(),
                    settings: RouteSettings(
                      arguments: register,
                    ),
                  ),
                );  
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
   );
  }
}