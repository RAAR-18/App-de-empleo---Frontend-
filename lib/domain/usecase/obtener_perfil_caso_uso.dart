import 'package:oasis/domain/model/perfil.dart';
import 'package:oasis/domain/repository/perfil_repositorio.dart';

class ObtenerPerfilCasoUso {
  final PerfilRepositorio repositorio;

  ObtenerPerfilCasoUso(this.repositorio);

  Future<Perfil> call(int idUsuario) {
    return repositorio.obtenerPerfil(idUsuario);
  }
}
