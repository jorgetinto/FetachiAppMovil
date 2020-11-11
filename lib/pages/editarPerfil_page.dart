import 'dart:async';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/validators/RutHelper_widget.dart';
import 'package:fetachiappmovil/helpers/validators/validaciones_varias.dart' as validar;
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/services/comunaRegion_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';


class EditarPerfilPage extends StatefulWidget {

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {

  File foto;
  UserPerfilBloc userPerfilBloc;
  UserPerfilModel usePerfilModel    = new UserPerfilModel();
  ComunaRegionServices comunaRegion = new ComunaRegionServices();
  Future<List<RegionModel>> region;
  Future<List<ComunaModel>> comuna;
  final formKey                     = GlobalKey<FormState>();
  final scaffoldKey                 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    userPerfilBloc = ProviderBloc.userPefilBloc(context);
    final UserPerfilModel userData = ModalRoute.of(context).settings.arguments;

    setState(() {
        if (userData != null) {
            usePerfilModel = userData;
        } 

        region = comunaRegion.getAllRegiones();
        comuna = comunaRegion.getAllComunaByIdRegion(usePerfilModel.idRegion);
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
                  utils.buildTitle("Información personal"),
                  SizedBox(height: 5.0),
                  _inputNombre(),
                  _inputApellidoPaterno(),
                  _inputApellidoMaterno(),
                  _inputRut(),
                  _inputFechaNacimiento(),
                  _inputstatusCard(),
                  _inputFono(),
                  _inputEmail(),
                  _inputDireccion(),
                  _dropdrownRegion(comunaRegion),       
                  _dropdrownComuna(comunaRegion, comuna),  
                  

                  SizedBox(height: 20.0),
                  utils.buildTitle("Contacto de emergencia"),
                  SizedBox(height: 5.0),
                   _inputNombreContactoEmergencia(),
                  _inputApellidoPaternoContactoEmergencia(),
                  _inputApellidoMaternoContactoEmergencia(),
                  _inputDireccionContactoEmergencia(),
                  _inputFonoContactoEmergencia(),
                  _inputEmailContactoEmergencia(),

                  _crearBoton(usePerfilModel),
                ],
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
      title: Text('Editar Perfil'),
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

  // INFORMACION USUARIO
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
        usePerfilModel.imagen = null;
      }  

      setState(() {});
  }

  Widget _mostrarFoto() {

      if (usePerfilModel.imagen != null) {

        return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: NetworkImage(usePerfilModel.imagen),
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
        initialValue: usePerfilModel.nombres,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Nombres',
          border: OutlineInputBorder(),                        
        ),
        onSaved: (value) => usePerfilModel.nombres = value,
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

  Widget _inputApellidoPaterno() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.apellidoPaterno,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Apellido Paterno',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.apellidoPaterno = value,
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

  Widget _inputApellidoMaterno() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.apellidoMaterno,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Apellido Materno',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.apellidoMaterno = value,
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

  Widget _inputRut() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.rut,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Rut',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.rut = value,
        validator: (value){

          RutHelper rutHelp = new RutHelper();

          if (value.isEmpty || value == null) {
            return 'Campo requerido';
          } else {

            if (rutHelp.check(value)){
              return null;
            } else {
              return 'Rut Invalido';
            }          
          }
        },
      ),
    );
  }

  Widget _inputFechaNacimiento() {

      DateTime selectedDate = DateTime.parse(usePerfilModel.fechaDeNacimiento);

      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: DateTimeField(
              
            mode: DateFieldPickerMode.date,
              dateFormat: DateFormat("dd/MM/yyyy"),            
              selectedDate: selectedDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  usePerfilModel.fechaDeNacimiento = date.toString();
              });
            }, 
              decoration: InputDecoration(
                labelText: 'Fecha de nacimiento',
                border: OutlineInputBorder()
              ),
              //label: 'Fecha de nacimiento',  
          lastDate: DateTime(2020),
        ),
      );
  }

  Widget _inputFono() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.fono,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Teléfono',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.fono = value,
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

  Widget _inputEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.email,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.email = value,
        validator: (value) => validar.isEmail(value) ? null : "Campo requerido",
      ),
    );
  }

  Widget _inputDireccion() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: usePerfilModel.direccion,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Dirección',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.direccion = value,
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

  Widget _inputstatusCard() {

     return ( usePerfilModel.idGradoActual != null && usePerfilModel.idGradoActual > 10) ?
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: (usePerfilModel.statusCard != null)? usePerfilModel.statusCard.toString(): "",
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Status Card',
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => usePerfilModel.statusCard = int.parse(value),
            validator: (value){
              if (value == null) {
                return 'Campo requerido';
              } else {
                return null;
              }
            },
          ),
        ): Container(height: 0, width: 0,);
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

              return DropdownButtonFormField<String>(
                value: usePerfilModel.idRegion,
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
                    usePerfilModel.idComuna = null;
                    usePerfilModel.idRegion = value;
                    comuna = comunaRegion.getAllComunaByIdRegion(value);                    
                  });
                },
              );
            }),
        ),
      );
  }

  Widget _dropdrownComuna(ComunaRegionServices comunaRegion, Future<List<ComunaModel>> comuna) {
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

              if (usePerfilModel.idComuna != null) {
                return DropdownButtonFormField<String>(
                  value: usePerfilModel.idComuna,
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
                      usePerfilModel.idComuna = value;                     
                    });
                  },
                );
              } else {
                 return DropdownButtonFormField<String>(
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
                      usePerfilModel.idComuna = value;                     
                    });
                  },
                );
              }              
            }),
        ),
      ): Container(height: 0, width: 0,);
  }

  // INFORMACION DE EMERGENCIA
  Widget _inputNombreContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.nombre : "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Nombres',
          border: OutlineInputBorder(),                        
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.nombre,
        validator: (value){
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputApellidoPaternoContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.apellidoPaterno : "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Apellido Paterno',
          border: OutlineInputBorder(),                        
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.apellidoPaterno,
        validator: (value){
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputApellidoMaternoContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.apellidoMaterno : "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Apellido Materno',
          border: OutlineInputBorder(),                        
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.apellidoMaterno,
        validator: (value){
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputDireccionContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.direccion: "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Direccion',
          border: OutlineInputBorder(),                        
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.direccion,
        validator: (value){
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputFonoContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.fono: "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Teléfono',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.fono = value,
        validator: (value){
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _inputEmailContactoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: (usePerfilModel.informacionContacto!= null)? usePerfilModel.informacionContacto.email: "",
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => usePerfilModel.informacionContacto.email = value,
        validator: (value) {
          if (value == null || value.trim() == "") {
            return 'Campo requerido';
          } else {
           return  validar.isEmail(value) ? null : "Campo requerido";
          }
        }
      ),
    );
  }

  Widget _crearBoton(UserPerfilModel user) {
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
          onPressed: () =>  _submit(user),
          ),
      ),
    );  
  }

  void _submit(UserPerfilModel user) async {
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
           usePerfilModel.imagen = await userPerfilBloc.subirFoto(foto, user.imagenOriginal);
        }   

        userPerfilBloc.editarPerfilUsuario(usePerfilModel);        

        Timer(Duration(milliseconds: 800), () {
            setState(() {
              Navigator.push(context, SlideRightRoute(widget: HomePage()));
            });
        });
     }
  }
}