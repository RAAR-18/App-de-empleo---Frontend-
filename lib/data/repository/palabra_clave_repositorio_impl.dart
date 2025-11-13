import 'package:oasis/data/remote/palabra_clave_api.dart';
import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/repository/palabra_clave_repositorio.dart';

class PalabraClaveRepositorioImpl implements PalabraClaveRepositorio {
  final PalabraClaveApi _palabraClaveApi;

  PalabraClaveRepositorioImpl(this._palabraClaveApi);

  @override
  Future<List<PalabraClave>> obtenerCatalogo() async {
    final respuesta = await _palabraClaveApi.obtenerCatalogo();

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al obtener catálogo');
    }

    return respuesta.datos!
        .map((dto) => PalabraClave(
      idPalabraClave: dto.idPalabraClave,
      textoPalabraClave: dto.textoPalabraClave,
    ))
        .toList();
  }

  @override
  Future<void> agregarPalabrasClave(int idUsuario, List<int> idsPalabrasClave) async {
    final respuesta = await _palabraClaveApi.agregarPalabrasClave(idUsuario, idsPalabrasClave);

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al agregar palabras clave');
    }
  }
}