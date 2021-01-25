import 'package:fetachiappmovil/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/provider_bloc.dart';
import 'helpers/preferencias_usuario/preferenciasUsuario.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
        child: MaterialApp(
          title: 'Fetachi App',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: LoadingPage()
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('es'),
          ],
      ),
    );
  }
}