import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/dropdown_model.dart';
import 'package:fetachiappmovil/models/examen_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:fetachiappmovil/models/zona_model.dart';
import 'package:fetachiappmovil/pages/Examen/examen_page.dart';
import 'package:fetachiappmovil/services/comunaRegion_service.dart';
import 'package:fetachiappmovil/services/examen_service.dart';
import 'package:fetachiappmovil/services/usuario_service.dart';
import 'package:fetachiappmovil/services/zona_service.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';


class ExamenAddPage extends StatefulWidget {

  @override
  _ExamenAddPageState createState() => _ExamenAddPageState();
}

class _ExamenAddPageState extends State<ExamenAddPage> {

  GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();
  FocusNode                 _node            = new FocusNode();

  ExamenModel               examenModel      = new ExamenModel();
  ComunaRegionServices      comunaRegion     = new ComunaRegionServices();
  ZonaServices              zona             = new ZonaServices();
  UsuarioServices           usuario          = new UsuarioServices();
  ExamenServices            examenProvider   = new ExamenServices();
  bool                      _autoValidate       = false;

  Future<List<RegionModel>>     region;
  Future<List<ComunaModel>>     comuna;
  Future<List<ZonaModel>>       zonas;
  Future<List<DropDownModel>>   maestros;

  ExamenModel examenData;
  bool _loading = true;

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
    examenData    = new ExamenModel();
    examenModel   = new ExamenModel(); 
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
            MaterialPageRoute(builder: (context) => ExamenPage()),
        ),
      ),
      title: Text('Crear Examen'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {

     setState(() {
      examenModel  = new ExamenModel();
      examenData      = ModalRoute.of(context).settings.arguments;
      region        = comunaRegion.getAllRegiones();
      zonas         = zona.getAllZonases();
      maestros      = usuario.getUsuariosMaestros();     

        if (examenData != null) {
          examenModel = examenData;
        }     
      });

    _showMaterialDialog() {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Atención"),
              content: new Text("Si desactiva este examen, ...."),
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

    Widget _switchEstado(){
       return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Switch(
                  activeColor: Colors.pinkAccent,
                  value:  (examenModel.estado == null)? true:  (examenModel.estado)?true: false,
                  onChanged: (value) {
                    setState(() {                      
                      if (!value)
                        _showMaterialDialog();
                        examenModel.estado = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                Text('Estado : ${ (examenModel.estado == null)? true:  (examenModel.estado)? 'Activo': 'Inactivo'}', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0
                ),)
              ],
            );
    }

    Widget _inputName() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: examenModel.nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Nombre del examen",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => examenModel.nombre = value,
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
                        value: examenModel.idMaestro?.toString()?? null,
                      decoration: InputDecoration(
                        labelText: 'Examinador',
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
                            examenModel.idMaestro = int.parse(value);             
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
      );
  }

    Widget _inputDireccion() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: examenModel.direcion,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Dirección',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => examenModel.direcion = value,
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
                                value: examenModel.idRegion?? null,
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
                                    examenModel.idComuna = null;
                                    comuna = comunaRegion.getAllComunaByIdRegion(value);                    
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
      );
  }

    Widget _dropdrownComuna(ComunaRegionServices comunaRegion, Future<List<ComunaModel>> comuna) {

      if (examenModel.idRegion != null){
         comuna = comunaRegion.getAllComunaByIdRegion(examenModel.idRegion);   
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

              if (examenModel.idComuna != null) {
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
                          value: examenModel.idComuna,
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
                              examenModel.idComuna = value;                     
                            });
                          },
                          validator: (value){
                            if (value.isEmpty || value == null) {
                              return 'Campo requerido';
                            } else {
                              return null;
                            }
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
                                examenModel.idComuna = value;                     
                              });
                            },
                            validator: (value){
                              if (value.isEmpty || value == null) {
                                return 'Campo requerido';
                              } else {
                                return null;
                              }
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
                      value: examenModel.idZona?.toString()?? null,
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
                            examenModel.idZona = int.parse(value);             
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
      );
  }

    Widget _inputFecha() {

      DateTime selectedDate = (examenModel.fecha != null)
                                ? DateTime.parse(examenModel.fecha.toString()) 
                                : new DateTime.now() ;
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: DateTimeField(
              
            mode: DateFieldPickerMode.date,
              dateFormat: DateFormat("dd/MM/yyyy"),            
              selectedDate: selectedDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  examenModel.fecha = date;
              });
            }, 
              decoration: InputDecoration(
                labelText: 'Fecha de examen',
                border: OutlineInputBorder()
              ),
        ),
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

          if(examenModel != null) { 
            if (examenModel.idExamen == null){
              examenModel.idExamen = 0;
              examenProvider.createExamen(examenModel);           
            }else {
              examenProvider.updateExamen(examenModel);
            }
            await Future.delayed(const Duration(milliseconds: 700));
            Navigator.push(context, SlideRightRoute(widget: ExamenPage()));
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
                  buildTitle("Información Examen"),
                  SizedBox(height: 5.0),
                  _inputName(),
                  _inputFecha(),
                  _dropdrownMaestro(),
                  _inputDireccion(),
                  _dropdrownRegion(comunaRegion),       
                  _dropdrownComuna(comunaRegion, comuna),  
                  _dropdrownZonas(),
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