import 'package:oasis/domain/model/archivo.dart';
import 'package:oasis/domain/repository/archivo_repositorio.dart';

class ObtenerAchivoCasoUso {
  final ArchivoRepositorio _repositorio;

  ObtenerAchivoCasoUso(this._repositorio);

  Future<Archivo?> call(int idUsuario) async {
    return await _repositorio.obtenerCV(idUsuario);
  }
}