
import 'dart:io';

import 'package:dart_rut_validator/dart_rut_validator.dart';
import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:fetachiappmovil/helpers/constants.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/helpers/validators/RutHelper_widget.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/escuelaPorIdInstructor_model.dart';
import 'package:fetachiappmovil/models/userForRegister_model.dart';
import 'package:fetachiappmovil/pages/Sabunim/SabunimPage.dart';
import 'package:fetachiappmovil/pages/Usuarios/escuelasAsociadas_page.dart';
import 'package:fetachiappmovil/pages/Usuarios/usuarios_page.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:fetachiappmovil/services/grado_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';


class UsuariosAddPage extends StatefulWidget {

  @override
  _UsuariosAddPageState createState() => _UsuariosAddPageState();
}

class _UsuariosAddPageState extends State<UsuariosAddPage> {

  File                      foto;
  GlobalKey<FormState>      formKey             = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey         = new GlobalKey<ScaffoldState>();
  FocusNode                 _node               = new FocusNode();
  UserForRegisterModel      userModel           = new UserForRegisterModel();
  UserPerfilBloc            userBloc            = new UserPerfilBloc();  
  UsuarioServices           usuarioProvider     = new UsuarioServices();
  EscuelaServices           escuelaProvider     = new EscuelaServices();
  GradoServices             gradoProvider       = new GradoServices();
  EscuelaPorIdInstructorModel escuelaInstructor = new EscuelaPorIdInstructorModel();
  UserForRegisterModel      userData            = new UserForRegisterModel();
  DateTime                  selectedDate        = new DateTime.now();
  bool                      _autoValidate       = false;

  Future<List<DropDownModel>>   selectTipoUsuario;
  Future<List<DropDownModel>>   selectGrado;
  Future<List<DropDownModel>>   selectApoderado;
  Future<List<DropDownModel>>   selectEscuela;
 
  TextEditingController _rutController = TextEditingController();
  
  bool _isVisible = true;
  bool _loading = true;
  bool _fechaValida = false;

  @override
  void initState() {
     new Future.delayed(new Duration(milliseconds: 1500), () {
        setState(() {
            _loading = false;         
        });
      }); 

     _rutController.clear();
     
     _node.addListener(() {
       setState(() {
        RUTValidator.formatFromTextController(_rutController);         
       });
    });
    super.initState();
  }

  @override
  void dispose() {
    userData          = null;
    userModel         = null; 
    selectApoderado   = null;
    _fechaValida      = true;
    _loading          = true;  
    _isVisible        = true;  
    selectedDate      = new DateTime.now();
    _node..dispose();
    super.dispose();
  }


  String validateUserName(String value) {
      Pattern pattern = r'^[a-zA-Z0-9\.]*$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Nombre de usuario Invalido';
      else
        return null;
  }
  
  @override
  Widget build(BuildContext context) {

    userData          = new UserForRegisterModel();
    userModel         = new UserForRegisterModel();        
    userData          = ModalRoute.of(context).settings.arguments;   
    userBloc          = ProviderBloc.userPefilBloc(context);        

    setState(() {
        
        selectTipoUsuario = usuarioProvider.getTipoUsuarioPorIdUsuario();
        selectEscuela     = escuelaProvider.getEscuelaPorIdUsuario();

        if (userData != null)
            userModel = userData;

        if (userModel.estado == null)
            userModel.estado = true;

        if(userModel.idEscuela != null && userModel.fechaDeNacimiento != null){
            if(int.parse(calculateAge(userModel.fechaDeNacimiento.toString())) >= 5 && int.parse(calculateAge(userModel.fechaDeNacimiento.toString())) <= 18)
              selectApoderado   = usuarioProvider.getApoderadosByIdEscuela(userModel.idEscuela);  
            else 
              selectApoderado = null;                 
        }

        if(userModel.role =="Estudiante" || userModel.role =="Instructor" || userModel.role =="Maestro"){
          Future.delayed(Duration.zero,(){
            selectGrado = gradoProvider.getAllGrados();
          });                         
        }                        

        if(userModel.role =="Admin"|| userModel.role =="Maestro"){
          _isVisible = false;
        }else {
          _isVisible = true;
        }

        _rutController.text = userModel.rut;
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
        userModel.imagen = null;
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
   
    Widget _mostrarFoto() {

      if (userModel.imagen != null && userModel.imagen != "") {

        return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: userModel.imagen != null ?NetworkImage("$IMAGEN_USUARIO${userModel.imagen}") : Image.asset('assets/no-image.png'),
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
          child: FutureBuilder<List<DropDownModel>>(
            future: selectTipoUsuario,
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
                       child: new IgnorePointer(
                        ignoring: false,
                        child: DropdownButtonFormField<String>(
                        value: userModel.role?.toString()?? null,
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

                            if(value =="Estudiante" || value =="Instructor" || value =="Maestro"){
                              Future.delayed(Duration.zero,(){
                               selectGrado = gradoProvider.getAllGrados();
                              });                         
                            }                         

                            if(value =="Admin" || value =="Instructor" || value =="Maestro"){
                              _isVisible = false;
                            }else {
                              _isVisible = true;
                            }

                          });
                        },
                        validator: (value){
                          if (value == null) {
                            return 'Campo requerido';
                          } else {
                            return null;
                          }
                        },
                    ),
                      ),
                  ),
                );

            }),
        ),
      );
    }

    Widget _dropdrownGrado(){

      return  (selectGrado != null)?
      Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<DropDownModel>>(
            future: selectGrado,
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
                      value: userModel.idGradoActual?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Grado',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((tipo) => DropdownMenuItem<String>(
                          child: Text(tipo.nombre),
                          value:  tipo.id.toString()               
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {   
                          userModel.idGradoActual = int.parse(value); 
                        });
                      },
                      validator: (value){
                        if (value == null) {
                          return 'Campo requerido';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                );

            }),
        ),
      ): Container(height: 0, width: 0,);
    }

    Widget _dropdrownEscuela() {
     return Visibility(
          visible: _isVisible,
          child:   Container(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0),
            child: FutureBuilder<List<DropDownModel>>(
              future: selectEscuela,
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
                        value: userModel.idEscuela?.toString()?? null,
                        decoration: InputDecoration(
                          labelText: 'Escuela',
                          border: OutlineInputBorder(),                                      
                        ),
                        isDense: true,
                        isExpanded: true,
                        items: snapshot.data.map((tipo) => DropdownMenuItem<String>(
                            child: Text(tipo.nombre),
                            value:  tipo.id.toString()               
                          )
                        ).toList(),
                        onChanged:(value) {
                          setState(() {   
                            userModel.idEscuela = int.parse(value);

                              if(userModel.fechaDeNacimiento != null){
                                if(int.parse(calculateAge(userModel.fechaDeNacimiento.toString())) <= 18){
                                    if(userModel.idEscuela != null)
                                      selectApoderado   = usuarioProvider.getApoderadosByIdEscuela(userModel.idEscuela);
                               }else{
                                  selectApoderado = null;
                                }
                              }       
                          });
                        },
                        validator: (value){
                          if (value == null) {
                            return 'Campo requerido';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  );

              }),
          ),
        ),
     );
    }

    Widget _inputUserName() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: userModel.userName,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Usuario",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => userModel.userName = value.trim(),
            validator: (value){
              if (value.isEmpty || value == null) {
                return 'Campo requerido';
              } else {

                String mensaje = validateUserName(value);
                if (mensaje != null && mensaje.isNotEmpty) {
                   return mensaje;
                }

                if(value.trim().toUpperCase().contains("Ñ")){
                  return "El nombre de usuario no puede contener la letra Ñ";
                }

                return null;
              }
            },
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
            onSaved: (value) => userModel.nombres = value.trim(),
            validator: (value){
              if (value.isEmpty || value == null) {
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
          onSaved: (value) => userModel.apellidoPaterno = value.trim(),
          validator: (value){
           if (value.isEmpty || value == null) {
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
          onSaved: (value) => userModel.apellidoMaterno = value.trim(),
          validator: (value){
            if (value.isEmpty || value == null) {
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
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Rut',
          border: OutlineInputBorder(),
        ),
       controller:_rutController,	    
        onEditingComplete: () =>  RUTValidator.formatFromTextController(_rutController),
        onSaved: (value) => userModel.rut = value,       
        validator: (value){

          RutHelper rutHelp = new RutHelper();

          if (value.isEmpty || value == null) {
            return 'Campo requerido';
          } else {

            if(value.length < 9){
              return 'Los rut menores de 10 millones deben agregar un 0 al inicio';
            }else{
              if (rutHelp.check(value)){
                return null;
              } else {
                return 'Rut Invalido';
              }  
            }                    
          }
        },
      ),
    );
  }

    Widget _inputFechaNacimiento() {

      selectedDate = (userModel.fechaDeNacimiento != null)
                                ? DateTime.parse(userModel.fechaDeNacimiento.toString()) 
                                : new DateTime.now() ;

      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Focus(
                focusNode: _node,
                onFocusChange: (bool focus) {
                  setState((){});
                },
                child:  DateTimeField(
                      mode: DateFieldPickerMode.date,
                        dateFormat: DateFormat("dd/MM/yyyy"),            
                        selectedDate: selectedDate,
                        onDateSelected: (DateTime date) {
                          setState(() {

                            userModel.fechaDeNacimiento = date.toString();
                            selectApoderado = null;
                            _fechaValida = true;

                            if(int.parse(calculateAge(date.toString())) >= 5){
                              if(int.parse(calculateAge(date.toString())) <= 18){
                                  selectApoderado   = usuarioProvider.getApoderadosByIdEscuela(userModel.idEscuela);
                              }else{
                                selectApoderado = null;
                              }
                              _fechaValida = true;
                            }
                            
                        });
                      }, 
                        decoration: InputDecoration(
                          labelText: 'Fecha de nacimiento',
                          border: OutlineInputBorder()
                        ), 
                    lastDate: DateTime(2101),
                    
                    
                ),
        )
      );
  }

    Widget _dropdrownApoderado(){

      return  (selectApoderado != null)?
      Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<DropDownModel>>(
            future: selectApoderado,
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
                      value: userModel.idApoderado?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Apoderado',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((tipo) => DropdownMenuItem<String>(
                          child: Text(tipo.nombre),
                          value:  tipo.id.toString()               
                        )
                      ).toList(),
                      onChanged:(value) {
                        setState(() {   
                          userModel.idApoderado = int.parse(value); 
                        });
                      },
                       validator: (value){
                        if (value == null) {
                          return 'Campo requerido';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                );

            }),
        ),
      ): Container(height: 0, width: 0,);
    }

    Widget _switchEstado(){
       return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Switch(
                  activeColor: Colors.pinkAccent,
                  value:  userModel.estado,
                  onChanged: (value) {
                    setState(() {
                      userModel.estado = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                 Text('Estado : ${ (userModel.estado == null)? 'Activo':  (userModel.estado)? 'Activo': 'Inactivo'}', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                ),)
              ],
            );
    }

    void _submit() async {

      if (!formKey.currentState.validate()) {
         setState(() {
          _autoValidate = true;
          return;
        });
      }else { 

          if (!_fechaValida && int.parse(calculateAge(userModel.fechaDeNacimiento.toString())) <= 5) {
            return  showToast(context,'Campo de fecha de nacimiento invalida!');       
          }

          formKey.currentState.save();

          if (foto != null) {
            userModel.imagen = await userBloc.upload(foto, true, userModel.id);
          }
          
          showAlertDialog(context);

          if(userModel != null) {

            if (userModel.id == null || userModel.id == 0){
                
                userModel.id = 0;
                
                Map info = await usuarioProvider.crearUsuario(userModel);

                  if (info['ok']) {
                    showToast(context,'Usuario creado de forma exitosa!');                   

                    if (userModel.role == "Admin")
                    {
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EscuelasAsociadas()),
                        );
                   } 
                   else if (userModel.role =="Maestro"){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SabunimPage()),
                        );
                   }else {
                        escuelaInstructor.idEscuela = userModel.idEscuela;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsuariosPage(),
                            settings: RouteSettings(
                              arguments: escuelaInstructor,
                            ),
                          ),
                        );  
                    }

                  } else {
                    showToast(context,info['message']);
                  }
            }else {
              Map infoUP = await usuarioProvider.updateUsuario(userModel);
              if (infoUP['ok']) {
                showToast(context, (userModel?.id == null) ? 'Usuario creado de forma exitosa!': 'Usuario actualizado de forma exitosa!');
                
                  if (userModel.role == "Admin" || userModel.role =="Instructor" )
                    {
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EscuelasAsociadas()),
                        );
                   } 
                   else if (userModel.role =="Maestro"){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SabunimPage()),
                        );
                   }else {
                        escuelaInstructor.idEscuela = userModel.idEscuela;
                        Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UsuariosPage(),
                                  settings: RouteSettings(
                                    arguments: escuelaInstructor,
                                  ),
                                ),
                              );  
                    }     
                
              } else {
                showToast(context, infoUP['message']);
              }
            }
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
            label: (userModel?.id == null) ? Text('Guardar'): Text('Actualizar'),
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
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  Center(
                    child: _mostrarFoto()                    
                  ),
                  SizedBox(height: 20.0),
                  buildTitle("Información Usuario"),
                  SizedBox(height: 5.0),
                  _dropdrownTipoUsuario(),
                  _dropdrownEscuela(),
                  _inputUserName(),
                  _inputRut(),
                  _inputNombre(), 
                  _inputApellidoPaterno(),
                  _inputApellidoMaterno(),
                  _inputFechaNacimiento(),
                  _dropdrownGrado(),
                  _dropdrownApoderado(),
                  _switchEstado(),                 
                  _crearBoton()
                ]
              )
            ),
        ):

        // By default, show a loading spinner.
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