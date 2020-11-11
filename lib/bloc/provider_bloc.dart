

import 'package:fetachiappmovil/bloc/changePass_bloc.dart';
import 'package:fetachiappmovil/bloc/escuela_bloc.dart';
import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:flutter/material.dart';

import 'login_bloc.dart';

class ProviderBloc extends InheritedWidget {

  final loginBloc         = new LoginBloc();
  final _userPerfilBloc   = new UserPerfilBloc();
  final _changePassBloc   = new ChangePasswordBloc();
  final _escuelaBloc      = new EscuelaBloc();

  static ProviderBloc _instancia;

  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }
    return _instancia;
  }

  ProviderBloc._internal({Key key, Widget child}) : super(key: key, child: child);  

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<ProviderBloc>().loginBloc;
  }

  static UserPerfilBloc userPefilBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<ProviderBloc>()._userPerfilBloc;
  }

  static ChangePasswordBloc cambiarPassBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<ProviderBloc>()._changePassBloc;
  }

  static EscuelaBloc escuelaBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<ProviderBloc>()._escuelaBloc;
  }

}