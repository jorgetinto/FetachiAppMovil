import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/detalle_examen_model.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/examen_model.dart';
import 'package:fetachiappmovil/pages/Examinar/Seleccionar_Estudiante_page.dart';
import 'package:fetachiappmovil/services/detalle_examen_service.dart';
import 'package:fetachiappmovil/services/examen_service.dart';
import 'package:fetachiappmovil/services/grado_service.dart';

import 'package:date_field/date_field.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class DetalleExamenPage extends StatefulWidget {

  @override
  _DetalleExamenPageState createState() => _DetalleExamenPageState();
}

class _DetalleExamenPageState extends State<DetalleExamenPage> {

  final      formKey            = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey        = new GlobalKey<ScaffoldState>();
  FocusNode                 _node              = new FocusNode();
  ExamenServices            examenProvider      = new ExamenServices();
  GradoServices             gradoProvider      = new GradoServices();
  DetalleExamenService      detalleProvider   = new DetalleExamenService();
  UsuarioServices           usuario          = new UsuarioServices();
  Future<DetalleExamenModel> userData;
  DetalleExamenModel model;
  Future<ExamenModel> detalle;  
  int idExamen;
  Future<List<DropDownModel>>   selectGrado;
  Future<List<DropDownModel>>   maestros;

  DateTime selectedDate    = new DateTime.now();
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

  AppBar _appBar(BuildContext context) {  
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
         Navigator.push (
              context,
              MaterialPageRoute(builder: (context) => SeleccionarEstudiantePage()),
          );
        },
      ),
      title: Text('Examinar'),
      backgroundColor: Colors.black,      
    );
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
        userData      = ModalRoute.of(context).settings.arguments;
        selectGrado   = gradoProvider.getAllGrados();
        maestros      = usuario.getUsuariosMaestros();   
    });  

    Widget _inputNombre(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.nombreEstudiante,
          textCapitalization: TextCapitalization.sentences,
          enabled: false, 
          decoration: InputDecoration(
            labelText: 'Estudiante',
            border: OutlineInputBorder(),                        
          ),
          onSaved: (value) => model.nombreEstudiante = value.trim(),
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
        ),
      );
    }

    Widget _inputInstructor(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.nombreInstructor,
          textCapitalization: TextCapitalization.sentences,
          enabled: false, 
          decoration: InputDecoration(
            labelText: 'Instructor',
            border: OutlineInputBorder(),                        
          ),
          onSaved: (value) => model.nombreInstructor = value.trim(),
          validator: (value){
           if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
        ),
      );
    }

     Widget _inputGradoActual(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.nombreGradoActual,
          textCapitalization: TextCapitalization.sentences,
          enabled: false, 
          decoration: InputDecoration(
            labelText: 'Grado Actual',
            border: OutlineInputBorder(),                        
          ),
          onSaved: (value) => model.nombreGradoActual = value.trim(),
          validator: (value){
             if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
        ),
      );
    }

    Widget _inputFecha(DetalleExamenModel model) {

      DateTime selectedDate = (model.fecha != null)
                                ? DateTime.parse(model.fecha.toString()) 
                                : new DateTime.now() ;

      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: DateTimeField(
              
            mode: DateFieldPickerMode.date,
              dateFormat: DateFormat("dd/MM/yyyy"),            
              selectedDate: selectedDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  model.fecha = date;
              });
            }, 
              decoration: InputDecoration(
                labelText: 'Fecha Examen',
                border: OutlineInputBorder()
              ),
              //label: 'Fecha de nacimiento',  
          lastDate: DateTime(2100),
        ),
      );
    }

    Widget _inputTarea(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.tarea.toString() ,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Nota Tarea',
            border: OutlineInputBorder(),                        
          ),         
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
           onSaved: (value) => model.tarea =  double.parse(value),
        ),
      );
    }

    Widget _inputAsistencia(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.asistencia.toString(),
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Nota Asistencia',
            border: OutlineInputBorder(),                        
          ),          
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
          onSaved: (value) => model.asistencia = double.parse(value),
        ),
      );
    }

    Widget _inputExamen(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.notaExamen.toString(),
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Nota Examen',
            border: OutlineInputBorder(),                        
          ),
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
          onSaved: (value) => model.notaExamen =  double.parse(value),
        ),
      );
    }

    Widget _inputNotaFinal(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.notaFinal.toString() ,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Nota Final',
            border: OutlineInputBorder(),                        
          ),         
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
           onSaved: (value) => model.notaFinal = double.parse(value),
        ),
      );
    }

    Widget _inputObservacion(DetalleExamenModel model) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          initialValue: model.observaciones,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(),                        
          ),
          onSaved: (value) => model.observaciones = value.trim(),
          validator: (value){
            if (value == null || value.isEmpty){
              return 'Campo requerido';
            } else {
              return null;
            }
          },
        ),
      );
    }

    Widget _dropdrownMaestro(DetalleExamenModel model) {
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
                      value:  null,
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
                            model.idExaminador = int.parse(value);             
                        });
                      },
                    ),
                  ),
                );                      
            }),
        ),
      );
  }

  Widget _dropdrownGrado(DetalleExamenModel model){

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
                      value: model.idGradoActual?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Grado Ascenso',
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
                          model.idGradoAscenso = int.parse(value); 
                        });
                      },
                    ),
                  ),
                );

            }),
        ),
      ): Container(height: 0, width: 0,);
    }

  Widget _switchEstado(DetalleExamenModel model){
       return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Switch(
                  activeColor: Colors.pinkAccent,
                  value:  model.estado,
                  onChanged: (value) {
                    setState(() {
                      model.estado = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                 Text('Estado : ${ (model.estado == null)? 'Aprobado':  (model.estado)? 'Aprobado': 'Rechazado'}', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                ),)
              ],
            );
    }

  void _submit(DetalleExamenModel model) async {

     if (formKey.currentState.validate()) {

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

          if(model != null) { 
            if (model.idDetalle == null || model.idDetalle == 0){
              model.idDetalle = 0;
              detalleProvider.createDetalleExamen(model);           
            }else {
              detalleProvider.updateDetalleExamen(model);         
            }
            await Future.delayed(const Duration(milliseconds: 700));
            Navigator.push(context, SlideRightRoute(widget: SeleccionarEstudiantePage()));
          }
      }
    }

  Widget _crearBoton(DetalleExamenModel model) {
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
            onPressed: () =>  _submit(model),
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
          FutureBuilder<DetalleExamenModel>(
            future: userData,
            builder: (BuildContext context, AsyncSnapshot<DetalleExamenModel> snapshot) { 
              if (snapshot.hasData){

                if (snapshot.data != null) {                       

                  return Padding(padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[                   
                            SizedBox(height: 20.0),
                            buildTitle("Detalle Examen"),
                            SizedBox(height: 5.0),
                            _inputNombre(snapshot.data),
                            _inputInstructor(snapshot.data),
                            _inputGradoActual(snapshot.data),
                            _inputFecha(snapshot.data),

                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _inputAsistencia(snapshot.data)
                                  ),
                                ),
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:_inputTarea(snapshot.data)
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _inputExamen(snapshot.data)
                                  ),
                                ),
                                new Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: _inputNotaFinal(snapshot.data)
                                  ),
                                ),
                              ],
                            ),
                            _inputObservacion(snapshot.data),
                            _dropdrownGrado(snapshot.data),
                            _dropdrownMaestro(snapshot.data),
                          _switchEstado(snapshot.data),
                           _crearBoton(snapshot.data)
                          ]
                        )
                      )
                    );                   
                } else {
                  return CircularProgressIndicator();
                }              
              }else {
                  return CircularProgressIndicator();
              }  
           },
           
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
  }}