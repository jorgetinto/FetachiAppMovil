import 'dart:io';

import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:fetachiappmovil/helpers/validators/RutHelper_widget.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/instructorMaestro_model.dart';
import 'package:fetachiappmovil/models/user_model.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class UsuariosAddPage extends StatefulWidget {

  @override
  _UsuariosAddPageState createState() => _UsuariosAddPageState();
}

  File                      foto;
  UserPerfilBloc            userBloc;  
  UsuarioServices           usuarioProvider  = new UsuarioServices();
  EscuelaServices           escuelaProvider  = new EscuelaServices();
  User                      userModel        = new User();
  GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();
  FocusNode                 _node            = new FocusNode();
  Future<List<InstructorMaestroModel>>   selectTipoUsuario;
  Future<List<EscuelaPorIdInstructorModel>>   selectEscuela;

class _UsuariosAddPageState extends State<UsuariosAddPage> {


  @override
  Widget build(BuildContext context) {

    userBloc = ProviderBloc.userPefilBloc(context);

      setState(() {
          selectTipoUsuario = usuarioProvider.getTipoUsuarioPorIdUsuario();
          selectEscuela     = escuelaProvider.getEscuelaPorIdUsuario();
      });
    
    _procesarImagen(ImageSource origin) async {
      final _picker                   = ImagePicker();
      PickedFile pickedFile           = await _picker.getImage(source: origin);      
      foto                            = File(pickedFile.path);  

      if (foto != null) {
        userModel.imagen= null;
      }  

      setState(() {});
    }

    _seleccionarFoto() async {
      _procesarImagen(ImageSource.gallery);
    }

    _tomarFoto() async {
      _procesarImagen(ImageSource.camera);
    }

  Widget _mostrarFoto() {

      if (userModel.imagen != null && userModel.imagen != "") {

        return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: userModel.imagen != null ?NetworkImage(userModel.imagen) : Image.asset('assets/no-image.png'),
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

    AppBar _appBar(BuildContext context) {
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Crear Usuario'),
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

    Widget _dropdrownTipoUsuario() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<InstructorMaestroModel>>(
            future: selectTipoUsuario,
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
                      //value: escuelaModel.idZona?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Usuario',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((tipo) => DropdownMenuItem<String>(
                          child: Text(tipo.nombre),
                          value:  tipo.nombre               
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {   
                          userModel.role = value;        
                        });
                      },
                    ),
                  ),
                );

            }),
        ),
      );
    }

    Widget _dropdrownEscuela() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<EscuelaPorIdInstructorModel>>(
            future: selectEscuela,
            builder: (BuildContext context,  AsyncSnapshot<List<EscuelaPorIdInstructorModel>> snapshot) {

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
                      //value: escuelaModel.idZona?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Escuela',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((tipo) => DropdownMenuItem<String>(
                          child: Text(tipo.nombre),
                          value:  tipo.nombre               
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {   
                          userModel.role = value;        
                        });
                      },
                    ),
                  ),
                );

            }),
        ),
      );
    }

    Widget _inputNombre() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: userModel.nombres,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nombres',
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => userModel.nombres = value,
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
          initialValue: userModel.apellidoPaterno,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Apellido Paterno',
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => userModel.apellidoPaterno = value,
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
          initialValue: userModel.apellidoMaterno,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Apellido Materno',
            border: OutlineInputBorder(),
          ),
          onSaved: (value) => userModel.apellidoMaterno = value,
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
        initialValue: userModel.rut,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Rut',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => userModel.rut = value,
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
                  utils.buildTitle("Información Usuario"),
                  SizedBox(height: 5.0),
                  _dropdrownTipoUsuario(),
                  _dropdrownEscuela(),
                  _inputNombre(), 
                  _inputApellidoPaterno(),
                  _inputApellidoMaterno(),
                  _inputRut()
                ]
              )
            ),
        ),

      )
    ),
   );
  }
}