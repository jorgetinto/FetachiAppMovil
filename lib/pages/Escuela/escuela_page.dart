import 'package:badges/badges.dart';
import 'package:fetachiappmovil/helpers/constants.dart';
import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:fetachiappmovil/pages/Home/home_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;

import 'package:flutter/material.dart';

class EscuelaPage extends StatefulWidget {

  @override
  _EscuelaPageState createState() => _EscuelaPageState();
}

class _EscuelaPageState extends State<EscuelaPage> {

  EscuelaServices                     escuelaProvider         = new EscuelaServices();
  GlobalKey<ScaffoldState>            scaffoldKey             = new GlobalKey<ScaffoldState>();
  TextEditingController               controller              = new TextEditingController();
  List<EscuelaPorIdInstructorModel>   listaResultadoOriginal  = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultado          = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultadocopia     = new  List<EscuelaPorIdInstructorModel>();
  Future<List<EscuelaPorIdInstructorModel>>   escuelasLista;
  final _prefs            = new PreferenciasUsuario();
  String searchString = "";
  bool _loading = true;

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
    listaResultadoOriginal  = new  List<EscuelaPorIdInstructorModel>();
    listaResultado          = new  List<EscuelaPorIdInstructorModel>();
    listaResultadocopia     = new  List<EscuelaPorIdInstructorModel>();
    escuelasLista           = null;
    _loading          = true;
    super.dispose();
  }
    
  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => 
        Navigator.push (
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
        ),
      ),
      title: Text('Escuelas'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      listaResultado = null;
      escuelasLista = escuelaProvider.getEscuelaByIdInstructor();

      escuelasLista.then((value) => {
        if (value != null)  listaResultadoOriginal.addAll(value)
      });
    });

    Future<Null> _handleRefresh() async {
        await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              escuelasLista = escuelaProvider.getEscuelaByIdInstructor(); 
              escuelasLista.then((value) => {
                if (value != null)  listaResultadoOriginal.addAll(value)
              });   
            });
        });
      }

    Widget _crearItem(BuildContext context, EscuelaPorIdInstructorModel escuela ) {

      return  (escuela != null)? Dismissible(
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
                  content: const Text("Esta seguro que desea desactivar esta escuela?, todos los usuarios asociados a esta escuela quedaran desactivados"),
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
                          backgroundImage: (escuela.logo !=null && escuela.logo != "")? NetworkImage("$IMAGEN_ESCUELA${escuela?.logo}"): AssetImage('assets/no-image.png'),// escuela.logo?? NetworkImage(escuela.logo),
                          backgroundColor: Colors.black,
                        ),
                        title: Text('${ escuela.nombre }'),
                        subtitle: Container(
                              width: 350.0,
                              padding: new EdgeInsets.only(right: 13.0),
                              child: new Text(
                                'Instructor: ${ escuela.nombreInstructor } \nDir.: ${ escuela.direccion }',
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black45,
                                ),
                              ),
                            ),                          
                        trailing:
                            Column(
                              children: [
                                Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: (escuela.estado)? Colors.blue[900]: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                    badgeContent: Text((escuela.estado)?' A ':' I ', style: 
                                                        TextStyle(fontSize: 10.0,
                                                            fontFamily: 'Roboto',
                                                            color: Colors.white
                                                      )),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.red,
                                    borderRadius: BorderRadius.circular(20), 
                                    badgeContent: Text(' ${escuela.cantidadUsuarios} ', style: 
                                                        TextStyle(fontSize: 10.0,
                                                            fontFamily: 'Roboto',
                                                            color: Colors.white
                                                      )),                                  
                                  ),
                              ],
                            ),
                        isThreeLine: true,
                      ),
              ],
            ),
          )
        ): Container(height: 0, width: 0,);
    }

    Widget _featuredListHorizontal()  {   
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).copyWith().size.height / 1.4,
        child: FutureBuilder(
          future: escuelasLista,
          builder: (BuildContext context, AsyncSnapshot<List<EscuelaPorIdInstructorModel>> listData) {
            if (!listData.hasData) {
              new Future.delayed(const Duration(seconds : 2));
              return Center(child: Text("Sin Información"));
            } else {
              return 
                  Column(
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
      ); 
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
                        hintText: 'Buscar escuela', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<EscuelaPorIdInstructorModel>();
                                listaResultadocopia = listaResultadoOriginal.where((u) => (u.nombre.toLowerCase().contains(searchString.toLowerCase()))).toList();

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
                  utils.buildTitle("Mis Escuelas"),
                  _featuredListHorizontal()
              ],
            ),
          ]
        ),
      ) :

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
         EscuelaModel model = new EscuelaModel();
         model.estado = true;        

          if(listaResultadoOriginal.isEmpty && (_prefs.perfil == "Instructor"  )) {
              model.idInstructor = int.parse(_prefs.uid);
          }
          else if (listaResultadoOriginal.isEmpty && (_prefs.perfil == "Maestro")) {
            model.idInstructor = int.parse(_prefs.uid); 
            model.idMaestro = int.parse(_prefs.uid);     
          }
          else{
              model.idInstructor = listaResultadoOriginal[0]?.idInstructor??null;
          }


         Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EscuelaAddPage(),
                        settings: RouteSettings(
                          arguments: model
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