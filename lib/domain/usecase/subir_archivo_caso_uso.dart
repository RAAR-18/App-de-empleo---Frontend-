import 'package:oasis/domain/model/archivo.dart';
import 'package:oasis/domain/repository/archivo_repositorio.dart';

class SubirArchivoCasoUso {
  final ArchivoRepositorio _repositorio;

  SubirArchivoCasoUso(this._repositorio);

  Future<Archivo> call(int idUsuario, String rutaArchivo) async {
    return await _repositorio.subirCV(idUsuario, rutaArchivo);
  }

}