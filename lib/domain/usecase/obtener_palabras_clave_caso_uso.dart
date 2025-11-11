import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/repository/perfil_repositorio.dart';

class ObtenerPalabrasClaveCasoUso {
  final PerfilRepositorio repositorio;

  ObtenerPalabrasClaveCasoUso(this.repositorio);

  Future<List<PalabraClave>> call(int idUsuario) {
    return repositorio.obtenerPalabrasClave(idUsuario);
  }
}
