import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/UserLessMembresia_model.dart';
import 'package:fetachiappmovil/models/UsuarioMembresia_model.dart';
import 'package:fetachiappmovil/pages/UsuarioMembresia/UsuarioMembresiaAdd_page.dart';
import 'package:fetachiappmovil/pages/UsuarioMembresia/UsuarioMembresia_page.dart';
import 'package:fetachiappmovil/services/usuarioMembresia_service.dart';
import 'package:flutter/material.dart';

class UsuarioMembresiaEstudiantePage extends StatefulWidget {

  @override
  _UsuarioMembresiaEstudiantePageState createState() => _UsuarioMembresiaEstudiantePageState();
}

class _UsuarioMembresiaEstudiantePageState extends State<UsuarioMembresiaEstudiantePage> {

  GlobalKey<ScaffoldState>    scaffoldKey                 = new GlobalKey<ScaffoldState>();
  TextEditingController       controller                  = new TextEditingController();
  UsuarioMembresiaServices    examenProvider              = new UsuarioMembresiaServices();
  List<UserLessMembresiaModel>    listaResultadoOriginal  = new  List<UserLessMembresiaModel>();
  List<UserLessMembresiaModel>    listaResultado          = new  List<UserLessMembresiaModel>();
  List<UserLessMembresiaModel>    listaResultadocopia     = new  List<UserLessMembresiaModel>();
  UserLessMembresiaModel                 userData         = new UserLessMembresiaModel();
  Future<List<UserLessMembresiaModel>>   examenLista;
  String searchString = "";
  bool _loading = true;

  @override
  void initState() {
      new Future.delayed(new Duration(milliseconds: 1500), () {
        setState(() {
            _loading        = false; 
          listaResultado    = null;
            examenLista     = examenProvider.getUMQueNoTieneMembresiaByIdMestro();
            examenLista.then((value) => {
                if (value != null)  listaResultadoOriginal.addAll(value)
            });
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
                    builder: (context) => UsuarioMembresiaPage(),
                    settings: RouteSettings(
                     // arguments: detalleExamen,
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

    Future<Null> _handleRefresh() async {
      await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            examenLista = examenProvider.getUMQueNoTieneMembresiaByIdMestro();
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
                        hintText: 'Buscar Usuario', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<UserLessMembresiaModel>();
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

    Widget _crearItem(BuildContext context, UserLessMembresiaModel membresia ) {

      return Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        leading: Icon(Icons.perm_identity),
                        title: Text('${ membresia.nombre }',
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
                                '${ membresia.escuela } ',
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
                            
                           UsuarioMembresiaModel model  = new UsuarioMembresiaModel();
                           model.idUsuario              = membresia.idUser;
                           model.nombreUsuario          = membresia.nombre;
                           model.nombreEscuela          = membresia.escuela;
                              
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsuarioMembresiaAddPage(),
                                settings: RouteSettings(
                                  arguments: model,
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
          builder: (BuildContext context, AsyncSnapshot<List<UserLessMembresiaModel>> listData) {
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
                      buildTitle("Seleccione un estudiante"),
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