import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/usecase/iniciar_cambio_telefono_caso_uso.dart';
import 'package:oasis/domain/usecase/reenviar_codigo_anterior_caso_uso.dart';
import 'package:oasis/domain/usecase/reenviar_codigo_nuevo_caso_uso.dart';
import 'package:oasis/domain/usecase/verificar_pin_anterior_caso_uso.dart';
import 'package:oasis/domain/usecase/verificar_pin_nuevo_caso_uso.dart';

enum CambioTelefonoStep {
  inicial,
  verificandoAnterior,
  verificandoNuevo,
  completado,
}

// Estado del proceso de cambio de teléfono
class CambioTelefonoState {
  final CambioTelefonoStep step;
  final bool isLoading;
  final String? error;
  final int? idCambioTelefono;
  final String? telefonoAnterior; // Enmascarado
  final String? telefonoNuevo;     // Enmascarado
  final String? mensaje;

  CambioTelefonoState({
    this.step = CambioTelefonoStep.inicial,
    this.isLoading = false,
    this.error,
    this.idCambioTelefono,
    this.telefonoAnterior,
    this.telefonoNuevo,
    this.mensaje,
  });

  CambioTelefonoState copyWith({
    CambioTelefonoStep? step,
    bool? isLoading,
    String? error,
    int? idCambioTelefono,
    String? telefonoAnterior,
    String? telefonoNuevo,
    String? mensaje,
  }) {
    return CambioTelefonoState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      idCambioTelefono: idCambioTelefono ?? this.idCambioTelefono,
      telefonoAnterior: telefonoAnterior ?? this.telefonoAnterior,
      telefonoNuevo: telefonoNuevo ?? this.telefonoNuevo,
      mensaje: mensaje ?? this.mensaje,
    );
  }

  CambioTelefonoState clearError() {
    return copyWith(error: '');
  }
}

// Notifier para gestionar el proceso de cambio de teléfono
class CambioTelefonoNotifier extends StateNotifier<CambioTelefonoState> {
  final IniciarCambioTelefonoCasoUso _iniciarCambioUseCase;
  final VerificarPinAnteriorCasoUso _verificarAnteriorUseCase;
  final VerificarPinNuevoCasoUso _verificarNuevoUseCase;
  final ReenviarCodigoAnteriorCasoUso _reenviarAnteriorUseCase;
  final ReenviarCodigoNuevoCasoUso _reenviarNuevoUseCase;

  CambioTelefonoNotifier({
    required IniciarCambioTelefonoCasoUso iniciarCambioUseCase,
    required VerificarPinAnteriorCasoUso verificarAnteriorUseCase,
    required VerificarPinNuevoCasoUso verificarNuevoUseCase,
    required ReenviarCodigoAnteriorCasoUso reenviarAnteriorUseCase,
    required ReenviarCodigoNuevoCasoUso reenviarNuevoUseCase,
  })  : _iniciarCambioUseCase = iniciarCambioUseCase,
        _verificarAnteriorUseCase = verificarAnteriorUseCase,
        _verificarNuevoUseCase = verificarNuevoUseCase,
        _reenviarAnteriorUseCase = reenviarAnteriorUseCase,
        _reenviarNuevoUseCase = reenviarNuevoUseCase,
        super(CambioTelefonoState());

  // Inicia el proceso de cambio de teléfono
  Future<void> iniciarCambio({
    required int idUsuario,
    required String telefonoNuevo,
  }) async {
    state = state.copyWith(isLoading: true, error: '');

    try {
      final response = await _iniciarCambioUseCase(
        idUsuario: idUsuario,
        telefonoNuevo: telefonoNuevo,
      );

      state = state.copyWith(
        step: CambioTelefonoStep.verificandoAnterior,
        isLoading: false,
        idCambioTelefono: response.idCambioTelefono,
        telefonoAnterior: response.telefonoAnterior,
        telefonoNuevo: response.telefonoNuevo,
        mensaje: response.mensaje,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Verifica el código del teléfono anterior
  Future<void> verificarPinAnterior(String pinAnterior) async {
    if (state.idCambioTelefono == null) {
      state = state.copyWith(
        error: 'No hay proceso de cambio activo',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: '');

    try {
      final response = await _verificarAnteriorUseCase(
        idCambioTelefono: state.idCambioTelefono!,
        pinAnterior: pinAnterior,
      );

      if (response.verificado) {
        state = state.copyWith(
          step: CambioTelefonoStep.verificandoNuevo,
          isLoading: false,
          mensaje: response.mensaje,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.mensaje,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Verifica el código del teléfono nuevo y completa el proceso
  Future<void> verificarPinNuevo(String pinNuevo) async {
    if (state.idCambioTelefono == null) {
      state = state.copyWith(
        error: 'No hay proceso de cambio activo',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: '');

    try {
      final response = await _verificarNuevoUseCase(
        idCambioTelefono: state.idCambioTelefono!,
        pinNuevo: pinNuevo,
      );

      if (response.verificado && response.cambioCompletado) {
        state = state.copyWith(
          step: CambioTelefonoStep.completado,
          isLoading: false,
          mensaje: response.mensaje,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.mensaje,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Reenvía el código al teléfono anterior
  Future<void> reenviarCodigoAnterior() async {
    if (state.idCambioTelefono == null) {
      state = state.copyWith(
        error: 'No hay proceso de cambio activo',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: '');

    try {
      await _reenviarAnteriorUseCase(state.idCambioTelefono!);

      state = state.copyWith(
        isLoading: false,
        mensaje: 'Código reenviado al teléfono anterior',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Reenvía el código al teléfono nuevo
  Future<void> reenviarCodigoNuevo() async {
    if (state.idCambioTelefono == null) {
      state = state.copyWith(
        error: 'No hay proceso de cambio activo',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: '');

    try {
      await _reenviarNuevoUseCase(state.idCambioTelefono!);

      state = state.copyWith(
        isLoading: false,
        mensaje: 'Código reenviado al teléfono nuevo',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Reinicia el proceso
  void reset() {
    state = CambioTelefonoState();
  }

  // Limpia el error
  void clearError() {
    state = state.clearError();
  }
}

