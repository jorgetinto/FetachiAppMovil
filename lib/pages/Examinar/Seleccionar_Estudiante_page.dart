import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/models/detalle_examen_model.dart';
import 'package:fetachiappmovil/models/examen_model.dart';
import 'package:fetachiappmovil/models/usuarioExamen_model.dart';
import 'package:fetachiappmovil/pages/Examinar/DetalleExamen_page.dart';
import 'package:fetachiappmovil/pages/Examinar/Seleccionar_Examen_page.dart';
import 'package:fetachiappmovil/services/detalle_examen_service.dart';
import 'package:fetachiappmovil/services/examen_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;

import 'package:flutter/material.dart';


class SeleccionarEstudiantePage extends StatefulWidget {

  @override
  _SeleccionarEstudiantePageState createState() => _SeleccionarEstudiantePageState();
}

class _SeleccionarEstudiantePageState extends State<SeleccionarEstudiantePage> {

  GlobalKey<ScaffoldState>    scaffoldKey             = new GlobalKey<ScaffoldState>();
  TextEditingController       controller              = new TextEditingController();
  ExamenServices              examenProvider          = new ExamenServices();
  UsuarioServices             usuarioProvider         = new UsuarioServices();
  DetalleExamenService        detalleExamenProvider   = new DetalleExamenService();
  PreferenciasUsuario         _pref                   = new PreferenciasUsuario();
  List<UsuarioExamenModel>    listaResultadoOriginal  = new  List<UsuarioExamenModel>();
  List<UsuarioExamenModel>    listaResultado          = new  List<UsuarioExamenModel>();
  List<UsuarioExamenModel>    listaResultadocopia     = new  List<UsuarioExamenModel>();
  ExamenModel                 userData                = new ExamenModel();
  DetalleExamenModel          dataDetalleExamen       = new DetalleExamenModel();
  int idExamen;
  Future<DetalleExamenModel> detalle;
  ExamenModel detalleExamen;

  Future<List<UsuarioExamenModel>>   examenLista;
  String searchString = "";
  bool _loading = true;

  @override
  void initState() {
      new Future.delayed(new Duration(milliseconds: 1500), () {
        setState(() {
            _loading = false; 

          if (idExamen != null) {
            listaResultado  = null;
            examenLista     = usuarioProvider.getUsuarioParaExaminar(idExamen);
            examenLista.then((value) => {
                if (value != null)  listaResultadoOriginal.addAll(value)
            });

            examenProvider.getExamenById(idExamen).then((value) => {
                if (value != null) detalleExamen = value
            });    
          }
        });
      }); 
    super.initState();
  }

  AppBar _appBar(BuildContext context) {

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => 
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeleccionarExamenPage(),
                    settings: RouteSettings(
                      arguments: detalleExamen,
                    ),
                  ),
                )
      ),
      title: Text('Examinar'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
        detalleExamen  = ModalRoute.of(context).settings.arguments;
        if (detalleExamen != null) {
           _pref.idExamen = detalleExamen.idExamen;
            idExamen      = detalleExamen.idExamen;
        }else{
          idExamen      =  _pref.idExamen;
        }
    });

    Future<Null> _handleRefresh() async {
      await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            examenLista = usuarioProvider.getUsuarioParaExaminar(idExamen); 
            examenLista.then((value) => {
              if (value != null)  listaResultadoOriginal.addAll(value)
            });   
          });
      });
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
                        hintText: 'Buscar estudiante', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<UsuarioExamenModel>();
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

    Widget _crearItem(BuildContext context, UsuarioExamenModel examen, int identificadorExamen ) {

      return Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        leading: Text('Folio \n${examen.folio}'),
                        title: Text('${ examen.nombres }',
                         overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Container(
                              width: 350.0,
                              padding: new EdgeInsets.only(right: 13.0),
                              child: new Text(
                                'Escuela: ${ examen.escuela } \nGrado Actual: ${ examen.gradoActual }',
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black45,
                                ),
                              ),
                            ),                          
                        trailing: Icon(Icons.arrow_forward_ios),                            
                        isThreeLine: true,                      
                        onTap: () {

                        setState(() {
                            
                            final detalleExamenP =detalleExamenProvider
                              .getDetalleExamenByIdExamenYIdEstudianteAsync(examen.idExamen, examen.folio );
                              
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleExamenPage(),
                                settings: RouteSettings(
                                  arguments: detalleExamenP,
                                ),
                              ),
                            );
                          
                        });


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
          future: examenLista,
          builder: (BuildContext context, AsyncSnapshot<List<UsuarioExamenModel>> listData) {
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
                                     _crearItem(context, listData.data[position], idExamen)
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
                                      _crearItem(context, listaResultado[position], idExamen)
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

    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(context),
      body: (!_loading) 
          ?  SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                Column(
                    children: [
                      _search(),
                      SizedBox(height: 10.0),
                      utils.buildTitle("Seleccione un estudiante"),
                      _featuredListHorizontal()
                    ],
                  ),
                ]
              ),
            ) 
          : Container(
            padding: EdgeInsets.symmetric(vertical: 200.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
    );
  }
}