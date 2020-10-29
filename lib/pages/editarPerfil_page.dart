import 'dart:async';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/models/userPerfil_model.dart';
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
  UserPerfilModel usePerfilModel = new UserPerfilModel();
  final formKey                     = GlobalKey<FormState>();
  final scaffoldKey                 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    userPerfilBloc = ProviderBloc.userPefilBloc(context);
    final UserPerfilModel userData = ModalRoute.of(context).settings.arguments;

    if (userData != null) {
        usePerfilModel = userData;
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
                  _inputNombre(),
                  _inputFechaNacimiento(),
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
    return TextFormField(
      initialValue: usePerfilModel.nombres,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombres'
      ),
      onSaved: (value) => usePerfilModel.nombres = value,
      validator: (value){
        if (value == null) {
          return 'Campo requerido';
        } else {
          return null;
        }
      },
    );
  }

  Widget _inputFechaNacimiento() {

      DateTime selectedDate = DateTime.parse(usePerfilModel.fechaDeNacimiento);

      return DateTimeField(
            label: 'Fecha de nacimiento',  
            mode: DateFieldPickerMode.date,
            dateFormat: DateFormat("dd/MM/yyyy"),            
            selectedDate: selectedDate,
            onDateSelected: (DateTime date) {
              setState(() {
                usePerfilModel.fechaDeNacimiento = date.toString();
            });
          },
        lastDate: DateTime(2020),
      );
  }

  Widget _crearBoton(UserPerfilModel user) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.orangeAccent,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: () =>  _submit(user),
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