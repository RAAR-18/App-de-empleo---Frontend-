import 'package:oasis/domain/repository/datos_basicos_repositorio.dart';
import 'package:oasis/domain/repository/archivo_repositorio.dart';
import 'package:oasis/domain/repository/imagen_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_palabras_clave_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_talentos_usuario_caso_uso.dart';
import 'package:oasis/domain/model/progreso_perfil.dart';

class CalcularProgresoPerfilCasoUso {
  final DatosBasicosRepository _datosBasicosRepo;
  final ArchivoRepositorio _archivoRepo;
  final ImagenRepository _imagenRepo;
  final ObtenerPalabrasClaveCasoUso _obtenerPalabrasClaveCasoUso;
  final ObtenerTalentosUsuarioCasoUso _obtenerTalentosCasoUso;

  CalcularProgresoPerfilCasoUso({
    required DatosBasicosRepository datosBasicosRepo,
    required ArchivoRepositorio archivoRepo,
    required ImagenRepository imagenRepo,
    required ObtenerPalabrasClaveCasoUso obtenerPalabrasClaveCasoUso,
    required ObtenerTalentosUsuarioCasoUso obtenerTalentosCasoUso,
  })  : _datosBasicosRepo = datosBasicosRepo,
        _archivoRepo = archivoRepo,
        _imagenRepo = imagenRepo,
        _obtenerPalabrasClaveCasoUso = obtenerPalabrasClaveCasoUso,
        _obtenerTalentosCasoUso = obtenerTalentosCasoUso;

  Future<ProgresoPerfil> call(int idUsuario) async {
    try {
      final resultados = await Future.wait([
        _verificarDatosBasicos(idUsuario),
        _verificarPalabrasClave(idUsuario),
        _verificarCompetencias(idUsuario),
        _verificarCV(idUsuario),
        _verificarFotoPerfil(idUsuario),
      ]);

      final progreso = ProgresoPerfil(
        tieneDatosBasicos: resultados[0],
        tienePalabrasClave: resultados[1],
        tieneCompetencias: resultados[2],
        tieneCV: resultados[3],
        tieneFotoPerfil: resultados[4],
      );
      return progreso;
    } catch (e) {
      return const ProgresoPerfil(
        tieneDatosBasicos: false,
        tienePalabrasClave: false,
        tieneCompetencias: false,
        tieneCV: false,
        tieneFotoPerfil: false,
      );
    }
  }

  // Verifica que los datos básicos estén completos
  Future<bool> _verificarDatosBasicos(int idUsuario) async {
    try {
      final datosBasicos = await _datosBasicosRepo.obtenerDatosBasicos(idUsuario);

      final tieneNombres = datosBasicos.nombresUsuario.trim().isNotEmpty;
      final tieneApellidos = datosBasicos.apellidosUsuario.trim().isNotEmpty;
      final tieneDocumento = datosBasicos.documentoUsuario.trim().isNotEmpty;
      final tieneProfesion = datosBasicos.profesion.trim().isNotEmpty;
      final tieneUbicacion = datosBasicos.ubicacion.trim().isNotEmpty;

      final completo = tieneNombres &&
          tieneApellidos &&
          tieneDocumento &&
          tieneProfesion &&
          tieneUbicacion;

      return completo;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _verificarPalabrasClave(int idUsuario) async {
    try {
      final palabras = await _obtenerPalabrasClaveCasoUso(idUsuario);
      final completo = palabras.length >= 3;
      return completo;
    } catch (e) {
      return false;
    }
  }

  // Verifica que tenga al menos 3 competencias/habilidades
  Future<bool> _verificarCompetencias(int idUsuario) async {
    try {
      final talentos = await _obtenerTalentosCasoUso(idUsuario);
      final completo = talentos.length >= 3;
      return completo;
    } catch (e) {
      return false;
    }
  }

  // Verifica que tenga CV subido
  Future<bool> _verificarCV(int idUsuario) async {
    try {
      final cv = await _archivoRepo.obtenerCV(idUsuario);
      final completo = cv != null;
      return completo;
    } catch (e) {
      return false;
    }
  }

  // Verifica que tenga foto de perfil (categoría = 1)
  Future<bool> _verificarFotoPerfil(int idUsuario) async {
    try {
      final foto = await _imagenRepo.obtenerFotoPerfil(idUsuario);
      final completo = foto != null && foto.isNotEmpty;
      return completo;
    } catch (e) {
      return false;
    }
  }
}