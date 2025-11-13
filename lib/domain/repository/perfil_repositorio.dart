import 'package:oasis/domain/model/perfil.dart';
import 'package:oasis/domain/model/palabra_clave.dart';

abstract class PerfilRepositorio {
  Future<Perfil> obtenerPerfil(int idUsuario);
  Future<List<PalabraClave>> obtenerPalabrasClave(int idUsuario);
}
