import 'package:fetachiappmovil/bloc/changePass_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/utils.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';


class Resetpassword extends StatelessWidget {

  Widget _instrucciones() {
      return Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10.0),),

              child:
                  Row(
                    children: [
                      Icon(Icons.lock_open, color: Colors.black87,size: 80.0,),
                      
                      Column(
                        children: [    
                          Text('Cambiar contraseña', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, ),),  
                          SizedBox(height: 5.0,),                
                          Text("Las contraseñas deben tener:",),
                          SizedBox(height: 2.0,),
                          Text(" - un mínimo de 6 caracteres"),
                          SizedBox(height: 2.0,),
                          Text(" - al menos una minúscula",),
                          SizedBox(height: 2.0,),
                          Text(" - al menos una mayúscula", ),
                          SizedBox(height: 2.0,),
                          Text(" - Ejemplo: Juan1990",),
                        ],
                      ),
                    ],
                  ),
            ),
          ],
        ),
      );
    }

  Widget _inputPassword(ChangePasswordBloc bloc) {
        return StreamBuilder(
          stream: bloc.passwordStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline, color: Colors.black87,),
                  labelText: 'Contraseña',
                  counterText: snapshot.data,
                  errorText: snapshot.error,
                  fillColor: Colors.pink
                ),
                onChanged: bloc.changePassword,
              ),
            );
          }
        );
      }

  Widget _repetirPassword(ChangePasswordBloc bloc) {
    return StreamBuilder(
      stream: bloc.repetirPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.black87,),
              labelText: 'Repetir Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error,
              fillColor: Colors.pink
            ),
            onChanged: bloc.changerepetirPassword,
          ),
        );
      }
    );
  }
  
  Widget _crearBotton(ChangePasswordBloc bloc, BuildContext context) {
    return StreamBuilder(
      stream: bloc.formValidChangePass,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Guardar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _cambiarPass(bloc, context) : null
        );
      }
    );
  }

  _cambiarPass(ChangePasswordBloc bloc, BuildContext context) async {
    Map info = await bloc.cambiarPassword(bloc.password);
    if (info['ok']) {
      showToast(context,'Contraseña guardada de forma exitosa!');
      bloc.changePassword("");
      bloc.changerepetirPassword("");
      Navigator.pushReplacement(context, SlideRightSinOpacidadRoute(widget: HomePage()));
    } else {
      showToast(context,info['message']);
    }
}


  @override
  Widget build(BuildContext context) {

    final bloc = ProviderBloc.cambiarPassBloc(context);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),              
            onPressed: () => Navigator.of(context).pop(),
          ), 
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      body:       
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        
                       // _crearFondo(context),                        
                        
                        _instrucciones(),
                        SizedBox(height: 5.0,),
                        _inputPassword(bloc),
                        _repetirPassword(bloc),
                        SizedBox(height: 20.0,),
                        _crearBotton(bloc, context)
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.0),
              ],
            ),
          ),
    ); 
  }
}