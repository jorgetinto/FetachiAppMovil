
import 'package:fetachiappmovil/pages/Auth/login_page.dart';
import 'package:fetachiappmovil/pages/DetalleHome/detalleEscuelaHome_page.dart';
import 'package:fetachiappmovil/pages/DetalleHome/detalleGradoHome_page.dart';
import 'package:fetachiappmovil/pages/DetalleHome/detallePupiloHome_page.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import '../DetalleHome/detalleApoderadoHome_page.dart';
import '../DetalleHome/detalleContactoHome_page.dart';

import 'package:fetachiappmovil/helpers/preferencias_usuario/preferenciasUsuario.dart';
import 'package:fetachiappmovil/helpers/widget/Menu_widget.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart' as router;
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/helpers/validators/validaciones_varias.dart' as validar;
import 'package:fetachiappmovil/helpers/constants.dart' as Constants;
import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/helpers/utils.dart';

import 'package:animate_do/animate_do.dart';
//import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _prefs            = new PreferenciasUsuario();

   ListTile _buildExperienceRow(
        {String company,
        String position,
        String duration,
        IconData icono,
        Widget page,
        dynamic parametros
        }) {
      String dura = (duration != "") ? '($duration)' : '';

      return ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20.0),
          child: Icon(
            (icono == null ? FontAwesomeIcons.solidCircle : icono),
            size: 20.0,
            color: Colors.black54,
          ),
        ),
        title: Text(
          company,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$position $dura"),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 20.0),
          child: IconButton(
            icon: Icon(FontAwesomeIcons.chevronRight,
                color: Colors.black87, size: 20.0),
            onPressed: () {
              if (page != null) {
                  if (parametros == null)
                      Navigator.push(context, router.SlideRightRoute(widget: page));
                  else
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => page,
                              settings: RouteSettings(
                                arguments: parametros,
                              ),
                            ),
                          );
               
              }
            },
          ),
        ),
      );
    }

  @override
  void initState() {
    if (_prefs.token.toString().isEmpty){
       Navigator.pushReplacement(
        context,
        router.SlideRightSinOpacidadRoute(widget: LoginPage())
      );
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {  

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final perfilBloc = ProviderBloc.userPefilBloc(context);
    perfilBloc.buscarUserPerfil();   
  
    Widget _crearImagen(AsyncSnapshot<UserPerfilModel> snapshot) {

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
                        child: (snapshot.data.imagen == null) 
                                          ?  ClipOval(child: Image.asset('assets/no-image.png')) 
                                          :  ClipOval(child: Container(child: Image.network("${Constants.IMAGEN_USUARIO}${snapshot.data.imagen}"))),
                        backgroundColor: Colors.grey[400],
                      ),
                    ),
                    
                  ),
      );
    }

    Widget _iconoEstrellas(AsyncSnapshot<UserPerfilModel> snapshot) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            snapshot.data.grado != null ?            
              FadeInLeft(
                from: 20,
                child: Column(
                  children: [
                    Icon(Icons.star, color: Color(0xffffdd00)),
                    Text(
                      'Grado:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${snapshot.data.grado.numGup?? snapshot.data.grado?.numDan?? "N/A"} ${(snapshot.data.grado.numGup != null)? "° gup": "° Dan"}'),
                  ],
                ),
               ) : Container(height: 0, width: 0,),

            snapshot.data.grado != null ?
                snapshot.data.fechaDeNacimiento != null ?   
                  FadeInLeft(
                    from: 20,
                    child: Column(
                      children: [
                        Icon(Icons.star, color: Color(0xffffdd00)),
                        Text(
                          'Edad:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      Text(utils.calculateAge('${snapshot.data.fechaDeNacimiento}')),
                      ],
                    ),
                ) : Container(height: 0, width: 0,)
              : Container(height: 0, width: 0,),
          ],
        ),
      );
    }
  
    Widget _gradoActual(AsyncSnapshot<UserPerfilModel> snapshot) {
        return snapshot.data.grado != null ?
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    utils.buildTitle("Grado Actual"),
                    SizedBox(height: 5.0),

                    _buildExperienceRow(
                                company: "Cinturon ${snapshot.data.grado?.nombre}",
                                position: "${snapshot.data.grado.numGup?? snapshot.data.grado?.numDan?? "N/A"} ${(snapshot.data.grado.numGup != null)? "° gup": "° Dan"}",
                                duration: "",
                                page: DetalleGradoHomePage(),
                                parametros: snapshot.data.folio
                              ),  
                  ],
                ) : Container(height: 0, width: 0,);
    }

    Widget _dojang(AsyncSnapshot<UserPerfilModel> snapshot) {

      return validar.isEmptyList(snapshot.data.escuelas)? 
      Column(
        children: [
              SizedBox(height: 20.0),
              utils.buildTitle("Dojang"),
              SizedBox(height: 5.0),

              ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.escuelas.length,
              itemBuilder: (context, i) {
              return snapshot.data.escuelas[i] != null
                ? 
                  _buildExperienceRow(
                      company: "${snapshot.data.escuelas[i].nombre}",
                      position: "${snapshot.data.escuelas[i].direccion}",
                      duration: "${snapshot.data.escuelas[i].comuna}",
                      page: DetalleEscuelaHomePage(),
                      parametros: snapshot.data.escuelas[i]
                    )
                : Container(
                    height: 0,
                    width: 0,
                  );
              },
            ),
        ],
      ) : Container(height: 0, width: 0,);  
    }

    Widget _apoderado(AsyncSnapshot<UserPerfilModel> snapshot) {
        return snapshot.data.apoderado != null ?
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    utils.buildTitle("Apoderado"),
                    SizedBox(height: 5.0),

                    _buildExperienceRow(
                                company: "${snapshot.data.apoderado?.nombres} ${snapshot.data.apoderado?.apellidoPaterno}",
                                position: "Folio: ${snapshot.data.apoderado?.folio}",
                                duration: "",
                                page: DetalleApoderadoHomePage(),
                                parametros: snapshot.data.apoderado
                              ),  
                  ],
                ) : Container(height: 0, width: 0,);
    }

   Widget _pupilos(AsyncSnapshot<UserPerfilModel> snapshot) {

      return validar.isEmptyList(snapshot.data.pupilos) ?
      
      Column(
        children: [
              SizedBox(height: 20.0),
              utils.buildTitle("Pupilos"),
              SizedBox(height: 5.0),

              ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.pupilos.length,
              itemBuilder: (context, i) {


              return snapshot.data?.pupilos[i] != null
                ? 
                  _buildExperienceRow(
                      company: "${snapshot.data?.pupilos[i]?.nombres} ${snapshot.data?.pupilos[i]?.apellidoPaterno}",
                      position: "",
                      duration: "${snapshot.data?.pupilos[i]?.escuela}",
                      page: DetallePupiloHomePage(),
                      parametros: snapshot.data?.pupilos[i]?? new Apoderado()
                    )
                : Container(
                    height: 0,
                    width: 0,
                  );
              },
            ),
        ],
       ) : Container(height: 0, width: 0,);  
    }

   Widget _footer(AsyncSnapshot<UserPerfilModel> snapshot) {

     return snapshot.data.email != null ?
      Column(
        children: [
          SizedBox(height: 20.0),
          utils.buildTitle("Contacto"),
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
                "${snapshot.data.email}",
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

              InkWell( child: Text("+${snapshot.data.fono}",style: TextStyle(fontSize: 16.0),),
                        onTap: () {                           
                          if (snapshot.data?.fono != null && snapshot.data.fono.isNotEmpty){
                            FlutterOpenWhatsapp.sendSingleMessage("+${snapshot.data?.fono}", "Hola");
                          }else {
                            showToast(context, 'Número invalido'); 
                          }
                        },
                      )
            ],
          ),
        ],
      ) : Container(height: 0, width: 0,);
    }

   Widget _contactoEmergencia(AsyncSnapshot<UserPerfilModel> snapshot) {
        return snapshot.data.informacionContacto != null ?
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    utils.buildTitle("Contacto de emergencia"),
                    SizedBox(height: 5.0),

                    _buildExperienceRow(
                                company: " ${snapshot.data.informacionContacto?.nombre} ${snapshot.data.informacionContacto?.apellidoPaterno}",
                                position: "+${snapshot.data.informacionContacto?.fono}",
                                duration: "",
                                page: DetalleContactoHomePage(),
                                parametros: snapshot.data.informacionContacto
                              ),  
                  ],
                ) : Container(height: 0, width: 0,);
    }

   Widget _membresia(AsyncSnapshot<UserPerfilModel> snapshot) {

    if (snapshot.data.usuarioMembresia != null) {

      DateTime pagoMembresiaMas12Meses  = snapshot?.data?.usuarioMembresia?.fechaPago?.add(Duration(days: 365));
      DateTime pagoMembresiaMas10Meses  = snapshot?.data?.usuarioMembresia?.fechaPago?.add(Duration(days: 305));
      DateTime hoy      = DateTime.now();
      String estado     = "Vencida";
      Color colorBG     = Colors.red[800];
      Color colorTXT    = Colors.white;
      IconData icono    = Icons.highlight_off;

      if(pagoMembresiaMas12Meses.compareTo(hoy) > 0){
        if(pagoMembresiaMas10Meses.compareTo(hoy) < 0){
          estado = "Pronto a vencer";
          colorBG = Colors.yellow[200];
          colorTXT = Colors.black87;
          icono = Icons.info_outline;
        }else{
          estado = "AL día";
          colorBG = Colors.grey.shade200;
          colorTXT = Colors.black54;
          icono    = Icons.check_circle_outline;
        }
      }

      return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(color: colorBG),
          child: Row(
            children: [
              /*3*/
              SizedBox.fromSize(              
                size: Size.fromRadius(25),
                child: FittedBox(                
                  child: Icon(icono, color: colorTXT,),
                ),
              ),
              Expanded(
                /*1*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Estado Membresia: $estado',
                        style: TextStyle(
                          color: colorTXT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Fecha ultimo pago: ${snapshot?.data?.usuarioMembresia?.fechaPagoTxt}',
                      style: TextStyle(
                        color: colorTXT,
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        );
    }else{
      
      return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade200),
          child: Row(
            children: [
              /*3*/
              SizedBox.fromSize(              
                size: Size.fromRadius(25),
                child: FittedBox(                
                  child: Icon(Icons.info_outline),
                ),
              ),
              Expanded(
                /*1*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Estado Membresia: Sin Informar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Fecha ultimo pago: ${(snapshot?.data?.usuarioMembresia?.fechaPagoTxt) ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        );
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.black87,
      ),
      drawer: MenuPrincipal(model: perfilBloc.userPerfilStream),
      body: SingleChildScrollView(

         child: StreamBuilder<UserPerfilModel>(
          stream: perfilBloc.userPerfilStream,
          builder: (BuildContext context, AsyncSnapshot<UserPerfilModel>snapshot) {

            if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     _crearImagen(snapshot),
                    SizedBox(height: 10.0,),
                    utils.buildHeader(context, snapshot, true),
                    utils.division(),
                    _membresia(snapshot),
                    _iconoEstrellas(snapshot),
                    utils.division(),
                    _dojang(snapshot),
                    _gradoActual(snapshot),
                    _apoderado(snapshot),
                    _pupilos(snapshot),
                    _contactoEmergencia(snapshot),
                    _footer(snapshot),
                    SizedBox(height: 50.0,),

                  ],
                );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Container(
              padding: EdgeInsets.symmetric(vertical: 200.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            );

          }
        )
      ),
   );
  }
}

