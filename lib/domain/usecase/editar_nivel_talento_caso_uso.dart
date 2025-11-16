import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class EditarNivelTalentoCasoUso {
  final TalentoRepositorio repositorio;

  EditarNivelTalentoCasoUso(this.repositorio);

  Future<RelUsuarioTalento> call(
      int idUsuario, int idTalento, int nivelDominio) {
    return repositorio.editarNivelTalento(idUsuario, idTalento, nivelDominio);
  }
}