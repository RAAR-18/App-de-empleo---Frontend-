import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_dto.dart';

/// API para gestionar el cambio de teléfono
class CambioTelefonoApi {
  final Dio _dio;

  CambioTelefonoApi(this._dio);

  /// Inicia el proceso de cambio de teléfono
  /// Envía un código al teléfono anterior
  Future<ApiRespuesta<IniciarCambioTelefonoRespuestaDto>> iniciarCambio(
      IniciarCambioTelefonoDto dto,
      ) async {
    try {
      final response = await _dio.post(
        '/perfil/telefono/iniciar',
        data: dto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['datos'] as Map<String, dynamic>;
        final respuestaDto = IniciarCambioTelefonoRespuestaDto.fromJson(data);

        return ApiRespuesta(
          codigoEstado: response.statusCode!,
          mensaje: response.data['mensaje'] as String? ?? 'OK',
          datos: respuestaDto,
          fechaHora: DateTime.now().toIso8601String()
        );
      } else {
        return ApiRespuesta(
          codigoEstado: response.statusCode ?? 500,
          mensaje: response.data['mensaje'] as String? ??
              'Error al iniciar cambio de teléfono',
          datos: null,
          fechaHora: DateTime.now().toIso8601String(),
        );
      }
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error de conexión',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

  /// Verifica el PIN del teléfono anterior
  /// Si es correcto, envía código al teléfono nuevo
  Future<ApiRespuesta<VerificarPinAnteriorRespuestaDto>> verificarPinAnterior(
      VerificarPinAnteriorDto dto,
      ) async {
    try {
      final response = await _dio.post(
        '/perfil/telefono/verificar-anterior',
        data: dto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['datos'] as Map<String, dynamic>;
        final respuestaDto = VerificarPinAnteriorRespuestaDto.fromJson(data);

        return ApiRespuesta(
          codigoEstado: response.statusCode!,
          mensaje: response.data['mensaje'] as String? ?? 'OK',
          datos: respuestaDto,
          fechaHora: DateTime.now().toIso8601String(),
        );
      } else {
        return ApiRespuesta(
          codigoEstado: response.statusCode ?? 500,
          mensaje: response.data['mensaje'] as String? ??
              'Error al verificar código',
          datos: null,
          fechaHora: DateTime.now().toIso8601String(),
        );
      }
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error de conexión',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

  /// Verifica el PIN del teléfono nuevo
  /// Completa el proceso y actualiza el teléfono en la BD
  Future<ApiRespuesta<VerificarPinNuevoRespuestaDto>> verificarPinNuevo(
      VerificarPinNuevoDto dto,
      ) async {
    try {
      final response = await _dio.post(
        '/perfil/telefono/verificar-nuevo',
        data: dto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['datos'] as Map<String, dynamic>;
        final respuestaDto = VerificarPinNuevoRespuestaDto.fromJson(data);

        return ApiRespuesta(
          codigoEstado: response.statusCode!,
          mensaje: response.data['mensaje'] as String? ?? 'OK',
          datos: respuestaDto,
          fechaHora: DateTime.now().toIso8601String(),
        );
      } else {
        return ApiRespuesta(
          codigoEstado: response.statusCode ?? 500,
          mensaje: response.data['mensaje'] as String? ??
              'Error al verificar código',
          datos: null,
          fechaHora: DateTime.now().toIso8601String(),
        );
      }
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error de conexión',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

  /// Reenvía el código al teléfono anterior
  Future<ApiRespuesta<void>> reenviarCodigoAnterior(int idCambioTelefono) async {
    try {
      final response = await _dio.post(
        '/perfil/telefono/reenviar-anterior',
        data: {'idCambioTelefono': idCambioTelefono},
      );

      return ApiRespuesta(
        codigoEstado: response.statusCode!,
        mensaje: response.data['mensaje'] as String? ??
            'Código reenviado',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error al reenviar código',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

  /// Reenvía el código al teléfono nuevo
  Future<ApiRespuesta<void>> reenviarCodigoNuevo(int idCambioTelefono) async {
    try {
      final response = await _dio.post(
        '/perfil/telefono/reenviar-nuevo',
        data: {'idCambioTelefono': idCambioTelefono},
      );

      return ApiRespuesta(
        codigoEstado: response.statusCode!,
        mensaje: response.data['mensaje'] as String? ??
            'Código reenviado',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error al reenviar código',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }
}