import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/model/imagen_portafolio.dart';
import 'package:oasis/domain/usecase/obtener_portafolio_caso_uso.dart';
import 'package:oasis/domain/usecase/subir_imagen_portafolio_caso_uso.dart';
import 'package:oasis/domain/usecase/eliminar_imagen_portafolio_caso_uso.dart';

// Estado del portafolio
class PortafolioState {
  final List<ImagenPortafolio> imagenes;
  final int totalProyectos;
  final int limiteMaximo;
  final bool isLoading;
  final String? error;
  final bool modoEdicion;

  const PortafolioState({
    this.imagenes = const [],
    this.totalProyectos = 0,
    this.limiteMaximo = 5,
    this.isLoading = false,
    this.error,
    this.modoEdicion = false,
  });

  bool get puedeAgregarMas => totalProyectos < limiteMaximo;
  int get espaciosRestantes => limiteMaximo - totalProyectos;

  PortafolioState copyWith({
    List<ImagenPortafolio>? imagenes,
    int? totalProyectos,
    int? limiteMaximo,
    bool? isLoading,
    String? error,
    bool? modoEdicion,
  }) {
    return PortafolioState(
      imagenes: imagenes ?? this.imagenes,
      totalProyectos: totalProyectos ?? this.totalProyectos,
      limiteMaximo: limiteMaximo ?? this.limiteMaximo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      modoEdicion: modoEdicion ?? this.modoEdicion,
    );
  }
}

// Notifier
class PortafolioNotifier extends StateNotifier<PortafolioState> {
  final ObtenerPortafolioCasoUso _obtenerPortafolioCasoUso;
  final SubirImagenPortafolioCasoUso _subirImagenPortafolioCasoUso;
  final EliminarImagenPortafolioCasoUso _eliminarImagenPortafolioCasoUso;

  PortafolioNotifier({
    required ObtenerPortafolioCasoUso obtenerPortafolioCasoUso,
    required SubirImagenPortafolioCasoUso subirImagenPortafolioCasoUso,
    required EliminarImagenPortafolioCasoUso eliminarImagenPortafolioCasoUso,
  })  : _obtenerPortafolioCasoUso = obtenerPortafolioCasoUso,
        _subirImagenPortafolioCasoUso = subirImagenPortafolioCasoUso,
        _eliminarImagenPortafolioCasoUso = eliminarImagenPortafolioCasoUso,
        super(const PortafolioState());

  /// Carga el portafolio del usuario
  Future<void> cargarPortafolio(int idUsuario) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final resultado = await _obtenerPortafolioCasoUso(idUsuario);
      final imagenes = resultado['imagenes'] as List<ImagenPortafolio>;
      final totalProyectos = resultado['totalProyectos'] as int;
      final limiteMaximo = resultado['limiteMaximo'] as int;

      state = state.copyWith(
        imagenes: imagenes,
        totalProyectos: totalProyectos,
        limiteMaximo: limiteMaximo,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        imagenes: [],
        totalProyectos: 0,
      );
    }
  }

  /// Sube una nueva imagen al portafolio
  Future<bool> subirImagen(
      int idUsuario,
      String rutaArchivo,
      String nombreProyecto,
      ) async {
    if (!state.puedeAgregarMas) {
      state = state.copyWith(
        error: 'Has alcanzado el límite de ${state.limiteMaximo} imágenes',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _subirImagenPortafolioCasoUso(idUsuario, rutaArchivo, nombreProyecto);
      await cargarPortafolio(idUsuario);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Elimina una imagen del portafolio
  Future<bool> eliminarImagen(int idImagen, int idUsuario) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _eliminarImagenPortafolioCasoUso(idImagen);
      await cargarPortafolio(idUsuario);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Alterna el modo de edición
  void toggleModoEdicion() {
    state = state.copyWith(modoEdicion: !state.modoEdicion);
  }

  /// Limpia el error
  void limpiarError() {
    state = state.copyWith(error: null);
  }
}