import 'package:badges/badges.dart';
import 'package:fetachiappmovil/helpers/constants.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/userForRegister_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuariosAdd_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/services/usuario_service.dart';

import 'package:flutter/material.dart';

import 'escuelasAsociadas_page.dart';

class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  GlobalKey<ScaffoldState>        scaffoldKey             = new GlobalKey<ScaffoldState>();
  EscuelaServices                 escuelaProvider         = new EscuelaServices();
  UsuarioServices                 usuarioProvider         = new UsuarioServices();
  UserForRegisterModel            register                = new UserForRegisterModel();
  TextEditingController           controller              = new TextEditingController();
  List<UsuarioPorIdEscuelaModel>  listaResultadoOriginal  = new  List<UsuarioPorIdEscuelaModel>();
  List<UsuarioPorIdEscuelaModel>  listaResultado          = new  List<UsuarioPorIdEscuelaModel>();
  List<UsuarioPorIdEscuelaModel>  listaResultadocopia     = new  List<UsuarioPorIdEscuelaModel>();
  EscuelaPorIdInstructorModel     userData                = new EscuelaPorIdInstructorModel();

  Future<List<UsuarioPorIdEscuelaModel>>   listaUsuarios;
  String searchString = "";
  bool _loading = true;


  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
         Navigator.push (
              context,
              MaterialPageRoute(builder: (context) => EscuelasAsociadas()),
          );
        },
      ),
      title: Text('Usuarios'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  void initState() {
      new Future.delayed(new Duration(milliseconds: 900), () {
        setState(() {
            _loading = false;         
        });
      }); 
    super.initState();
  }

  @override
  void dispose() {
    listaResultadoOriginal  = new  List<UsuarioPorIdEscuelaModel>();
    listaResultado          = new  List<UsuarioPorIdEscuelaModel>();
    listaResultadocopia     = new  List<UsuarioPorIdEscuelaModel>();
    listaUsuarios           = null;
    _loading          = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
        userData              = ModalRoute.of(context).settings.arguments;
        listaResultado        = new  List<UsuarioPorIdEscuelaModel>();         
        listaUsuarios         = usuarioProvider.getUsuariosByIdEscuela(userData.idEscuela);

        listaUsuarios.then((value) => {
          if (value != null)  listaResultadoOriginal.addAll(value)
        });
    });

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
                          backgroundImage: (usuario.imagen !=null && usuario.imagen != "")
                                ? NetworkImage("$IMAGEN_USUARIO${usuario.imagen}")
                                : AssetImage('assets/no-image.png'),
                          backgroundColor: Colors.black,
                        ),
                       title: 
                        Container(
                          width: 80.0,
                          padding: new EdgeInsets.only(right: 13.0),
                          child: new Text(
                            '${ usuario.folio } - ${ usuario.nombres } ',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),                       
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(' ${ usuario.gradoActual??'N/A' }') ,
                            Text('|') ,
                            Text(' ${ usuario.perfil??'N/A' }') ,
                            Text('|') ,
                            Badge(
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: (usuario.estado)? Colors.blue[900]: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                                badgeContent: Text((usuario.estado)?'Activo':'Inactivo', style: 
                                                    TextStyle(fontSize: 10.0,
                                                        fontFamily: 'Roboto',
                                                        color: Colors.white
                                                  )),
                              ),
                              
                        ],), 
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
        margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                          physics: BouncingScrollPhysics(),
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
                  SizedBox(height: 40.0),
                ],
              );
            }
          },
        ),   
      ): CircularProgressIndicator();
    }

    Widget _search(){
      return new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                        hintText: 'Buscar folio', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<UsuarioPorIdEscuelaModel>();
                                listaResultadocopia = listaResultadoOriginal.where((u) => (u.folio == int.parse(searchString))).toList();

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
                );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(context),
      body: (!_loading) ?        
        SingleChildScrollView(
        child: Stack(
          children: <Widget>[
          Column(
              children: [
                  _search(),
                  SizedBox(height: 10.0),
                  utils.buildTitle("Mis Usuarios"),
                  _featuredListHorizontal(),
              ],
            ),
          ]
        ),
      ):

      Container(
              padding: EdgeInsets.symmetric(vertical: 200.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
            
      floatingActionButton: FloatingActionButton(
        elevation: 1,
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