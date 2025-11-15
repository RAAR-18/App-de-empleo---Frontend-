import 'package:oasis/data/remote/datos_basicos_api.dart';
import 'package:oasis/data/remote/dto/datos_basicos_actualizar_dto.dart';
import 'package:oasis/domain/model/datos_basicos.dart';
import 'package:oasis/domain/repository/datos_basicos_repositorio.dart';

class DatosBasicosRepositoryImpl implements DatosBasicosRepository {
  final DatosBasicosApi _api;

  DatosBasicosRepositoryImpl(this._api);

  @override
  Future<DatosBasicos> obtenerDatosBasicos(int idUsuario) async {
    final respuesta = await _api.obtenerDatosBasicos(idUsuario);

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al obtener datos básicos');
    }

    final dto = respuesta.datos!;

    return DatosBasicos(
      idUsuario: dto.idUsuario,
      nombresUsuario: dto.nombresUsuario,
      apellidosUsuario: dto.apellidosUsuario,
      documentoUsuario: dto.documentoUsuario,
      profesion: dto.profesion,
      ubicacion: dto.ubicacion,
      idUbicacion: dto.idUbicacion,
    );
  }

  @override
  Future<void> actualizarDatosBasicos(DatosBasicos datosActualizados) async {
    if (datosActualizados.idUbicacion == null) {
      throw Exception('La ubicacion es requerida');
    }

    final dto = DatosBasicosActualizarDTO(
        idUsuario: datosActualizados.idUsuario,
        nombresUsuario: datosActualizados.nombresUsuario,
        apellidosUsuario: datosActualizados.apellidosUsuario,
        documentoUsuario: datosActualizados.documentoUsuario,
        profesion: datosActualizados.profesion,
        idUbicacion: datosActualizados.idUbicacion!,
    );

    final respuesta = await _api.actualizarUsuario(datosActualizados.idUsuario, dto,);

    if (respuesta.datos == null || respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al actualizar datos basicos');
    }
  }
}