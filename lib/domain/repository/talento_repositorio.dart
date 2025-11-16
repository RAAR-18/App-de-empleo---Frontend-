import 'package:oasis/domain/model/talento.dart';
import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/model/talento_estadisticas.dart';

abstract class TalentoRepositorio {
  Future<List<RelUsuarioTalento>> obtenerTalentosUsuario(int idUsuario);
  Future<TalentoEstadisticas> obtenerEstadisticas(int idUsuario);
  Future<List<Talento>> obtenerCatalogoTalentos();
  Future<RelUsuarioTalento> agregarTalento(int idUsuario, int idTalento, int nivelDominio);
  Future<RelUsuarioTalento> editarNivelTalento(int idUsuario, int idTalento, int nivelDominio);
  Future<void> eliminarTalento(int idUsuario, int idTalento);
}