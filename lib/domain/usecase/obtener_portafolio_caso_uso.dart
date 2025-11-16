import 'package:oasis/domain/repository/portafolio_repositorio.dart';

class ObtenerPortafolioCasoUso {
  final PortafolioRepositorio _repository;

  ObtenerPortafolioCasoUso(this._repository);

  Future<Map<String, dynamic>> call(int idUsuario) async {
    return await _repository.obtenerPortafolio(idUsuario);
  }
}