import 'package:oasis/domain/model/palabra_clave.dart';

abstract class PalabraClaveRepositorio {
  Future<List<PalabraClave>> obtenerCatalogo();
  Future<void> agregarPalabrasClave(int idUsuario, List<int> idsPalabrasClave);
}