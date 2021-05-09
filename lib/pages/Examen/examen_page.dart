import 'package:fetachiappmovil/models/examen_model.dart';
import 'package:fetachiappmovil/pages/Examen/examenAdd_page.dart';
import 'package:fetachiappmovil/pages/Home/home_page.dart';
import 'package:fetachiappmovil/services/examen_service.dart';
import 'package:flutter/material.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;


class ExamenPage extends StatefulWidget {

  @override
  _ExamenPageState createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> {

  GlobalKey<ScaffoldState>    scaffoldKey             = new GlobalKey<ScaffoldState>();
  TextEditingController       controller              = new TextEditingController();
  ExamenServices              examenProvider          = new ExamenServices();
  List<ExamenModel>           listaResultadoOriginal  = new  List<ExamenModel>();
  List<ExamenModel>           listaResultado          = new  List<ExamenModel>();
  List<ExamenModel>           listaResultadocopia     = new  List<ExamenModel>();
  Future<List<ExamenModel>>   examenLista;
  String searchString = "";
  bool _loading = true;

  @override
  void initState() {
      new Future.delayed(new Duration(milliseconds: 1500), () {
        setState(() {
            _loading = false;         
        });
      }); 

      setState(() {
          listaResultado  = null;
          examenLista     = examenProvider.getAllExamenByIdMaestroAsync();
          examenLista.then((value) => {
            if (value != null)  listaResultadoOriginal.addAll(value)
          });
      });

    super.initState();
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
      title: Text('Examen'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {

    Future<Null> _handleRefresh() async {
      await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            examenLista = examenProvider.getAllExamenByIdMaestroAsync(); 
            examenLista.then((value) => {
              if (value != null)  listaResultadoOriginal.addAll(value)
            });   
          });
      });
    }

    Widget _crearItem(BuildContext context, ExamenModel examen ) {

      return  (examen != null)? Dismissible(
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
                  content: const Text("Esta seguro que desea desactivar este examen?"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                          examenProvider.deleteExamen(examen.idExamen);
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
            final examenJson = examenModelToJson(examen);
            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamenAddPage(),
                              settings: RouteSettings(
                                arguments: examenModelFromJson(examenJson),
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
                        leading: Icon(Icons.star),
                        title: Text('${ examen.nombre }'),
                        subtitle: Container(
                              width: 350.0,
                              padding: new EdgeInsets.only(right: 13.0),
                              child: new Text(
                                'Dir: ${ examen.direcion } \nComuna: ${ examen.nombreComuna }',
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Roboto',
                                  color: Colors.black45,
                                ),
                              ),
                            ),                          
                       trailing: Icon(Icons.more_vert),
                            
                        isThreeLine: true,
                      ),
              ],
            ),
          )
        ): Container(height: 0, width: 0,);
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
                        hintText: 'Buscar examen', border: InputBorder.none),
                        onChanged: (value) {
                            setState((){
                              if (value.length >= 3){
                                searchString = value;
                                listaResultadocopia = new List<ExamenModel>();
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

    Widget _featuredListHorizontal()  {   
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).copyWith().size.height / 1.4,
        child: FutureBuilder(
          future: examenLista,
          builder: (BuildContext context, AsyncSnapshot<List<ExamenModel>> listData) {
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
                      utils.buildTitle("Examenes"),
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

      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: () {
         ExamenModel model = new ExamenModel();
         model.estado = true; 
         Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamenAddPage(),
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