import 'package:oasis/data/remote/perfil_api.dart';
import 'package:oasis/domain/model/perfil.dart';
import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/model/perfil_completo.dart';
import 'package:oasis/domain/repository/perfil_repositorio.dart';

class PerfilRepositorioImpl implements PerfilRepositorio {
  final PerfilApi _perfilApi;

  PerfilRepositorioImpl(this._perfilApi);

  @override
  Future<Perfil> obtenerPerfil(int idUsuario) async {
    final respuesta = await _perfilApi.obtenerPerfil(idUsuario);

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al obtener el perfil');
    }

    final dto = respuesta.datos!;
    return Perfil(
      idUsuario: dto.idUsuario,
      nombreCompleto: dto.nombreCompleto,
      profesion: dto.profesion,
      ubicacion: dto.ubicacion,
      fotoPerfil: dto.fotoPerfil,
    );
  }

  @override
  Future<List<PalabraClave>> obtenerPalabrasClave(int idUsuario) async {
    final respuesta = await _perfilApi.obtenerPalabrasClave(idUsuario);

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al obtener palabras clave');
    }

    return respuesta.datos!
        .map((dto) => PalabraClave(
      idPalabraClave: dto.idPalabraClave,
      textoPalabraClave: dto.textoPalabraClave,
    ))
        .toList();
  }

  @override
  Future<PerfilCompleto> obtenerPerfilCompleto(int idUsuario) async {
    final perfil = await obtenerPerfil(idUsuario);
    final palabrasClave = await obtenerPalabrasClave(idUsuario);

    return PerfilCompleto(
      perfil: perfil,
      palabrasClave: palabrasClave,
    );
  }
}
