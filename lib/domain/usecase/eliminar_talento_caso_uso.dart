import 'package:oasis/domain/repository/talento_repositorio.dart';

class EliminarTalentoCasoUso {
  final TalentoRepositorio repositorio;

  EliminarTalentoCasoUso(this.repositorio);

  Future<void> call(int idUsuario, int idTalento) {
    return repositorio.eliminarTalento(idUsuario, idTalento);
  }
}