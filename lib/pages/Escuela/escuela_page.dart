import 'package:badges/badges.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuelaAdd_page.dart';
import 'package:fetachiappmovil/pages/home_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;

import 'package:flutter/material.dart';

class EscuelaPage extends StatefulWidget {

  @override
  _EscuelaPageState createState() => _EscuelaPageState();
}

class _EscuelaPageState extends State<EscuelaPage> {
  final escuelaProvider      = new EscuelaServices();
  final scaffoldKey          = new GlobalKey<ScaffoldState>();

  TextEditingController controller                            = new TextEditingController();
  List<EscuelaPorIdInstructorModel>   listaResultadoOriginal  = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultado          = new  List<EscuelaPorIdInstructorModel>();
  List<EscuelaPorIdInstructorModel>   listaResultadocopia     = new  List<EscuelaPorIdInstructorModel>();
  Future<List<EscuelaPorIdInstructorModel>>   escuelasLista;
  String searchString = "";

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
                          backgroundImage: escuela.logo !=null? NetworkImage(escuela.logo): AssetImage('assets/img/FETACHI50.png'),// escuela.logo?? NetworkImage(escuela.logo),
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
      body: SingleChildScrollView(
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