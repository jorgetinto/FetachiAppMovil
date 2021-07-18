import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/UsuarioMembresia_model.dart';
import 'package:fetachiappmovil/models/membresia_model.dart';
import 'package:fetachiappmovil/pages/UsuarioMembresia/UsuarioMembresia_page.dart';
import 'package:fetachiappmovil/services/membresia_service.dart';
import 'package:fetachiappmovil/services/usuarioMembresia_service.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class UsuarioMembresiaAddPage extends StatefulWidget {

  @override
  _UsuarioMembresiaAddPageState createState() => _UsuarioMembresiaAddPageState();
}

class _UsuarioMembresiaAddPageState extends State<UsuarioMembresiaAddPage> {

  GlobalKey<FormState>      formKey                     = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey                 = new GlobalKey<ScaffoldState>();
  FocusNode                 _node                       = new FocusNode();

  UsuarioMembresiaModel membresiaModel                  = new UsuarioMembresiaModel();
  MembresiaServices membresiaProvider                   = new MembresiaServices();
  UsuarioMembresiaServices usuarioMembresiaProvider     = new UsuarioMembresiaServices();

  bool                  _autoValidate                   = false;
  DateTime                  selectedDate                = new DateTime.now();
  UsuarioMembresiaModel membresiaData;
  bool _loading = true;

  Future<List<MembresiaModel>>  membresia;

  @override
  void initState() {
      new Future.delayed(new Duration(milliseconds: 1500), () {
          setState(() {
              _loading = false;         
          });
        });    
      super.initState();
  }
  
  @override
  void dispose() {
    membresiaData    = new UsuarioMembresiaModel();
    membresiaModel   = new UsuarioMembresiaModel(); 
    _loading      = true;  
    super.dispose();
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => 
        Navigator.push (
            context,
            MaterialPageRoute(builder: (context) => UsuarioMembresiaPage()),
        ),
      ),
      title: Text('Crear Membresia'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      membresiaModel  = new UsuarioMembresiaModel();
      membresia       = membresiaProvider.getAllMembresia();
      membresiaData   = ModalRoute.of(context).settings.arguments;

      if (membresiaData != null) {
        membresiaModel = membresiaData;
      }     
    });

    _showMaterialDialog() {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Atención"),
              content: new Text("¿Esta seguro que desea desactivar esta membresia?"),
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

    Widget _inputName() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            enabled: false, 
            initialValue: membresiaModel.nombreUsuario,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Usuario",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => membresiaModel.nombreUsuario = value,
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

    Widget _inputNameEscuela() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            enabled: false, 
            initialValue: membresiaModel.nombreEscuela,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Escuela",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => membresiaModel.nombreEscuela = value,
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

    Widget _dropdrownMembresia() {
     return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder<List<MembresiaModel>>(
            future: membresia,
            builder: (BuildContext context,  AsyncSnapshot<List<MembresiaModel>> snapshot) {

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
                      value: membresiaModel.idMembresia?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'TIpo Membresia',
                        border: OutlineInputBorder(),                                      
                      ),
                      isDense: true,
                      isExpanded: true,
                      items: snapshot.data.map((membresia) => DropdownMenuItem<String>(
                          child: Text(membresia.nombre + " - Monto: " + membresia.monto.toString()),
                          value: membresia.id.toString(),                          
                        )
                      ).toList(),
                      validator: (value) => value == null ? 'Campo requerido' : null,
                      onChanged:(value) {
                        setState(() {
                           membresiaModel.idMembresia = int.parse(value);             
                        });
                      },
                    ),
                  ),
                );

            }),
        ),
      );
   }

    Widget _inputFechaNacimiento() {

      selectedDate = (membresiaModel.fechaPago != null)
                                ? DateTime.parse(membresiaModel.fechaPago.toString()) 
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

                            membresiaModel.fechaPago = date;
                            
                        });
                      }, 
                        decoration: InputDecoration(
                          labelText: 'Fecha de pago',
                          border: OutlineInputBorder()
                        ), 
                    lastDate: DateTime(2101),
                ),
        )
      );
  }

    Widget _switchEstado(){
       return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Switch(
                  activeColor: Colors.pinkAccent,
                  value:  (membresiaModel.estado == null)? true:  (membresiaModel.estado)?true: false,
                  onChanged: (value) {
                    setState(() {                      
                      if (!value)
                        _showMaterialDialog();
                        membresiaModel.estado = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                Text('Estado : ${ (membresiaModel.estado == null)? 'Activo':  (membresiaModel.estado)? 'Activo': 'Inactivo'}', style: TextStyle(
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

          if(membresiaModel != null) { 

            if(membresiaModel.estado == null)
                membresiaModel.estado = true;    

            if(membresiaModel.fechaPago == null)   
              membresiaModel.fechaPago = new DateTime.now();         

            if (membresiaModel.id == null){
              membresiaModel.id = 0;              
              usuarioMembresiaProvider.createUsuarioMembresia(membresiaModel);           
            }else {
              usuarioMembresiaProvider.updateUsuarioMembresia(membresiaModel);
            }
            await Future.delayed(const Duration(milliseconds: 700));
            Navigator.push(context, SlideRightRoute(widget: UsuarioMembresiaPage()));
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
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                 SizedBox(height: 20.0),
                  buildTitle("Información Membresia"),
                  SizedBox(height: 5.0),
                  _inputName(),
                  _inputNameEscuela(),
                  _dropdrownMembresia(),
                  _inputFechaNacimiento(),
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