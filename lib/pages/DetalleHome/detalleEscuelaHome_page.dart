import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/models/usuarioPorIdEscuela_model.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuariosAdd_page.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home_page.dart';


class DetalleEscuelaHomePage extends StatefulWidget {

  @override
  _DetalleEscuelaHomePageState createState() => _DetalleEscuelaHomePageState();
}

class _DetalleEscuelaHomePageState extends State<DetalleEscuelaHomePage> {

  final scaffoldKey                   = new GlobalKey<ScaffoldState>();
  UsuarioServices usuarioProvider     = new UsuarioServices();
  Escuela userData;
  
  @override
  void initState() { 
    Future.delayed(Duration.zero,(){
         setState(() {
          userData = ModalRoute.of(context).settings.arguments;
         });
       });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Dojang'),            
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => 
              Navigator.push (
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
              ),       
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Escuela",
                  icon: Icon(FontAwesomeIcons.fistRaised)
                ),
                Tab(
                  text: "Contactos",
                  icon: Icon(FontAwesomeIcons.users)
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              InternalDetalleEscuelaHome(userData),
              InternalContactosEscuelaHome(userData.idEscuela)             
            ],
          ),
        ),
      ),
    );
  }
}


// TAB 1
class InternalDetalleEscuelaHome extends StatefulWidget {

  final Escuela escuelaDetalle;
  const InternalDetalleEscuelaHome(this.escuelaDetalle);

  @override
  _InternalDetalleEscuelaHomeState createState() => _InternalDetalleEscuelaHomeState();
}

class _InternalDetalleEscuelaHomeState extends State<InternalDetalleEscuelaHome> {
  
  Widget _crearImagen(Escuela snapshot) {

      return Center(
        child: Container(
                  width: 250,
                  height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        child: (snapshot?.logo == null) 
                                          ?  ClipOval(child: Image.asset('assets/no-image.png')) 
                                          :  ClipOval(child: Container(child: Image.network(snapshot.logo))),
                        backgroundColor: Colors.grey[400],
                      ),
                    ),
                    
                  ),
      );  
    }

  Widget _textoContainer(String texto){
     return Container(
                        width: 360.0,
                        padding: new EdgeInsets.only(right: 13.0, left: 30.0),
                        child: new Text(
                          '$texto',
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                        ),
                      );
   }

  Widget _motivacion() {
      return Container(
        child: Column(
          children: [
            buildTitle("Instructor"),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child:
                 Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Row(
                        children: [
                            Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                      width: 60.0,
                                      height: 60.0,
                                      child: CircleAvatar(
                                          radius: 30.0,                   
                                          child: ClipOval(child: Image.asset('assets/no-image.png')) 
                                          ,backgroundColor: Colors.grey[400],
                                        ),
                                    ),
                                ]
                            ),
                            SizedBox(width: 10.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                      Container(
                                              width: 230,
                                              padding: new EdgeInsets.only(right: 13.0),
                                              child: new Text(
                                                'Instructor: ${widget.escuelaDetalle?.nombreInstructor}',
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          SizedBox(height: 5.0,),
                                          Container(
                                              padding: new EdgeInsets.only(right: 13.0),
                                              child: new Text(
                                                'Grado: ${widget.escuelaDetalle?.gradoInstructor}',
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                            ),
                          ],
                        )
                 ],
                ),
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _crearImagen(widget.escuelaDetalle),
              SizedBox(height: 10.0,),   

              buildTitle("${ widget.escuelaDetalle?.nombre }"), 

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child:Column(
                  children: [
                      SizedBox(height: 10.0,),
                      _textoContainer("Dirección: ${widget.escuelaDetalle?.direccion}"),
                      SizedBox(height: 5.0,),
                      _textoContainer("Comuna: ${widget.escuelaDetalle?.comuna}"),
                      SizedBox(height: 5.0,),
                      _textoContainer("Región: ${widget.escuelaDetalle?.region}"),
                  ],
                )
              ),    
              SizedBox(height: 30.0,),              
              _motivacion(),

              Column(
        children: [
          SizedBox(height: 20.0),
          buildTitle("Contacto"),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              SizedBox(width: 30.0),
              Icon(
                Icons.mail,
                color: Colors.black54,
              ),
              SizedBox(width: 10.0),
              Text(
                "${widget.escuelaDetalle?.correoInstructor}",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              SizedBox(width: 30.0),
              Icon(
                Icons.phone,
                color: Colors.black54,
              ),
              SizedBox(width: 10.0),
              Text(
                "${widget.escuelaDetalle?.fonoInstructor}",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
           SizedBox(height: 30.0,),    
        ],
      ) 
            ],
        ),
          ),
      )
   );
  }
}

// TAB 2
class InternalContactosEscuelaHome extends StatefulWidget {

  final int idEscuela;
  const InternalContactosEscuelaHome(this.idEscuela);

  @override
  _InternalContactosEscuelaHomeState createState() => _InternalContactosEscuelaHomeState();
}

class _InternalContactosEscuelaHomeState extends State<InternalContactosEscuelaHome> {

  TextEditingController controller                        = new TextEditingController();
  List<UsuarioPorIdEscuelaModel>   listaResultadoOriginal  = new  List<UsuarioPorIdEscuelaModel>();
  List<UsuarioPorIdEscuelaModel>  listaResultado          = new  List<UsuarioPorIdEscuelaModel>();
  List<UsuarioPorIdEscuelaModel>   listaResultadocopia     = new  List<UsuarioPorIdEscuelaModel>();

  Future<List<UsuarioPorIdEscuelaModel>>   listaUsuarios;
  EscuelaPorIdInstructorModel userData;
  String searchString = "";

  @override
  void initState() {
       Future.delayed(Duration.zero,(){
         setState(() {
          listaResultado                              = new  List<UsuarioPorIdEscuelaModel>();         
          listaUsuarios                               = usuarioProvider.getUsuariosByIdEscuela(widget.idEscuela);

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
            listaUsuarios                               = usuarioProvider.getUsuariosByIdEscuela(widget.idEscuela); 
            listaUsuarios.then((value) => {
              if (value != null)  listaResultadoOriginal.addAll(value)
            });    
          });
      });
    }

    Widget _crearItem(BuildContext context, UsuarioPorIdEscuelaModel usuario ) {

      return Card(
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
                            // Text(' ${ usuario.pho??'N/A' }') , 
                        ],), 
                        trailing: Icon(FontAwesomeIcons.whatsapp, color: Colors.green,),
                        isThreeLine: true,
                      ),
              ],
            ),
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
                  SizedBox(height: 80.0),
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
          Column(
              children: [
                  _search(),
                  SizedBox(height: 10.0),
                  buildTitle("Contactos"),
                  _featuredListHorizontal(),
                  SizedBox(height: 80.0),
              ],
            ),
          ]
        ),
      ),     
   );
   
  }
}