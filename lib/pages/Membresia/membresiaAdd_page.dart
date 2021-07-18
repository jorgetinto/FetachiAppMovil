
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:fetachiappmovil/models/membresia_model.dart';
import 'package:fetachiappmovil/pages/Membresia/membresia_page.dart';
import 'package:fetachiappmovil/services/membresia_service.dart';
import 'package:flutter/material.dart';

class MembresiaAddPage extends StatefulWidget {

  @override
  _MembresiaAddPageState createState() => _MembresiaAddPageState();
}

class _MembresiaAddPageState extends State<MembresiaAddPage> {

  GlobalKey<FormState>      formKey          = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState>  scaffoldKey      = new GlobalKey<ScaffoldState>();

  MembresiaModel            membresiaModel      = new MembresiaModel();
  MembresiaServices         membresiaProvider   = new MembresiaServices();
  bool                      _autoValidate       = false;
  MembresiaModel            membresiaData;
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
    membresiaData    = new MembresiaModel();
    membresiaModel   = new MembresiaModel(); 
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
            MaterialPageRoute(builder: (context) => MembresiaPage()),
        ),
      ),
      title: Text('Crear Membresia'),
      backgroundColor: Colors.black,      
    );
  }

  @override
  Widget build(BuildContext context) {


    setState(() {
      membresiaModel  = new MembresiaModel();
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
              content: new Text("Si desactiva esta membresia, ...."),
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
            initialValue: membresiaModel.nombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Nombre",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => membresiaModel.nombre = value,
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

    Widget _inputMonto() {
        return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            initialValue: membresiaModel.monto.toString() ?? "0",
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Valor",
              border: OutlineInputBorder(),                        
            ),
            onSaved: (value) => membresiaModel.monto = int.parse(value),
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
                Text('Estado : ${ (membresiaModel.estado == null)? true:  (membresiaModel.estado)? 'Activo': 'Inactivo'}', style: TextStyle(
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
            if (membresiaModel.id == null){
              membresiaModel.id = 0;
              membresiaProvider.createMembresia(membresiaModel);           
            }else {
              membresiaProvider.updateMembresia(membresiaModel);
            }
            await Future.delayed(const Duration(milliseconds: 700));
            Navigator.push(context, SlideRightRoute(widget: MembresiaPage()));
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
                  _inputMonto(),
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