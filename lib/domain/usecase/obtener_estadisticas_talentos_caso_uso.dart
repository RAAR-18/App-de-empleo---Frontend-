import 'package:oasis/domain/model/talento_estadisticas.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class ObtenerEstadisticasTalentosCasoUso {
  final TalentoRepositorio repositorio;

  ObtenerEstadisticasTalentosCasoUso(this.repositorio);

  Future<TalentoEstadisticas> call(int idUsuario) {
    return repositorio.obtenerEstadisticas(idUsuario);
  }
}