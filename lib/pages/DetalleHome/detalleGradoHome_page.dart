import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/detalle_examen_model.dart';
import 'package:fetachiappmovil/pages/Home/home_page.dart';
import 'package:fetachiappmovil/services/detalle_examen_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleGradoHomePage extends StatefulWidget {

  @override
  _DetalleGradoHomePageState createState() => _DetalleGradoHomePageState();
}

class _DetalleGradoHomePageState extends State<DetalleGradoHomePage> {  

  GlobalKey<ScaffoldState>   scaffoldKey             = new GlobalKey<ScaffoldState>();
  List<DetalleExamenModel>   listaResultadoOriginal  = new  List<DetalleExamenModel>();
  List<DetalleExamenModel>   listaResultado          = new  List<DetalleExamenModel>();
  List<DetalleExamenModel>   listaResultadocopia     = new  List<DetalleExamenModel>();
  TextEditingController      controller              = new TextEditingController();
  Future<List<DetalleExamenModel>> detalleLista;
  DetalleExamenService detalle  = new DetalleExamenService();

  String searchString = "";
  bool _loading = true;
  int userData;

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
      title: Text('Examenes'),
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
  Widget build(BuildContext context) {

    setState(() {
          userData = ModalRoute.of(context).settings.arguments;
          detalleLista = detalle.getDetalleExamenByFolio(userData);
          detalleLista.then((value) => {
            if (value != null)  listaResultadoOriginal.addAll(value)
          });
      });   

    Future<Null> _handleRefresh() async {
      await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            detalleLista     = detalle.getDetalleExamenByFolio(userData);
            detalleLista.then((value) => {
              if (value != null)  listaResultadoOriginal.addAll(value)
            });    
          });
      });
    }

    Widget _crearItem(BuildContext context, DetalleExamenModel grado ) {

       DateFormat dateFormat = DateFormat('dd-MM-yyyy');

      return Card(
            child: Column(
              children: <Widget>[
                 ListTile(
                        leading: CircleAvatar(
                            maxRadius: 30.0,
                            child: Text("${ grado.notaFinal }",
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              backgroundColor: grado.estado ? Colors.blue: Colors.red,
                            ),
                       title: 
                        Container(
                          width: 80.0,
                          padding: new EdgeInsets.only(right: 13.0),
                          child: new Text(
                            ' Grado: ${ grado.estado? grado.nombreGradoAscenso  : grado.nombreGradoActual }',
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
                            Text(' Fecha: ${ dateFormat.format(grado.fecha)}') ,
                            Text('|') ,
                            Text(' Estado: ${ grado.estado? 'aprobado' : 'rechazado' }') ,
                        ],), 
                        isThreeLine: true,
                      ),
              ],
            ),
          );
    }

    Widget _featuredListHorizontal()  {     
      
      return (detalleLista != null ) ?   
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).copyWith().size.height / 1.4,
        child: FutureBuilder(
          future: detalleLista,
          builder: (BuildContext context, AsyncSnapshot<List<DetalleExamenModel>> listData) { 

            if (!listData.hasData || listData.data.length < 1) {
              new Future.delayed(const Duration(seconds : 2));
              return Center(child: Text("No se han registrado examenes"));
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
                  SizedBox(height: 80.0),
                ],
              );
            }
          },
        ),   
      ): CircularProgressIndicator();
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
                   SizedBox(height: 20.0),
                   buildTitle("Mis Examenes"),
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

 
   );
  }
}