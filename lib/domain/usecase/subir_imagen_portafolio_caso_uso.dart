import 'package:oasis/domain/repository/portafolio_repositorio.dart';

class SubirImagenPortafolioCasoUso {
  final PortafolioRepositorio _repository;

  SubirImagenPortafolioCasoUso(this._repository);

  Future<void> call(
      int idUsuario,
      String rutaArchivo,
      String nombreProyecto,
      ) async {
    return await _repository.subirImagenPortafolio(
      idUsuario,
      rutaArchivo,
      nombreProyecto,
    );
  }
}