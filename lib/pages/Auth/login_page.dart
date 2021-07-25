
import 'package:fetachiappmovil/bloc/login_bloc.dart';
import 'package:fetachiappmovil/bloc/provider_bloc.dart';
import 'package:fetachiappmovil/helpers/constants.dart';
import 'package:fetachiappmovil/helpers/routes/routes.dart';
import 'package:fetachiappmovil/helpers/widget/Header_widget.dart';
import 'package:fetachiappmovil/pages/Onboarding/onboarding_page.dart';
import 'package:fetachiappmovil/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final authService                           = new AuthServices();
  bool _isButtonDisabled = false;

  @override
  void initState() {
    this.version();
    super.initState();
  }

  void version() async {
    String _version         = VERSION_APP;
    final authService       = new AuthServices();    
    final versionAPI        = await authService.getVersion();

    if (_version.compareTo(versionAPI.version) != 0 ) {      

        _isButtonDisabled = false;  
        _scaffoldKey.currentState.showSnackBar(
                new SnackBar(duration: new Duration(milliseconds: 5000), content:
                  new Row(
                    children: <Widget>[
                      new CircularProgressIndicator(),
                      new Text('  Versión de aplicación desactualizada')
                    ],
                  ),
                )
              );
    } else {
      setState(() {
         _isButtonDisabled  = true;
      });
    }
  }

  Widget _crearFondo(BuildContext context) {

    return Stack(
      children: <Widget>[
        HeaderWaveGradient(),       
          Container(
            padding: EdgeInsets.only(top: 40.0),
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 180,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                       child: Image.asset('assets/img/FETACHI.png'),
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = ProviderBloc.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 170.0,)),
          Container(
            width: size.width * 0.9,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[

                 Text('iniciar Sesión', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                _crearUserName(bloc),
                 SizedBox(height: 20.0,),
                _crearPassword(bloc),
                 SizedBox(height: 20.0,),
                _crearBotton(bloc),
                 SizedBox(height: 20.0,),
                 Text((_isButtonDisabled)?'Versión: $VERSION_APP Actualizada':'Versión $VERSION_APP Desactualizada'),
              ],
            ),
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }

  Widget _crearUserName(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.userNameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle, color: Colors.black87,),
              hintText: 'Juan.perez',
              labelText: 'Nombre de Usuario',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeUserName,
          ),
        );
      }      
    );
  }

  Widget _crearPassword(LoginBloc bloc) {

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

  Widget _crearBotton(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: (!_isButtonDisabled)? null: snapshot.hasData ? () => _login(bloc, context) : null
        );
      }
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {

    Map info = await bloc.login(bloc.userName.trim(), bloc.password.trim());
    if (info['ok']) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(milliseconds: 1600), content:
            new Row(
              children: <Widget>[
                new CircularProgressIndicator(),
                new Text(' Iniciando sesión')
              ],
            ),
          )
        );
        await new Future.delayed(const Duration(milliseconds : 400));
      Navigator.pushReplacement(context, SlideRightSinOpacidadRoute(widget: OnBoardingPage()));
    } else {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(milliseconds: 2000), content:
          new Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              new Text('  - ' + info['mensaje'])
            ],
          ),
        )
      );
    }
  }

  @override
 Widget build(BuildContext context) { 
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context)
        ],
      )
    );
  }
}