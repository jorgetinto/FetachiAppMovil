import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/services/userPerfil_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;


import '../Usuarios/editarPerfil_page.dart';


class DetallePupiloHomePage extends StatefulWidget {

  @override
  _DetallePupiloHomePageState createState() => _DetallePupiloHomePageState();
}

class _DetallePupiloHomePageState extends State<DetallePupiloHomePage> {

  Apoderado userData          = new Apoderado();
  UserPerfilServices services = new UserPerfilServices();
  UserPerfilModel model       = new UserPerfilModel();

  Widget _textoContainer(String texto){
     return Container(
              width: 300.0,
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

  Widget _imagen(){

    return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Center(
                child: Container(
                    width: 250.0,
                    height: 250.0,
                    child: CircleAvatar(
                        radius: 30.0,                   
                        child: (userData?.imagen == null) 
                                ?  ClipOval(child: Image.asset('assets/no-image.png')) 
                                :  ClipOval(child: Container(child: Image.network("${Constants.IMAGEN_USUARIO}${userData?.imagen}"))),
                        backgroundColor: Colors.grey[400],
                      ),
                  ),
              ),         

                Positioned(
                  left: 150.0,
                  right: 10.0,
                  bottom: 10.0, 
                  top: 175.0,
                  child:  MaterialButton(
                                        onPressed: () {
                                         Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditarPerfilPage(),
                                              settings: RouteSettings(
                                                arguments: model,
                                              ),
                                            ),
                                          );    
                                      },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: Icon(Icons.edit, size: 20.0),
                                    padding: EdgeInsets.all(5),
                                    shape: CircleBorder())
              ),
            ]
        );
  }

  Widget _abreviacionNombre(){
    return CircleAvatar(
            maxRadius: 30.0,
            child: Text("${ userData?.nombres[0]??''}${ userData?.apellidoPaterno[0]??'' }",
                    style: new TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
            );
  }

  AppBar _appBar() {
    return AppBar(
        title: Text('Pupilo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),              
          onPressed: () => Navigator.of(context).pop(),
        ), 
        backgroundColor: Colors.black,
        centerTitle: true,
      );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      userData = ModalRoute.of(context).settings.arguments;
      services.getUsuarioById(userData.id).then(
            (value) =>  { if (value != null) model = value }
      );
    });

    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child:         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imagen(),    
              SizedBox(height: 10.0,), 
              buildTitle("Contacto"),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child:
                Column(
                  children: [
                    Row(
                      children: [
                      _abreviacionNombre(),
                        Column(
                          children: [
                              SizedBox(height: 20.0,),
                              _textoContainer("Folio: ${userData?.folio}"),
                               SizedBox(height: 5.0,),
                              _textoContainer("${ userData?.nombres } ${ userData?.apellidoPaterno } ${ userData?.apellidoMaterno }"),
                               SizedBox(height: 5.0,),
                              _textoContainer("Rut: ${userData?.rut}"),
                              SizedBox(height: 5.0,),
                              _textoContainer("Escuela: ${userData?.escuela}"),
                               SizedBox(height: 5.0,),
                              Visibility(
                                visible: (userData.grado != null? true: false), 
                                child: _textoContainer("Grado: ${userData?.grado}")
                              ),
                              SizedBox(height: 5.0,),
                              _textoContainer("Dirección: ${userData?.direccion??'Sin Información'}"),
                              SizedBox(height: 5.0,),
                              Visibility(
                                visible: (userData.grado != null? true: false), 
                                child: _textoContainer("Comuna: ${userData?.comuna??'Sin Información'}")
                              ),
                              
                            ],
                        )
                      ],
                    ),
                  ],
                )
              ),    
              Column(
                children: [
                  SizedBox(height: 20.0),
                  division(),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 30.0),
                      Icon(Icons.mail,color: Colors.black54,),
                      SizedBox(width: 10.0),
                      Text("${userData?.email??'Sin Información'}",style: TextStyle(fontSize: 16.0),),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 30.0),
                      Icon(Icons.phone, color: Colors.black54,),
                      SizedBox(width: 10.0),
                      InkWell(
                          child: Text( "+569 ${userData?.fono??'Sin Información'}",style: TextStyle(fontSize: 16.0),),
                          onTap: () {                           
                            if (userData?.fono != null && userData.fono.isNotEmpty){
                              FlutterOpenWhatsapp.sendSingleMessage("+569 ${userData?.fono}", "Hello");
                            }else {
                              showToast(context, 'Número invalido'); 
                            }
                          },
                      )
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