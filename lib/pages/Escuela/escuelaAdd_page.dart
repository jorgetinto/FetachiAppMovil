import 'dart:async';
import 'dart:io';

import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/models/instructorMaestro_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:fetachiappmovil/models/zona_model.dart';
import 'package:fetachiappmovil/services/comunaRegion_service.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:fetachiappmovil/services/zona_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;

import '../home_page.dart';
import 'escuela_page.dart';


class EscuelaAddPage extends StatefulWidget {

  @override
  _EscuelaAddPageState createState() => _EscuelaAddPageState();
}

class _EscuelaAddPageState extends State<EscuelaAddPage> {

  File                      foto;
  EscuelaBloc               escuelaBloc;  
  GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();
  EscuelaServices           escuelaProvider  = new EscuelaServices();
  EscuelaModel              escuelaModel     = new EscuelaModel();
  ComunaRegionServices      comunaRegion     = new ComunaRegionServices();
  ZonaServices              zona             = new ZonaServices();
  UsuarioServices           usuario          = new UsuarioServices();
  FocusNode                 _node            = new FocusNode();

  Future<List<RegionModel>> region;
  Future<List<ComunaModel>> comuna;
  Future<List<ZonaModel>>   zonas;
  Future<List<InstructorMaestroModel>>   instructores;
  Future<List<InstructorMaestroModel>>   maestros;

  @override
  Widget build(BuildContext context) {

    final EscuelaModel userData = ModalRoute.of(context).settings.arguments;
    escuelaBloc = ProviderBloc.escuelaBloc(context);

    setState(() {
        region        = comunaRegion.getAllRegiones();
        zonas         = zona.getAllZonases();
        instructores  = usuario.getUsuariosInstructores();
        maestros      = usuario.getUsuariosMaestros();

        if (userData != null) {
            escuelaModel = userData;
        }
    });

    return Scaffold(
     key: scaffoldKey,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: _mostrarFoto()                    
                  ),
                  SizedBox(height: 20.0),
                  utils.buildTitle("Información Dojang"),
                  SizedBox(height: 5.0),
                  _inputNombre(),
                  _inputDireccion(),
                  _dropdrownRegion(comunaRegion),       
                  _dropdrownComuna(comunaRegion, comuna),  
                   _dropdrownZonas(),
                  _dropdrownInstructor(),
                  _dropdrownMaestro(),
                  _crearBoton()
                ]
              )
            ),
        ),

      )
    ),
   );
  }
  
  AppBar _appBar(BuildContext context) {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Crear Dojang'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto
          )
        ],
      );
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origin) async {
    final _picker                   = ImagePicker();
    PickedFile pickedFile           = await _picker.getImage(source: origin);      
    foto                            = File(pickedFile.path);  

    if (foto != null) {
      escuelaModel.logo = null;
    }  

    setState(() {});
  }

  Widget _mostrarFoto() {

      if (escuelaModel.logo != null && escuelaModel.logo != "") {

        return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: escuelaModel.logo != null ?NetworkImage(escuelaModel.logo) : Image.asset('assets/no-image.png'),
          height: 300.0,
          fit: BoxFit.contain,
          );

      } else {

          if( foto != null ){
            return Image.file(
              foto,
              fit: BoxFit.cover,
              height: 300.0,
            );
        }
        
        return Image.asset('assets/no-image.png'); 
      }
  }

  Widget _inputNombre() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: escuelaModel.nombre,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Nombre',
          border: OutlineInputBorder(),
                        
        ),
        onSaved: (value) => escuelaModel.nombre = value,
        validator: (value){
          if (value == null) {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputDireccion() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: escuelaModel.direccion,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Dirección',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => escuelaModel.direccion = value,
        validator: (value){
          if (value == null) {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _dropdrownRegion(ComunaRegionServices comunaRegion) {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<RegionModel>>(
            future: region,

            builder: (BuildContext context,  AsyncSnapshot<List<RegionModel>> snapshot) {

              if (!snapshot.hasData)
                return CircularProgressIndicator();

                  return Focus(
                        focusNode: _node,
                        onFocusChange: (bool focus) {
                          setState((){});
                        },
                          child: Listener(
                              onPointerDown: (_) {
                                FocusScope.of(context).requestFocus(_node);
                              },
                                child: DropdownButtonFormField<String>(
                                value: escuelaModel.idRegion?? null,
                                decoration: InputDecoration(
                                  labelText: 'Region',
                                  border: OutlineInputBorder(),                                      
                                ),
                                isDense: true,
                                isExpanded: true,
                                items: snapshot.data.map((countyState) => DropdownMenuItem<String>(
                                    child: Text(countyState.nombre),
                                    value: countyState.codRegion,                          
                                  )
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    escuelaModel.idComuna = null;
                                    comuna = comunaRegion.getAllComunaByIdRegion(value);                    
                                  });
                                },
                            ),
                    ),
                );
              
            }),
        ),
      );
  }

  Widget _dropdrownComuna(ComunaRegionServices comunaRegion, Future<List<ComunaModel>> comuna) {

      if (escuelaModel.idRegion != null){
         comuna = comunaRegion.getAllComunaByIdRegion(escuelaModel.idRegion);   
      }

     return 
     (comuna != null)?

     Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<ComunaModel>>(
            future: comuna,

            builder: (BuildContext context,  AsyncSnapshot<List<ComunaModel>> snapshot) {

              if (!snapshot.hasData)
                return CircularProgressIndicator();

              if (escuelaModel.idComuna != null) {
                return Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState((){});
                          },
                          child: Listener(
                          onPointerDown: (_) {
                            FocusScope.of(context).requestFocus(_node);
                          },
                          child: DropdownButtonFormField<String>(
                          value: escuelaModel.idComuna,
                          decoration: InputDecoration(
                            labelText: 'Comuna',
                            border: OutlineInputBorder(),                                      
                          ),
                          isDense: true,
                          isExpanded: true,
                          items: snapshot.data.map((countyState) => DropdownMenuItem<String>(
                              child: Text(countyState.nombre),
                              value: countyState.codComuna,                                  
                            )
                          ).toList(),
                          onChanged:(value) {
                            setState(() {
                              escuelaModel.idComuna = value;                     
                            });
                          },
                        ),
                    ),
                );
              } else {
                 return Focus(
                            focusNode: _node,
                            onFocusChange: (bool focus) {
                              setState((){});
                            },
                              child: Listener(
                              onPointerDown: (_) {
                                FocusScope.of(context).requestFocus(_node);
                              },
                            child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Comuna',
                              border: OutlineInputBorder(),                                      
                            ),
                            isDense: true,
                            isExpanded: true,
                            items: snapshot.data.map((countyState) => DropdownMenuItem<String>(
                                child: Text(countyState.nombre),
                                value: countyState.codComuna,                                  
                              )
                            ).toList(),
                            onChanged:(value) {
                              setState(() {
                                escuelaModel.idComuna = value;                     
                              });
                            },
                          ),
                        ),
                 );
              }              
            }),
        ),
      ): Container(height: 0, width: 0,);
  }

  Widget _dropdrownZonas() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<ZonaModel>>(
            future: zonas,
            builder: (BuildContext context,  AsyncSnapshot<List<ZonaModel>> snapshot) {

              if (!snapshot.hasData)
                return CircularProgressIndicator();

                  return Focus(
                        focusNode: _node,
                        onFocusChange: (bool focus) {
                          setState((){});
                        },
                      child: Listener(
                      onPointerDown: (_) {
                        FocusScope.of(context).requestFocus(_node);
                      },
                      child: DropdownButtonFormField<String>(
                      value: escuelaModel.idZona?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Zona',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((countyState) => DropdownMenuItem<String>(
                          child: Text(countyState.nombre),
                          value: countyState.idZona.toString(),                          
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {
                            escuelaModel.idZona = int.parse(value);             
                        });
                      },
                    ),
                  ),
                );

            }),
        ),
      );
  }

  Widget _dropdrownInstructor() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<InstructorMaestroModel>>(
            future: instructores,
            builder: (BuildContext context,  AsyncSnapshot<List<InstructorMaestroModel>> snapshot) {

              if (!snapshot.hasData)
                return CircularProgressIndicator();
              
                  return Focus(
                          focusNode: _node,
                          onFocusChange: (bool focus) {
                            setState((){});
                          },
                        child: Listener(
                          onPointerDown: (_) {
                            FocusScope.of(context).requestFocus(_node);
                          },
                        child: DropdownButtonFormField<String>(
                        value: escuelaModel.idInstructor?.toString()?? null,
                        decoration: InputDecoration(
                          labelText: 'Instructor',
                          border: OutlineInputBorder(),                                      
                        ),
                        isDense: true,
                        isExpanded: true,
                        items: snapshot.data.map((instructores) => DropdownMenuItem<String>(
                            child: Text(instructores.nombre),
                            value: instructores.id.toString(),                          
                          )
                        ).toList(),
                        onChanged:(value) {
                          setState(() {
                              escuelaModel.idInstructor = int.parse(value);             
                          });
                        },
                      ),
                    ),
                  );              
            }),
        ),
      );
  }

  Widget _dropdrownMaestro() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<InstructorMaestroModel>>(
            future: maestros,
            builder: (BuildContext context,  AsyncSnapshot<List<InstructorMaestroModel>> snapshot) {

              if (!snapshot.hasData)
                return CircularProgressIndicator();
              
                  return Focus(
                        focusNode: _node,
                        onFocusChange: (bool focus) {
                          setState((){});
                        },
                      child: Listener(
                          onPointerDown: (_) {
                            FocusScope.of(context).requestFocus(_node);
                          },
                      child: DropdownButtonFormField<String>(
                        value: escuelaModel.idMaestro?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Maestro',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((maestro) => DropdownMenuItem<String>(
                          child: Text(maestro.nombre),
                          value: maestro.id.toString(),                          
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {
                            escuelaModel.idMaestro = int.parse(value);             
                        });
                      },
                    ),
                  ),
                );                      
            }),
        ),
      );
  }

  Widget _crearBoton() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 40.0,
          child: RaisedButton.icon(
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          color: Colors.redAccent,
          textColor: Colors.white,
          label: Text('Guardar'),
          icon: Icon(Icons.save),
          onPressed: () =>  _submit(),
          ),
      ),
    );  
  }

void _submit() async {
     if (!formKey.currentState.validate()) {
       return;
     }else {
        scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 40), content:
            new Row(
              children: <Widget>[
                new CircularProgressIndicator(),
                new Text("    Guardando cambios...")
              ],
            ),
          )
        );

        formKey.currentState.save();

        if (foto != null) {
           escuelaModel.logo = await escuelaBloc.subirFoto(foto, escuelaModel.logoOriginal);
        }   


        if(escuelaModel != null) {
          
          escuelaModel.estado = true;

          if (escuelaModel.idEscuela == null){
            escuelaModel.idEscuela = 0;
            escuelaBloc.createEscuela(escuelaModel);
          }else {
            escuelaProvider.updateEscuela(escuelaModel);
             Navigator.push(context, SlideRightRoute(widget: EscuelaPage()));
          }

          Timer(Duration(milliseconds: 800), () {
              setState(() {
                Navigator.push(context, SlideRightRoute(widget: HomePage()));
              });
          });
        }
     }
  }
}