import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';


class DetalleContactoHomePage extends StatefulWidget {

  @override
  _DetalleContactoHomePageState createState() => _DetalleContactoHomePageState();
}

class _DetalleContactoHomePageState extends State<DetalleContactoHomePage> {

  InformacionContacto userData = new InformacionContacto();

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
    return  Center(
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
                                child:  ClipOval(child: Image.asset('assets/img/FETACHI.png')),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            
                          ),
              );
  }

  Widget _abreviacionNombre(){
    return CircleAvatar(
            maxRadius: 30.0,
            child: Text("${ userData?.nombre[0]??''}${ userData?.apellidoPaterno[0]??'' }",
                    style: new TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
            );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      userData = ModalRoute.of(context).settings.arguments;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto de emergencia'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),              
          onPressed: () => Navigator.of(context).pop(),
        ), 
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
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
                              _textoContainer("${ userData?.nombre } ${ userData?.apellidoPaterno } ${ userData?.apellidoMaterno }"),
                              SizedBox(height: 5.0,),
                              _textoContainer("Dirección: ${userData?.direccion??'Sin Información'}"),
                              SizedBox(height: 5.0,),
                              _textoContainer("Comuna: ${userData?.comuna??'Sin Información'}"),
                              SizedBox(height: 5.0,),
                              _textoContainer("Región: ${userData?.region??'Sin Información'}"),
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