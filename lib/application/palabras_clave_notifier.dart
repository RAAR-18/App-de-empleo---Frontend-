import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/usecase/obtener_palabras_clave_caso_uso.dart';
import 'package:oasis/domain/usecase/agregar_palabras_clave_caso_uso.dart';

/// Estado para la gestión de palabras clave
class PalabrasClaveState {
  // Palabras clave del usuario (las que ya tiene asignadas)
  final List<PalabraClave> palabrasUsuario;

  // IDs de palabras seleccionadas para guardar
  final List<int> idsSeleccionados;

  // Texto de búsqueda actual
  final String textoBusqueda;

  final bool isLoading;
  final bool isSaving;
  final String? error;

  PalabrasClaveState({
    this.palabrasUsuario = const [],
    this.idsSeleccionados = const [],
    this.textoBusqueda = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  PalabrasClaveState copyWith({
    List<PalabraClave>? palabrasUsuario,
    List<int>? idsSeleccionados,
    String? textoBusqueda,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return PalabrasClaveState(
      palabrasUsuario: palabrasUsuario ?? this.palabrasUsuario,
      idsSeleccionados: idsSeleccionados ?? this.idsSeleccionados,
      textoBusqueda: textoBusqueda ?? this.textoBusqueda,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

// Notifier para gestionar palabras clave del usuario
class PalabrasClaveNotifier extends StateNotifier<PalabrasClaveState> {
  final ObtenerPalabrasClaveCasoUso obtenerPalabrasClaveCasoUso;
  final AgregarPalabrasClavesCasoUso agregarPalabrasClavesCasoUso;

  PalabrasClaveNotifier({
    required this.obtenerPalabrasClaveCasoUso,
    required this.agregarPalabrasClavesCasoUso,
  }) : super(PalabrasClaveState());

  // Cargar palabras clave actuales del usuario
  Future<void> cargarPalabrasClave(int idUsuario) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final palabras = await obtenerPalabrasClaveCasoUso(idUsuario);

      // Inicializar los IDs seleccionados con las palabras que ya tiene
      final idsActuales = palabras.map((p) => p.idPalabraClave).toList();

      state = state.copyWith(
        palabrasUsuario: palabras,
        idsSeleccionados: idsActuales,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar palabras clave: ${e.toString()}',
      );
    }
  }

  // Actualizar el texto de búsqueda
  void actualizarTextoBusqueda(String texto) {
    state = state.copyWith(textoBusqueda: texto, error: null);
  }

  // Limpiar búsqueda
  void limpiarBusqueda() {
    state = state.copyWith(textoBusqueda: '', error: null);
  }

  // Agregar una palabra clave por ID
  void agregarPalabraClave(int idPalabraClave) {
    if (!state.idsSeleccionados.contains(idPalabraClave)) {
      final idsActuales = [...state.idsSeleccionados, idPalabraClave];
      state = state.copyWith(idsSeleccionados: idsActuales, error: null);
    }
  }

  // Eliminar una palabra clave por ID
  void eliminarPalabraClave(int idPalabraClave) {
    final idsActuales = [...state.idsSeleccionados];
    idsActuales.remove(idPalabraClave);
    state = state.copyWith(idsSeleccionados: idsActuales, error: null);
  }

  // Alternar selección de una palabra clave (agregar o quitar del array de IDs)
  void togglePalabraClave(int idPalabraClave) {
    final idsActuales = [...state.idsSeleccionados];

    if (idsActuales.contains(idPalabraClave)) {
      idsActuales.remove(idPalabraClave);
    } else {
      idsActuales.add(idPalabraClave);
    }

    state = state.copyWith(idsSeleccionados: idsActuales, error: null);
  }

  // Guardar cambios (enviar IDs al backend)
  Future<bool> guardarCambios(int idUsuario) async {
    // Validar que haya al menos una palabra seleccionada
    if (state.idsSeleccionados.isEmpty) {
      state = state.copyWith(
        error: 'Debes seleccionar al menos una palabra clave',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      await agregarPalabrasClavesCasoUso(idUsuario, state.idsSeleccionados);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Error al guardar: ${e.toString()}',
      );
      return false;
    }
  }

  void limpiarError() {
    state = state.copyWith(error: null);
  }
}