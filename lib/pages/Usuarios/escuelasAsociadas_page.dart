import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/userForRegister_model.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuariosAdd_page.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuarios_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;

import 'package:flutter/material.dart';


class EscuelasAsociadas extends StatefulWidget {

  @override
  _EscuelasAsociadasState createState() => _EscuelasAsociadasState();
}

class _EscuelasAsociadasState extends State<EscuelasAsociadas> {

  final escuelaProvider                                   = new EscuelaServices();
  final scaffoldKey                                       = new GlobalKey<ScaffoldState>();
  final _prefs                                            = new PreferenciasUsuario();
  TextEditingController controller                        = new TextEditingController();
  List<EscuelaPorIdInstructorModel>   listaResultadoOriginal  = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultado          = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultadocopia     = new  List<EscuelaPorIdInstructorModel>();
  Future<List<EscuelaPorIdInstructorModel>>   escuelasLista;
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
          listaResultado = new  List<EscuelaPorIdInstructorModel>();
          escuelasLista = escuelaProvider.getEscuelaByIdInstructor();

          escuelasLista.then((value) => {
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
              escuelasLista = escuelaProvider.getEscuelaByIdInstructor(); 
              escuelasLista.then((value) => {
                if (value != null)  listaResultadoOriginal.addAll(value)
              });   
            });
        });
      }

    Widget _crearItem(BuildContext context, EscuelaPorIdInstructorModel escuela ) {

      return Card(
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
                        trailing: Icon(Icons.chevron_right),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsuariosPage(),
                              settings: RouteSettings(
                                arguments: escuela,
                              ),
                            ),
                          );
                        },
                  ),                      
              ],
            ),
          ); 
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
              return Center(child: Text("Para continuar debe crear una escuela primero"));
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
          Column(
              children: [
                  _search(),
                  SizedBox(height: 10.0),
                  utils.buildTitle("Seleccione una escuela"),                
                  _featuredListHorizontal(),
                 
              ],
            ),
          ]
        ),
      ),
      floatingActionButton: 
              (_prefs.perfil == "Admin" || _prefs.perfil == "Maestro") ?
                  FloatingActionButton(
                    onPressed: () {
                      //register.idEscuela = userData.idEscuela;
                      UserForRegisterModel model = new UserForRegisterModel();
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsuariosAddPage(),
                                settings: RouteSettings(
                                  arguments: model,
                                ),
                              ),
                            );  
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.redAccent,
                  ): Container(height: 0, width: 0,)
          );
  }
}