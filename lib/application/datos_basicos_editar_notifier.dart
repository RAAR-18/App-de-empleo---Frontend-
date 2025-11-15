import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/model/datos_basicos.dart';
import 'package:oasis/domain/usecase/actualizar_datos_basicos_caso_uso.dart';

enum EdicionEstado {
  inicial,
  editando,
  guardando,
  exito,
  error,
}

class DatosBasicosEdicionState {
  final EdicionEstado estado;
  final DatosBasicos? datosOriginales;
  final DatosBasicos? datosEditados;
  final String? mensajeError;

  const DatosBasicosEdicionState({
    required this.estado,
    this.datosOriginales,
    this.datosEditados,
    this.mensajeError,
  });

  /// Estado inicial
  factory DatosBasicosEdicionState.inicial() {
    return const DatosBasicosEdicionState(
      estado: EdicionEstado.inicial,
    );
  }

  /// Iniciar edición
  DatosBasicosEdicionState iniciarEdicion(DatosBasicos datos) {
    return DatosBasicosEdicionState(
      estado: EdicionEstado.editando,
      datosOriginales: datos,
      datosEditados: datos,
    );
  }

  /// Actualizar campo
  DatosBasicosEdicionState actualizarCampo(DatosBasicos nuevoDatos) {
    return DatosBasicosEdicionState(
      estado: EdicionEstado.editando,
      datosOriginales: datosOriginales,
      datosEditados: nuevoDatos,
    );
  }

  /// Guardando
  DatosBasicosEdicionState guardando() {
    return DatosBasicosEdicionState(
      estado: EdicionEstado.guardando,
      datosOriginales: datosOriginales,
      datosEditados: datosEditados,
    );
  }

  /// Éxito
  DatosBasicosEdicionState exito() {
    return DatosBasicosEdicionState(
      estado: EdicionEstado.exito,
      datosOriginales: datosEditados,
      datosEditados: datosEditados,
    );
  }

  /// Error
  DatosBasicosEdicionState error(String mensaje) {
    return DatosBasicosEdicionState(
      estado: EdicionEstado.error,
      datosOriginales: datosOriginales,
      datosEditados: datosEditados,
      mensajeError: mensaje,
    );
  }

  /// Cancelar edición
  DatosBasicosEdicionState cancelar() {
    return const DatosBasicosEdicionState(
      estado: EdicionEstado.inicial,
    );
  }

  /// Verificar si hay cambios
  bool get hayCambios {
    if (datosOriginales == null || datosEditados == null) return false;

    return datosOriginales!.nombresUsuario != datosEditados!.nombresUsuario ||
        datosOriginales!.apellidosUsuario != datosEditados!.apellidosUsuario ||
        datosOriginales!.documentoUsuario != datosEditados!.documentoUsuario ||
        datosOriginales!.profesion != datosEditados!.profesion ||
        datosOriginales!.idUbicacion != datosEditados!.idUbicacion;
  }
}

/// Notifier para manejar la edición de datos básicos
class DatosBasicosEdicionNotifier
    extends StateNotifier<DatosBasicosEdicionState> {
  final ActualizarDatosBasicosCasoUso _actualizarDatosBasicosCasoUso;

  DatosBasicosEdicionNotifier(this._actualizarDatosBasicosCasoUso)
      : super(DatosBasicosEdicionState.inicial());

  /// Iniciar modo edición
  void iniciarEdicion(DatosBasicos datos) {
    state = state.iniciarEdicion(datos);
  }

  /// Actualizar nombres
  void actualizarNombres(String nombres) {
    if (state.datosEditados == null) return;
    state = state.actualizarCampo(
      state.datosEditados!.copyWith(nombresUsuario: nombres),
    );
  }

  /// Actualizar apellidos
  void actualizarApellidos(String apellidos) {
    if (state.datosEditados == null) return;
    state = state.actualizarCampo(
      state.datosEditados!.copyWith(apellidosUsuario: apellidos),
    );
  }

  /// Actualizar documento
  void actualizarDocumento(String documento) {
    if (state.datosEditados == null) return;
    state = state.actualizarCampo(
      state.datosEditados!.copyWith(documentoUsuario: documento),
    );
  }

  /// Actualizar profesión
  void actualizarProfesion(String profesion) {
    if (state.datosEditados == null) return;
    state = state.actualizarCampo(
      state.datosEditados!.copyWith(profesion: profesion),
    );
  }

  /// Actualizar ubicación
  void actualizarUbicacion(int idUbicacion, String nombreUbicacion) {
    if (state.datosEditados == null) return;
    state = state.actualizarCampo(
      state.datosEditados!.copyWith(
        idUbicacion: idUbicacion,
        ubicacion: nombreUbicacion,
      ),
    );
  }

  /// Guardar cambios
  Future<void> guardarCambios() async {
    if (state.datosEditados == null) return;
    if (!state.hayCambios) {
      state = state.cancelar();
      return;
    }

    state = state.guardando();

    try {
      await _actualizarDatosBasicosCasoUso(state.datosEditados!);
      state = state.exito();
    } catch (e) {
      state = state.error(e.toString());
    }
  }

  /// Cancelar edición
  void cancelar() {
    state = state.cancelar();
  }

  /// Limpiar estado de error/éxito
  void limpiarEstado() {
    if (state.estado == EdicionEstado.exito ||
        state.estado == EdicionEstado.error) {
      state = DatosBasicosEdicionState.inicial();
    }
  }
}