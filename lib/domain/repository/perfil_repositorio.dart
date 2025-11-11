import 'package:oasis/domain/model/perfil.dart';
import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/domain/model/perfil_completo.dart';

abstract class PerfilRepositorio {
  Future<Perfil> obtenerPerfil(int idUsuario);
  Future<List<PalabraClave>> obtenerPalabrasClave(int idUsuario);
  Future<PerfilCompleto> obtenerPerfilCompleto(int idUsuario);
}
