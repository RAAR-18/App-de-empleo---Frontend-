import 'package:oasis/domain/model/ubicacion.dart';

abstract class UbicacionRepository {
  Future<List<Ubicacion>> buscarUbicaciones(String termino);
}