import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class ObtenerTalentosUsuarioCasoUso {
  final TalentoRepositorio repositorio;

  ObtenerTalentosUsuarioCasoUso(this.repositorio);

  Future<List<RelUsuarioTalento>> call(int idUsuario) {
    return repositorio.obtenerTalentosUsuario(idUsuario);
  }
}