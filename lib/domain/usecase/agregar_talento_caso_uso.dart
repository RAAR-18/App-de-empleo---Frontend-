import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class AgregarTalentoCasoUso {
  final TalentoRepositorio repositorio;

  AgregarTalentoCasoUso(this.repositorio);

  Future<RelUsuarioTalento> call(
      int idUsuario, int idTalento, int nivelDominio) {
    return repositorio.agregarTalento(idUsuario, idTalento, nivelDominio);
  }
}