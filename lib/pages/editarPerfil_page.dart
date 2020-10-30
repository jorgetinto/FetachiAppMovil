import 'dart:async';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/validators/RutHelper_widget.dart';
import 'package:fetachiappmovil/helpers/validators/validaciones_varias.dart' as validar;
import 'package:fetachiappmovil/helpers/utils.dart' as utils;
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

  // List<utils.ListItem> _dropdownItems = [
  //   utils.ListItem(1, "First Value"),
  //   utils.ListItem(2, "Second Item"),
  //   utils.ListItem(3, "Third Item"),
  //   utils.ListItem(4, "Fourth Item")
  // ];

  // List<DropdownMenuItem<utils.ListItem>> _dropdownMenuItems;
  // utils.ListItem _selectedItem;

  // void initState() {
  //   super.initState();
  //   _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
  //   _selectedItem = _dropdownMenuItems[0].value;

  // }

  // List<DropdownMenuItem<utils.ListItem>> buildDropDownMenuItems(List listItems) {
  //   List<DropdownMenuItem<utils.ListItem>> items = List();
  //   for (utils.ListItem listItem in listItems) {
  //     items.add(
  //       DropdownMenuItem(
  //         child: Text(listItem.name),
  //         value: listItem,
  //       ),
  //     );
  //   }
  //   return items;
  // }


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

                  SizedBox(height: 20.0),
                  utils.buildTitle("Información personal"),
                  SizedBox(height: 5.0),
                  _inputNombre(),
                  _inputApellidoPaterno(),
                  _inputApellidoMaterno(),
                  _inputRut(),
                  _inputFechaNacimiento(),
                  _inputFono(),
                  _inputEmail(),

                  // Container(
                  //     padding: EdgeInsets.all(20.0),
                  //     child: DropdownButton<utils.ListItem>(
                  //         value: _selectedItem,
                  //         items: _dropdownMenuItems,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _selectedItem = value;
                  //           });
                  //         })),


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