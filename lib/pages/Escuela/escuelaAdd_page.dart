import 'dart:io';

import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/helpers/constants.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:fetachiappmovil/models/zona_model.dart';
import 'package:fetachiappmovil/pages/Escuela/escuela_page.dart';
import 'package:fetachiappmovil/services/comunaRegion_service.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/services/userPerfil_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:fetachiappmovil/services/zona_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class EscuelaAddPage extends StatefulWidget {

  @override
  _EscuelaAddPageState createState() => _EscuelaAddPageState();
}

class _EscuelaAddPageState extends State<EscuelaAddPage> {

    GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
    GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();

    File                      foto;
    EscuelaServices           escuelaProvider  = new EscuelaServices();
    UserPerfilServices        userService      = new UserPerfilServices();
    EscuelaModel              escuelaModel     = new EscuelaModel();
    ComunaRegionServices      comunaRegion     = new ComunaRegionServices();
    ZonaServices              zona             = new ZonaServices();
    UsuarioServices           usuario          = new UsuarioServices();
    FocusNode                 _node            = new FocusNode();

    Future<List<RegionModel>>     region;
    Future<List<ComunaModel>>     comuna;
    Future<List<ZonaModel>>       zonas;
    Future<List<DropDownModel>>   instructores;
    Future<List<DropDownModel>>   maestros;

    EscuelaModel userData;
    EscuelaBloc  escuelaBloc;  

    bool _loading = true;

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
  void dispose() {
    userData      = new EscuelaModel();
    escuelaModel  = new EscuelaModel(); 
    _loading      = true;  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      userData      = new EscuelaModel();
      escuelaModel  = new EscuelaModel();
      userData      = ModalRoute.of(context).settings.arguments;
      escuelaBloc   = ProviderBloc.escuelaBloc(context);
      region        = comunaRegion.getAllRegiones();
      zonas         = zona.getAllZonases();
      instructores  = usuario.getUsuariosInstructores();
      maestros      = usuario.getUsuariosMaestros();     

      if (userData != null) {
        escuelaModel = userData;
      }     
    });

    /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 600,
      maxHeight: 600,
      aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar',
            toolbarColor: Colors.black87,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Recortar',
        )
    );

    if (croppedImage != null) {
      foto = croppedImage;

      if (foto != null) {
        escuelaModel.logo = null;
      }

      setState(() {});
    }
  }

   _procesarImagen(ImageSource origin) async {
       PickedFile pickedFile = await ImagePicker().getImage(
        source: origin,
        maxWidth: 1080,
        maxHeight: 1080,
      );

     await _cropImage(pickedFile.path);     
    }

    _seleccionarFoto() async {
      _procesarImagen(ImageSource.gallery);
    }

    _tomarFoto() async {
      _procesarImagen(ImageSource.camera);
    }

    _showMaterialDialog() {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Atención"),
                content: new Text("Si desactiva esta escuela, también desactivara a los usuarios asociados a esta escuela."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
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

  Widget _mostrarFoto() {

      if (escuelaModel?.logo != null && escuelaModel?.logo != "") {

        return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: escuelaModel?.logo != null ?NetworkImage("$IMAGEN_ESCUELA${escuelaModel?.logo}") : Image.asset('assets/no-image.png'),
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

  Widget _inputUserName() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: escuelaModel.nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Nombre",
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
          child: FutureBuilder<List<DropDownModel>>(
            future: instructores,
            builder: (BuildContext context,  AsyncSnapshot<List<DropDownModel>> snapshot) {

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
          child: FutureBuilder<List<DropDownModel>>(
            future: maestros,
            builder: (BuildContext context,  AsyncSnapshot<List<DropDownModel>> snapshot) {

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

  Widget _switchEstado(){
       return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Switch(
                  activeColor: Colors.pinkAccent,
                  value:  (escuelaModel.estado == null)? true:  (escuelaModel.estado)?true: false,
                  onChanged: (value) {
                    setState(() {
                      
                      if (!value)
                        _showMaterialDialog();
                        escuelaModel.estado = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                Text('Estado : ${ (escuelaModel.estado == null)? true:  (escuelaModel.estado)? 'Activo': 'Inactivo'}', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                ),)
              ],
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
           // escuelaModel.logo = await escuelaBloc.subirFoto(foto, escuelaModel.logoOriginal);
            await userService.upload(foto, false, escuelaModel.idEscuela ).then((value) => {
              if (value != null) escuelaModel.logo = value 
            });
          }

          if(escuelaModel != null) { 
            if (escuelaModel.idEscuela == null){
              escuelaModel.idEscuela = 0;
              escuelaProvider.createEscuela(escuelaModel);           
            }else {
              escuelaProvider.updateEscuela(escuelaModel);
            }
            await Future.delayed(const Duration(milliseconds: 700));
            Navigator.push(context, SlideRightRoute(widget: EscuelaPage()));
          }
      }
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

   return Scaffold(
     key: scaffoldKey,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: (!_loading) ? 
          
          Padding(padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: _mostrarFoto()                    
                  ),
                  SizedBox(height: 20.0),
                  buildTitle("Información Dojang"),
                  SizedBox(height: 5.0),
                  _inputUserName(),
                  _inputDireccion(),
                  _dropdrownRegion(comunaRegion),       
                  _dropdrownComuna(comunaRegion, comuna),  
                   _dropdrownZonas(),
                  _dropdrownInstructor(),
                  _dropdrownMaestro(),
                  _switchEstado(),
                  _crearBoton()
                ]
              )
            )
          ): // By default, show a loading spinner.
          Container(
            padding: EdgeInsets.symmetric(vertical: 200.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),

      )
    ),
   );
  }
}