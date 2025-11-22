import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/model/verificacion_correo.dart';
import 'package:oasis/domain/usecase/enviar_codigo_verificacion_caso_uso.dart';
import 'package:oasis/domain/usecase/verificar_codigo_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_estado_verificacion_caso_uso.dart';

import '../core/di/providers.dart';

class VerificacionCorreoState {
  final bool isLoading;
  final String? error;
  final VerificacionCorreo? verificacion;
  final bool codigoEnviado;
  final bool codigoVerificado;

  VerificacionCorreoState({
    this.isLoading = false,
    this.error,
    this.verificacion,
    this.codigoEnviado = false,
    this.codigoVerificado = false,
  });

  VerificacionCorreoState copyWith({
    bool? isLoading,
    String? error,
    VerificacionCorreo? verificacion,
    bool? codigoEnviado,
    bool? codigoVerificado,
  }) {
    return VerificacionCorreoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verificacion: verificacion ?? this.verificacion,
      codigoEnviado: codigoEnviado ?? this.codigoEnviado,
      codigoVerificado: codigoVerificado ?? this.codigoVerificado,
    );
  }
}

class VerificacionCorreoNotifier extends StateNotifier<VerificacionCorreoState> {
  final EnviarCodigoVerificacionCasoUso _enviarCodigoCasoUso;
  final VerificarCodigoCasoUso _verificarCodigoCasoUso;
  final ObtenerEstadoVerificacionCasoUso _obtenerEstadoCasoUso;
  final Ref _ref;

  VerificacionCorreoNotifier({
    required EnviarCodigoVerificacionCasoUso enviarCodigoCasoUso,
    required VerificarCodigoCasoUso verificarCodigoCasoUso,
    required ObtenerEstadoVerificacionCasoUso obtenerEstadoCasoUso,
    required Ref ref,
  })  : _enviarCodigoCasoUso = enviarCodigoCasoUso,
        _verificarCodigoCasoUso = verificarCodigoCasoUso,
        _obtenerEstadoCasoUso = obtenerEstadoCasoUso,
        _ref = ref,
        super(VerificacionCorreoState());

  Future<void> obtenerEstado(String correo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final verificacion = await _obtenerEstadoCasoUso(correo);

      await _actualizarEstadoVerificacion(verificacion.estadoVerificacion ?? 1);

      state = state.copyWith(
        isLoading: false,
        verificacion: verificacion,
        codigoVerificado: verificacion.estaVerificado,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> enviarCodigo(String correo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final verificacion = await _enviarCodigoCasoUso(correo);

      await _actualizarEstadoVerificacion(verificacion.estadoVerificacion ?? 2);

      state = state.copyWith(
        isLoading: false,
        verificacion: verificacion,
        codigoEnviado: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> verificarCodigo(String correo, String codigo) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final verificacion = await _verificarCodigoCasoUso(correo, codigo);

      await _actualizarEstadoVerificacion(verificacion.estadoVerificacion ?? 3);

      state = state.copyWith(
        isLoading: false,
        verificacion: verificacion,
        codigoVerificado: verificacion.estaVerificado,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetCodigoEnviado() {
    state = state.copyWith(codigoEnviado: false);
  }

  Future<void> _actualizarEstadoVerificacion(int estadoVerificacion) async {
    _ref.invalidate(accesoInfoProvider);
  }
}