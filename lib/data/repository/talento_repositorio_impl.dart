import 'package:oasis/data/remote/talento_api.dart';
import 'package:oasis/data/remote/dto/talento_agregar_dto.dart';
import 'package:oasis/domain/model/talento.dart';
import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/model/talento_estadisticas.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class TalentoRepositorioImpl implements TalentoRepositorio {
  final TalentoApi _talentoApi;

  TalentoRepositorioImpl(this._talentoApi);

  @override
  Future<List<RelUsuarioTalento>> obtenerTalentosUsuario(int idUsuario) async {
    final respuesta = await _talentoApi.obtenerTalentosUsuario(idUsuario);

    if (respuesta.datos == null) {
      throw Exception(
          respuesta.mensaje ?? 'Error al obtener los talentos del usuario');
    }

    return respuesta.datos!
        .map((dto) => RelUsuarioTalento(
      idUsuario: dto.idUsuario,
      idTalento: dto.idTalento,
      nombreTalento: dto.nombreTalento,
      nivelDominio: NivelDominio.fromValor(dto.nivelDominio),
    ))
        .toList();
  }

  @override
  Future<TalentoEstadisticas> obtenerEstadisticas(int idUsuario) async {
    final respuesta = await _talentoApi.obtenerEstadisticas(idUsuario);

    if (respuesta.datos == null) {
      throw Exception(
          respuesta.mensaje ?? 'Error al obtener las estadísticas');
    }

    final dto = respuesta.datos!;
    return TalentoEstadisticas(
      totalTalentos: dto.totalTalentos,
      totalCompetencias: dto.totalCompetencias,
      totalHabilidades: dto.totalHabilidades,
      nivelBasico: dto.nivelBasico,
      nivelIntermedio: dto.nivelIntermedio,
      nivelAvanzado: dto.nivelAvanzado,
    );
  }

  @override
  Future<List<Talento>> obtenerCatalogoTalentos() async {
    final respuesta = await _talentoApi.obtenerCatalogoTalentos();

    if (respuesta.datos == null) {
      throw Exception(
          respuesta.mensaje ?? 'Error al obtener el catálogo de talentos');
    }

    return respuesta.datos!
        .map((dto) => Talento(
      idTalento: dto.idTalento,
      nombre: dto.nombre,
    ))
        .toList();
  }

  @override
  Future<RelUsuarioTalento> agregarTalento(
      int idUsuario, int idTalento, int nivelDominio) async {
    final dto = TalentoAgregarDTO(
      idUsuario: idUsuario,
      idTalento: idTalento,
      nivelDominio: nivelDominio,
    );

    final respuesta = await _talentoApi.agregarTalento(dto);

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al agregar el talento');
    }

    final dtoRespuesta = respuesta.datos!;
    return RelUsuarioTalento(
      idUsuario: dtoRespuesta.idUsuario,
      idTalento: dtoRespuesta.idTalento,
      nombreTalento: dtoRespuesta.nombreTalento,
      nivelDominio: NivelDominio.fromValor(dtoRespuesta.nivelDominio),
    );
  }

  @override
  Future<RelUsuarioTalento> editarNivelTalento(
      int idUsuario, int idTalento, int nivelDominio) async {
    final respuesta = await _talentoApi.editarNivelTalento(
        idUsuario, idTalento, nivelDominio);

    if (respuesta.datos == null) {
      throw Exception(
          respuesta.mensaje ?? 'Error al editar el nivel del talento');
    }

    final dto = respuesta.datos!;
    return RelUsuarioTalento(
      idUsuario: dto.idUsuario,
      idTalento: dto.idTalento,
      nombreTalento: dto.nombreTalento,
      nivelDominio: NivelDominio.fromValor(dto.nivelDominio),
    );
  }

  @override
  Future<void> eliminarTalento(int idUsuario, int idTalento) async {
    final respuesta = await _talentoApi.eliminarTalento(idUsuario, idTalento);

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al eliminar el talento');
    }
  }
}