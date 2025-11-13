import 'package:oasis/domain/repository/palabra_clave_repositorio.dart';

class AgregarPalabrasClavesCasoUso {
  final PalabraClaveRepositorio repositorio;

  AgregarPalabrasClavesCasoUso(this.repositorio);

  Future<void> call(int idUsuario, List<int> idsPalabrasClave) {
    return repositorio.agregarPalabrasClave(idUsuario, idsPalabrasClave);
  }
}