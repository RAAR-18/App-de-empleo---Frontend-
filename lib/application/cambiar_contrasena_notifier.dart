import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/usecase/cambiar_contrasena_caso_uso.dart';

class CambiarContrasenaState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  CambiarContrasenaState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  CambiarContrasenaState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return CambiarContrasenaState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class CambiarContrasenaNotifier extends StateNotifier<CambiarContrasenaState> {
  final CambiarContrasenaCasoUso cambiarContrasenaCasoUso;

  CambiarContrasenaNotifier(this.cambiarContrasenaCasoUso)
      : super(CambiarContrasenaState());

  Future<void> cambiarContrasena(
      String contrasenaActual,
      String contrasenaNueva,
      ) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      await cambiarContrasenaCasoUso(contrasenaActual, contrasenaNueva);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  void reset() {
    state = CambiarContrasenaState();
  }
}