import 'package:oasis/data/remote/verificacion_correo_api.dart';
import 'package:oasis/domain/model/verificacion_correo.dart';
import 'package:oasis/domain/repository/verificacion_correo_repositorio.dart';

class VerificacionCorreoRepositorioImpl implements VerificacionCorreoRepositorio {
  final VerificacionCorreoApi _api;

  VerificacionCorreoRepositorioImpl(this._api);

  @override
  Future<VerificacionCorreo> enviarCodigoVerificacion(String correoAcceso) async {
    final respuesta = await _api.enviarCodigoVerificacion(correoAcceso);

    if (respuesta.codigoEstado == 200) {
      if (respuesta.datos != null) {
        return VerificacionCorreo.fromJson(respuesta.datos);
      }

      return VerificacionCorreo(
        exito: true,
        mensaje: respuesta.mensaje ?? 'Código enviado exitosamente',
        correoVerificado: correoAcceso,
        estadoVerificacion: 2,
      );
    }

    throw Exception(respuesta.mensaje ?? 'Error al enviar código');
  }

  @override
  Future<VerificacionCorreo> verificarCodigo(String correoAcceso, String codigo) async {
    final respuesta = await _api.verificarCodigo(correoAcceso, codigo);

    if (respuesta.codigoEstado == 200) {
      if (respuesta.datos != null) {
        return VerificacionCorreo.fromJson(respuesta.datos);
      }

      return VerificacionCorreo(
        exito: true,
        mensaje: respuesta.mensaje ?? 'Código verificado exitosamente',
        correoVerificado: correoAcceso,
        estadoVerificacion: 3, // Verificado
      );
    }

    throw Exception(respuesta.mensaje ?? 'Error al verificar código');
  }

  @override
  Future<VerificacionCorreo> obtenerEstadoVerificacion(String correoAcceso) async {
    final respuesta = await _api.obtenerEstadoVerificacion(correoAcceso);

    if (respuesta.codigoEstado == 200) {
      if (respuesta.datos == null) {

        int estadoInferido = 1;
        final mensajeLower = respuesta.mensaje?.toLowerCase() ?? '';

        if (mensajeLower.contains('verificado') && !mensajeLower.contains('sin')) {
          estadoInferido = 3;
        } else if (mensajeLower.contains('pendiente')) {
          estadoInferido = 2;
        }

        return VerificacionCorreo(
          exito: true,
          mensaje: respuesta.mensaje ?? 'Estado obtenido',
          correoVerificado: correoAcceso,
          estadoVerificacion: estadoInferido,
        );
      }

      final verificacion = VerificacionCorreo.fromJson(respuesta.datos);
      return verificacion;
    }

    throw Exception(respuesta.mensaje ?? 'Error al obtener estado');
  }
}