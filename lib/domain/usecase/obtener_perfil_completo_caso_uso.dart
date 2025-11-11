import 'package:oasis/domain/model/perfil_completo.dart';
import 'package:oasis/domain/repository/perfil_repositorio.dart';

class ObtenerPerfilCompletoCasoUso {
  final PerfilRepositorio repositorio;

  ObtenerPerfilCompletoCasoUso(this.repositorio);

  Future<PerfilCompleto> call(int idUsuario) {
    return repositorio.obtenerPerfilCompleto(idUsuario);
  }
}
