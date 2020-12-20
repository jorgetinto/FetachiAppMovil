
import 'package:fetachiappmovil/models/escuela_model.dart';
import 'package:fetachiappmovil/services/escuela_service.dart';
import 'package:rxdart/rxdart.dart';

class EscuelaBloc {

  final _escuelaController   = new BehaviorSubject<EscuelaModel>();
  final _escuelaService      = new EscuelaServices();

  Stream<EscuelaModel> get userPerfilStream => _escuelaController.stream;

  void getAllEscuelas() async {
    final user = await _escuelaService.getAllEscuelas();
    _escuelaController.add(user);    
  }

}