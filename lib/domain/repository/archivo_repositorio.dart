import 'package:oasis/domain/model/archivo.dart';

abstract class ArchivoRepositorio {
  Future<Archivo?> obtenerCV(int idUsuario);
  Future<List<int>> descargarCV(String nombrePrivado);
  Future<Archivo> subirCV(int idUsuario, String rutaArchivo);
  Future<void> eliminarCV(int idArchivo);
}