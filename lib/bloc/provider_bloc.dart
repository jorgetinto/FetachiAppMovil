

import 'package:fetachiappmovil/bloc/userPerfil_bloc.dart';
import 'package:flutter/material.dart';

import 'login_bloc.dart';

class ProviderBloc extends InheritedWidget {

  final loginBloc         = new LoginBloc();
  final _userPerfilBloc   = new UserPerfilBloc();

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

}