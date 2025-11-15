import 'package:oasis/domain/model/ubicacion.dart';
import 'package:oasis/domain/repository/ubicacion_repositorio.dart';

class BuscarUbicacionesCasoUso {
  final UbicacionRepository _repository;

  BuscarUbicacionesCasoUso(this._repository);

  Future<List<Ubicacion>> call(String termino) async {
    return await _repository.buscarUbicaciones(termino);
  }
}