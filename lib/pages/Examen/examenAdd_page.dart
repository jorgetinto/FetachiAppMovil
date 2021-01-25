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


class ExamenAddPage extends StatefulWidget {

  @override
  _ExamenAddPageState createState() => _ExamenAddPageState();
}

class _ExamenAddPageState extends State<ExamenAddPage> {

  GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();
  FocusNode                 _node            = new FocusNode();

  ExamenModel               examenModel     = new ExamenModel();
  ComunaRegionServices      comunaRegion     = new ComunaRegionServices();
  ZonaServices              zona             = new ZonaServices();
  UsuarioServices           usuario          = new UsuarioServices();
  ExamenServices            examenProvider   = new ExamenServices();

  Future<List<RegionModel>>     region;
  Future<List<ComunaModel>>     comuna;
  Future<List<ZonaModel>>       zonas;
  Future<List<DropDownModel>>   maestros;

  ExamenModel examenData;
  bool _loading = true;

  @override
    void initState() {
      new Future.delayed(new Duration(milliseconds: 900), () {
          setState(() {
              _loading = false;         
          });
        }); 

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

    Widget _inputUserName() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: examenModel.nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Nombre",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => examenModel.nombre = value,
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
                 SizedBox(height: 20.0),
                  buildTitle("Información Examen"),
                  SizedBox(height: 5.0),
                  _inputUserName(),
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