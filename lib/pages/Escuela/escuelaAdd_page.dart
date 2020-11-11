import 'dart:io';

import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/models/comuna_model.dart';
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/models/region_model.dart';
import 'package:fetachiappmovil/services/comunaRegion_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fetachiappmovil/helpers/utils.dart' as utils;


class EscuelaAddPage extends StatefulWidget {

  @override
  _EscuelaAddPageState createState() => _EscuelaAddPageState();
}

class _EscuelaAddPageState extends State<EscuelaAddPage> {

  File foto;
  EscuelaBloc escuelaBloc;
  EscuelaModel escuelaModel         = new EscuelaModel();
  ComunaRegionServices comunaRegion = new ComunaRegionServices();
  Future<List<RegionModel>> region;
  Future<List<ComunaModel>> comuna;
  final formKey                     = GlobalKey<FormState>();
  final scaffoldKey                 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    setState(() {
        region = comunaRegion.getAllRegiones();
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
                  utils.buildTitle("Información Dojang"),
                  SizedBox(height: 5.0),
                  _inputNombre(),
                  _inputDireccion(),
                   _dropdrownRegion(comunaRegion),       
                  _dropdrownComuna(comunaRegion, comuna),  
                ]
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
        title: Text('Crear Dojang'),
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
    // final _picker                   = ImagePicker();
    // PickedFile pickedFile           = await _picker.getImage(source: origin);      
    // foto                            = File(pickedFile.path);  

    // if (foto != null) {
    // usePerfilModel.imagen = null;
    // }  

    // setState(() {});
  }

  Widget _mostrarFoto() {

      // if (usePerfilModel.imagen != null) {

      //   return FadeInImage(
      //     placeholder: AssetImage('assets/jar-loading.gif'), 
      //     image: NetworkImage(usePerfilModel.imagen),
      //     height: 300.0,
      //     fit: BoxFit.contain,
      //     );

      // } else {

      //     if( foto != null ){
      //       return Image.file(
      //         foto,
      //         fit: BoxFit.cover,
      //         height: 300.0,
      //       );
      //   }
        
        return Image.asset('assets/no-image.png'); 
      }

  Widget _inputNombre() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: escuelaModel.nombre,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Nombre',
          border: OutlineInputBorder(),
                        
        ),
        onSaved: (value) => escuelaModel.nombre = value,
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

  Widget _inputDireccion() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        initialValue: escuelaModel.direccion,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Dirección',
          border: OutlineInputBorder(),
        ),
        onSaved: (value) => escuelaModel.direccion = value,
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
                    escuelaModel.idComuna = null;
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

              if (escuelaModel.idComuna != null) {
                return DropdownButtonFormField<String>(
                  value: escuelaModel.idComuna,
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
                      escuelaModel.idComuna = value;                     
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
                      escuelaModel.idComuna = value;                     
                    });
                  },
                );
              }              
            }),
        ),
      ): Container(height: 0, width: 0,);
  }

}