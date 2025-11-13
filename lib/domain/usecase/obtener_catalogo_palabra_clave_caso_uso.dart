import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/repository/palabra_clave_repositorio.dart';

class ObtenerCatalogoPalabrasClavesCasoUso {
  final PalabraClaveRepositorio repositorio;

  ObtenerCatalogoPalabrasClavesCasoUso(this.repositorio);

  // Obtener todas las palabras clave disponibles
  Future<List<PalabraClave>> call() {
    return repositorio.obtenerCatalogo();
  }
}