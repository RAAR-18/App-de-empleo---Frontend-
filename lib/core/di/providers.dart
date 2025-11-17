import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:oasis/data/remote/acceso_api.dart";
import "package:oasis/data/remote/pin_api.dart";
import "package:oasis/data/remote/registro_api.dart";
import "package:oasis/data/repository/acceso_repositorio_impl.dart";
import "package:oasis/data/repository/pin_repositorio_impl.dart";
import "package:oasis/data/repository/registro_repositorio_impl.dart";
import "package:oasis/domain/model/acceso_sesion.dart";
import "package:oasis/application/sesion_notifier.dart";
import "package:oasis/domain/repository/acceso_repositorio.dart";
import "package:oasis/domain/repository/pin_repositorio.dart";
import "package:oasis/domain/repository/registro_repositorio.dart";
import "package:oasis/domain/usecase/acceso_caso_uso.dart";
import "package:oasis/domain/usecase/actualizar_datos_basicos_caso_uso.dart";
import "package:oasis/domain/usecase/pin_caso_uso.dart";
import "package:oasis/domain/usecase/registro_caso_uso.dart";

import "package:oasis/data/remote/vacante_api.dart";
import "package:oasis/data/repository/vacante_repositorio_impl.dart";
import "package:oasis/domain/repository/vacante_repository.dart";
import "package:oasis/domain/usecase/vacante_caso_uso.dart";

import "package:oasis/data/remote/chat_api.dart";
import "package:oasis/data/repository/chat_repositorio_impl.dart";
import "package:oasis/domain/repository/chat_repositorio.dart";
import "package:oasis/domain/usecase/chat_caso_uso.dart";

import "package:oasis/core/util/websocket_service.dart";

import 'package:oasis/data/remote/perfil_api.dart';
import 'package:oasis/data/repository/perfil_repositorio_impl.dart';
import 'package:oasis/domain/repository/perfil_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_perfil_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_palabras_clave_caso_uso.dart';

import "package:oasis/domain/model/palabra_clave.dart";
import 'package:oasis/data/remote/palabra_clave_api.dart';
import 'package:oasis/data/repository/palabra_clave_repositorio_impl.dart';
import 'package:oasis/domain/repository/palabra_clave_repositorio.dart';
import 'package:oasis/domain/usecase/agregar_palabras_clave_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_catalogo_palabra_clave_caso_uso.dart';
import 'package:oasis/application/palabras_clave_notifier.dart';

import 'package:oasis/data/remote/datos_basicos_api.dart';
import 'package:oasis/data/repository/datos_basicos_repositorio.impl.dart';
import 'package:oasis/domain/repository/datos_basicos_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_datos_basicos_caso_uso.dart';
import 'package:oasis/application/datos_basicos_editar_notifier.dart';

import 'package:oasis/data/remote/imagen_api.dart';
import 'package:oasis/data/remote/ubicacion_api.dart';
import 'package:oasis/data/repository/imagen_repositorio_impl.dart';
import 'package:oasis/data/repository/ubicacion_repositorio_impl.dart';
import 'package:oasis/domain/repository/imagen_repositorio.dart';
import 'package:oasis/domain/repository/ubicacion_repositorio.dart';
import 'package:oasis/domain/usecase/subir_foto_perfil_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_foto_perfil_caso_uso.dart';
import 'package:oasis/domain/usecase/buscar_ubicaciones_caso_uso.dart';

import 'package:oasis/data/remote/archivo_api.dart';
import 'package:oasis/data/repository/archivo_repositorio_impl.dart';
import 'package:oasis/domain/model/archivo.dart';
import 'package:oasis/domain/repository/archivo_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_archivo_caso_uso.dart';
import 'package:oasis/domain/usecase/descargar_archivo_caso_uso.dart';
import 'package:oasis/domain/usecase/subir_archivo_caso_uso.dart';

import 'package:oasis/data/remote/talento_api.dart';
import 'package:oasis/data/repository/talento_repositorio_impl.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_talentos_usuario_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_estadisticas_talentos_caso_uso.dart';
import 'package:oasis/domain/usecase/obtener_catalogo_talentos_caso_uso.dart';
import 'package:oasis/domain/usecase/agregar_talento_caso_uso.dart';
import 'package:oasis/domain/usecase/editar_nivel_talento_caso_uso.dart';
import 'package:oasis/domain/usecase/eliminar_talento_caso_uso.dart';
import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/model/talento.dart';
import 'package:oasis/domain/model/talento_estadisticas.dart';

import 'package:oasis/data/remote/portafolio_api.dart';
import 'package:oasis/data/repository/portafolio_repositorio_impl.dart';
import 'package:oasis/domain/repository/portafolio_repositorio.dart';
import 'package:oasis/domain/usecase/obtener_portafolio_caso_uso.dart';
import 'package:oasis/domain/usecase/subir_imagen_portafolio_caso_uso.dart';
import 'package:oasis/domain/usecase/eliminar_imagen_portafolio_caso_uso.dart';

import 'package:oasis/application/portafolio_notifier.dart';

import '../../domain/model/progreso_perfil.dart';
import '../../domain/usecase/calcular_progreso_perfil_caso_uso.dart';



final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    // 🔴 PRODUCCIÓN: Backend del profesor
    // baseUrl: "https://propocol.backcoreunimag.com/",

    // 🟢 DESARROLLO: Backend local proColombia (comentado)
     baseUrl: "http://localhost:3210/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    validateStatus: (status) => true,
  );

  final dio = Dio(options);

  // Logs
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  // Interceptor para Authorization (excluyendo endpoints de autenticación)
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // No agregar token a endpoints de autenticación
        final excludedPaths = ['auth/login', 'auth/register', 'auth/pin'];
        final isAuthEndpoint = excludedPaths.any(
          (path) => options.path.contains(path),
        );

        if (!isAuthEndpoint) {
          // Agregar token de sesión a peticiones autenticadas
          final session = ref.read(sessionProvider);
          final token = session.token;
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});

// *****************************************************************************

final authApiProvider = Provider<AccesoApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AccesoApi(dio);
});

final sessionProvider = StateNotifierProvider<SesionNotifier, AccesoSesion>(
  (ref) => SesionNotifier(),
);

final authRepositoryProvider = Provider<AccesoRepositorio>((ref) {
  final api = ref.watch(authApiProvider);
  return AccesoRepositorioImpl(api);
});

final loginUseCaseProvider = Provider<AccesoCasoUso>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AccesoCasoUso(repo);
});

// *****************************************************************************

/// Provider de PinApi
final pinApiProvider = Provider<PinApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PinApi(dio);
});

/// Provider de PinRepositorio
final pinRepositoryProvider = Provider<PinRepositorio>((ref) {
  final api = ref.watch(pinApiProvider);
  return PinRepositorioImpl(api);
});

/// Provider de SolicitarPinUseCase
final solicitarPinUseCaseProvider = Provider<PinCasoUso>((ref) {
  final repo = ref.watch(pinRepositoryProvider);
  return PinCasoUso(repo);
});

// *****************************************************************************

final registroApiProvider = Provider<RegistroApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RegistroApi(dio);
});

final registroRepositoryProvider = Provider<RegistroRepositorio>((ref) {
  final api = ref.watch(registroApiProvider);
  return RegistroRepositorioImpl(api);
});

final registroUseCaseProvider = Provider<RegistroCasoUso>((ref) {
  final repo = ref.watch(registroRepositoryProvider);
  return RegistroCasoUso(repo);
});

// *****************************************************************************
/// Provider de VacanteApi
final vacanteApiProvider = Provider<VacanteApi>((ref) {
  final dio = ref.watch(dioProvider);
  return VacanteApi(dio);
});

/// Provider de VacanteRepositorio
final vacanteRepositoryProvider = Provider<VacanteRepositorio>((ref) {
  final api = ref.watch(vacanteApiProvider);
  return VacanteRepositorioImpl(api);
});

/// Provider de VacanteCasoUso
final vacanteUseCaseProvider = Provider<VacanteCasoUso>((ref) {
  final repo = ref.watch(vacanteRepositoryProvider);
  return VacanteCasoUso(repo);
});

// *****************************************************************************
/// PROVIDERS DE CHAT

/// StateProvider para almacenar la URL del backend de chat
/// Se actualiza desde ChatTestScreen cuando el usuario configura la URL
final chatBackendUrlProvider = StateProvider<String>((ref) {
  // Valor por defecto (PRODUCCIÓN)
  return "https://propocol.backcoreunimag.com";

  // DESARROLLO (comentado)
  // return "http://localhost:3210";
});

/// Provider de Dio para Chat CON autenticación
/// Usa la URL configurada en chatBackendUrlProvider
/// Incluye el token JWT en todas las peticiones
final dioChatProvider = Provider<Dio>((ref) {
  // Obtener la URL del backend del StateProvider
  final baseUrl = ref.watch(chatBackendUrlProvider);

  // Asegurar que la URL termine con /
  final urlNormalizada = baseUrl.endsWith("/") ? baseUrl : "$baseUrl/";

  final options = BaseOptions(
    baseUrl: urlNormalizada,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    validateStatus: (status) => true,
  );

  final dio = Dio(options);

  // Interceptor para agregar token de autenticación
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Obtener token de la sesión
        final session = ref.read(sessionProvider);
        final token = session.token;
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ),
  );

  // LOGS para debugging (comentado en producción)
  // dio.interceptors.add(LogInterceptor(
  //   requestBody: true,
  //   responseBody: true,
  //   error: true,
  //   requestHeader: true,
  //   responseHeader: false,
  // ));

  return dio;
});

/// Provider de ChatApi (usa dioChatProvider)
final chatApiProvider = Provider<ChatApi>((ref) {
  final dio = ref.watch(dioChatProvider);
  return ChatApi(dio);
});

/// Provider de ChatRepositorio
final chatRepositoryProvider = Provider<ChatRepositorio>((ref) {
  final api = ref.watch(chatApiProvider);
  return ChatRepositorioImpl(api);
});

/// Provider de ChatCasoUso
final chatUseCaseProvider = Provider<ChatCasoUso>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatCasoUso(repo);
});

/// Provider de WebSocketService
/// Se crea con el token de autenticación de la sesión actual
/// Usa la URL configurada en chatBackendUrlProvider
// final webSocketServiceProvider = Provider<WebSocketService>((ref) {
//   final httpUrl = ref.watch(chatBackendUrlProvider);
//   final wsUrl = httpUrl.replaceFirst("http", "ws");
//   final session = ref.watch(sessionProvider);
//
//   return WebSocketService(
//     baseUrl: wsUrl,
//     token: session.token,
//   );
// });

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final httpUrl = ref.watch(chatBackendUrlProvider);
  final wsUrl = httpUrl.startsWith("https")
      ? httpUrl.replaceFirst("https", "wss")
      : httpUrl.replaceFirst("http", "ws");

  final fullWsUrl = "$wsUrl/ws-chat";
  final session = ref.watch(sessionProvider);

  return WebSocketService(baseUrl: fullWsUrl, token: session.token);
});

// *****************************************************************************
//  PROVIDERS DE PERFIL

final perfilApiProvider = Provider<PerfilApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PerfilApi(dio);
});

final perfilRepositoryProvider = Provider<PerfilRepositorio>((ref) {
  final api = ref.watch(perfilApiProvider);
  return PerfilRepositorioImpl(api);
});

final obtenerPerfilUseCaseProvider = Provider<ObtenerPerfilCasoUso>((ref) {
  final repository = ref.watch(perfilRepositoryProvider);
  return ObtenerPerfilCasoUso(repository);
});

final obtenerPalabrasClaveUseCaseProvider = Provider<ObtenerPalabrasClaveCasoUso>((ref) {
  final repository = ref.watch(perfilRepositoryProvider);
  return ObtenerPalabrasClaveCasoUso(repository);
});

final perfilProvider = FutureProvider.autoDispose((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerPerfilUseCaseProvider);
  return await useCase(idUsuario);
});

final palabrasClaveProvider = FutureProvider.autoDispose<List<PalabraClave>>((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerPalabrasClaveUseCaseProvider);
  return await useCase(idUsuario);
});

// *****************************************************************************
//  PROVIDERS DE PALABRAS CLAVE

final palabraClaveApiProvider = Provider<PalabraClaveApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PalabraClaveApi(dio);
});

final palabraClaveRepositoryProvider = Provider<PalabraClaveRepositorio>((ref) {
  final api = ref.watch(palabraClaveApiProvider);
  return PalabraClaveRepositorioImpl(api);
});


final agregarPalabrasClaveUseCaseProvider = Provider<AgregarPalabrasClavesCasoUso>((ref) {
  final repository = ref.watch(palabraClaveRepositoryProvider);
  return AgregarPalabrasClavesCasoUso(repository);
});

final palabrasClaveNotifierProvider = StateNotifierProvider.autoDispose<PalabrasClaveNotifier, PalabrasClaveState>((ref) {
  final obtenerUseCase = ref.watch(obtenerPalabrasClaveUseCaseProvider);
  final agregarUseCase = ref.watch(agregarPalabrasClaveUseCaseProvider);

  return PalabrasClaveNotifier(
    obtenerPalabrasClaveCasoUso: obtenerUseCase,
    agregarPalabrasClavesCasoUso: agregarUseCase,
  );
});

final obtenerCatalogoPalabrasClaveUseCaseProvider = Provider<ObtenerCatalogoPalabrasClavesCasoUso>((ref) {
  final repository = ref.watch(palabraClaveRepositoryProvider);
  return ObtenerCatalogoPalabrasClavesCasoUso(repository);
});

final catalogoPalabrasClaveProvider = FutureProvider.autoDispose<List<PalabraClave>>((ref) async {
  final useCase = ref.watch(obtenerCatalogoPalabrasClaveUseCaseProvider);
  return await useCase();
});

// *****************************************************************************
//  PROVIDERS DE DATOS BASICOS

final datosBasicosApiProvider = Provider<DatosBasicosApi>((ref) {
  final dio = ref.watch(dioProvider);
  return DatosBasicosApi(dio);
});

final datosBasicosRepositoryProvider = Provider<DatosBasicosRepository>((ref) {
  final api = ref.watch(datosBasicosApiProvider);
  return DatosBasicosRepositoryImpl(api);
});

final obtenerDatosBasicosUseCaseProvider = Provider<ObtenerDatosBasicosUseCase>((ref) {
  final repo = ref.watch(datosBasicosRepositoryProvider);
  return ObtenerDatosBasicosUseCase(repo);
});

final datosBasicosProvider = FutureProvider.autoDispose((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerDatosBasicosUseCaseProvider);
  return await useCase(idUsuario);
});

final actualizarDatosBasicosCasoUsoProvider = Provider<ActualizarDatosBasicosCasoUso>((ref) {
  final repo = ref.watch(datosBasicosRepositoryProvider);
  return ActualizarDatosBasicosCasoUso(repo);
});

final datosBasicosEdicionNotifierProvider = StateNotifierProvider.autoDispose<
    DatosBasicosEdicionNotifier, DatosBasicosEdicionState>((ref) {
  final actualizarUseCase = ref.watch(actualizarDatosBasicosCasoUsoProvider);
  return DatosBasicosEdicionNotifier(actualizarUseCase);
});


// *****************************************************************************
//  PROVIDERS DE IMAGEN

final imagenApiProvider = Provider<ImagenApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ImagenApi(dio);
});

final imagenRepositoryProvider = Provider<ImagenRepository>((ref) {
  final api = ref.watch(imagenApiProvider);
  return ImagenRepositoryImpl(api);
});

final subirFotoPerfilUseCaseProvider = Provider<SubirFotoPerfilCasoUso>((ref) {
  final repo = ref.watch(imagenRepositoryProvider);
  return SubirFotoPerfilCasoUso(repo);
});

final obtenerFotoPerfilUseCaseProvider = Provider<ObtenerFotoPerfilCasoUso>((ref) {
  final repo = ref.watch(imagenRepositoryProvider);
  return ObtenerFotoPerfilCasoUso(repo);
});


final fotoPerfilProvider = FutureProvider.family<String?, int>((ref, idUsuario) async {
  final api = ref.watch(imagenApiProvider);
  final respuesta = await api.obtenerFotoPerfil(idUsuario);

  if (respuesta.codigoEstado == 200 && respuesta.datos != null) {
    final urlImagen = respuesta.datos!['urlImagen'] as String?;
    return urlImagen;
  }

  return null;
});

// *****************************************************************************
//  PROVIDERS DE UBICACION

final ubicacionApiProvider = Provider<UbicacionApi>((ref) {
  final dio = ref.watch(dioProvider);
  return UbicacionApi(dio);
});

final ubicacionRepositoryProvider = Provider<UbicacionRepository>((ref) {
  final api = ref.watch(ubicacionApiProvider);
  return UbicacionRepositoryImpl(api);
});

final buscarUbicacionesUseCaseProvider = Provider<BuscarUbicacionesCasoUso>((ref) {
  final repo = ref.watch(ubicacionRepositoryProvider);
  return BuscarUbicacionesCasoUso(repo);
});

// *****************************************************************************
//  PROVIDERS DE ARCHIVOS

final archivoApiProvider = Provider<ArchivoApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ArchivoApi(dio);
});

final archivoRepositorioProvider = Provider<ArchivoRepositorio>((ref) {
  final cvApi = ref.watch(archivoApiProvider);
  return ArchivoRepositorioImpl(cvApi);
});

final obtenerArchivoUseCaseProvider = Provider<ObtenerAchivoCasoUso>((ref) {
  final repositorio = ref.watch(archivoRepositorioProvider);
  return ObtenerAchivoCasoUso(repositorio);
});

final descargarArchivoUseCaseProvider = Provider<DescargarCVUseCase>((ref) {
  final repositorio = ref.watch(archivoRepositorioProvider);
  return DescargarCVUseCase(repositorio);
});

final subirArchivoUseCaseProvider = Provider<SubirArchivoCasoUso>((ref) {
  final repositorio = ref.watch(archivoRepositorioProvider);
  return SubirArchivoCasoUso(repositorio);
});

final archivoUsuarioProvider = FutureProvider.autoDispose<Archivo?>((ref) async {
  final session = ref.watch(sessionProvider);
  final useCase = ref.watch(obtenerArchivoUseCaseProvider);

  if (session.userId == null) {
    return null;
  }

  return await useCase(session.userId!);
});

// *****************************************************************************
//  PROVIDERS DE COMPETENCIAS Y HABILIDADES

final talentoApiProvider = Provider<TalentoApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TalentoApi(dio);
});

final talentoRepositoryProvider = Provider<TalentoRepositorio>((ref) {
  final api = ref.watch(talentoApiProvider);
  return TalentoRepositorioImpl(api);
});

// Use Cases
final obtenerTalentosUsuarioUseCaseProvider = Provider<ObtenerTalentosUsuarioCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return ObtenerTalentosUsuarioCasoUso(repository);
});

final obtenerEstadisticasTalentosUseCaseProvider = Provider<ObtenerEstadisticasTalentosCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return ObtenerEstadisticasTalentosCasoUso(repository);
});

final obtenerCatalogoTalentosUseCaseProvider = Provider<ObtenerCatalogoTalentosCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return ObtenerCatalogoTalentosCasoUso(repository);
});

final agregarTalentoUseCaseProvider = Provider<AgregarTalentoCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return AgregarTalentoCasoUso(repository);
});

final editarNivelTalentoUseCaseProvider = Provider<EditarNivelTalentoCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return EditarNivelTalentoCasoUso(repository);
});

final eliminarTalentoUseCaseProvider = Provider<EliminarTalentoCasoUso>((ref) {
  final repository = ref.watch(talentoRepositoryProvider);
  return EliminarTalentoCasoUso(repository);
});

// FutureProviders para datos
final talentosUsuarioProvider = FutureProvider.autoDispose<List<RelUsuarioTalento>>((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerTalentosUsuarioUseCaseProvider);
  return await useCase(idUsuario);
});

final estadisticasTalentosProvider = FutureProvider.autoDispose<TalentoEstadisticas>((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerEstadisticasTalentosUseCaseProvider);
  return await useCase(idUsuario);
});

final catalogoTalentosProvider = FutureProvider.autoDispose<List<Talento>>((ref) async {
  final useCase = ref.watch(obtenerCatalogoTalentosUseCaseProvider);
  return await useCase();
});

// *****************************************************************************
//  PROVIDERS DE PORTAFOLIO

final portafolioApiProvider = Provider<PortafolioApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PortafolioApi(dio);
});

// Repository Provider
final portafolioRepositoryProvider = Provider<PortafolioRepositorio>((ref) {
  final api = ref.watch(portafolioApiProvider);
  return PortafolioRepositorioImpl(api);
});

// Use Cases Providers
final obtenerPortafolioUseCaseProvider = Provider<ObtenerPortafolioCasoUso>((ref) {
  final repository = ref.watch(portafolioRepositoryProvider);
  return ObtenerPortafolioCasoUso(repository);
});

final subirImagenPortafolioUseCaseProvider = Provider<SubirImagenPortafolioCasoUso>((ref) {
  final repository = ref.watch(portafolioRepositoryProvider);
  return SubirImagenPortafolioCasoUso(repository);
});

final eliminarImagenPortafolioUseCaseProvider = Provider<EliminarImagenPortafolioCasoUso>((ref) {
  final repository = ref.watch(portafolioRepositoryProvider);
  return EliminarImagenPortafolioCasoUso(repository);
});

// FutureProvider para obtener portafolio
final portafolioUsuarioProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(obtenerPortafolioUseCaseProvider);
  return await useCase(idUsuario);
});

// StateNotifierProvider para gestionar el estado del portafolio
final portafolioNotifierProvider = StateNotifierProvider.autoDispose<
    PortafolioNotifier, PortafolioState>((ref) {
  final obtenerUseCase = ref.watch(obtenerPortafolioUseCaseProvider);
  final subirUseCase = ref.watch(subirImagenPortafolioUseCaseProvider);
  final eliminarUseCase = ref.watch(eliminarImagenPortafolioUseCaseProvider);

  return PortafolioNotifier(
    obtenerPortafolioCasoUso: obtenerUseCase,
    subirImagenPortafolioCasoUso: subirUseCase,
    eliminarImagenPortafolioCasoUso: eliminarUseCase,
  );
});

// *****************************************************************************
//  PROVIDERS DE PROGRESO DEL PERFIL

final calcularProgresoPerfilUseCaseProvider = Provider<CalcularProgresoPerfilCasoUso>((ref) {
  final datosBasicosRepo = ref.watch(datosBasicosRepositoryProvider);
  final archivoRepo = ref.watch(archivoRepositorioProvider);
  final imagenRepo = ref.watch(imagenRepositoryProvider);
  final obtenerPalabrasClaveCasoUso = ref.watch(obtenerPalabrasClaveUseCaseProvider);
  final obtenerTalentosCasoUso = ref.watch(obtenerTalentosUsuarioUseCaseProvider);

  return CalcularProgresoPerfilCasoUso(
    datosBasicosRepo: datosBasicosRepo,
    archivoRepo: archivoRepo,
    imagenRepo: imagenRepo,
    obtenerPalabrasClaveCasoUso: obtenerPalabrasClaveCasoUso,
    obtenerTalentosCasoUso: obtenerTalentosCasoUso,
  );
});

final progresoPerfilProvider = FutureProvider.autoDispose<ProgresoPerfil>((ref) async {
  final session = ref.watch(sessionProvider);
  final idUsuario = session.userId;

  if (idUsuario == null) {
    throw Exception('No hay usuario en sesión');
  }

  final useCase = ref.watch(calcularProgresoPerfilUseCaseProvider);
  return await useCase(idUsuario);
});