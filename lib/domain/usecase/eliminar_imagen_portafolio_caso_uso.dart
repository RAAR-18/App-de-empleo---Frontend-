import 'package:oasis/domain/repository/portafolio_repositorio.dart';

class EliminarImagenPortafolioCasoUso {
  final PortafolioRepositorio _repository;

  EliminarImagenPortafolioCasoUso(this._repository);

  Future<void> call(int idImagen) async {
    return await _repository.eliminarImagenPortafolio(idImagen);
  }
}