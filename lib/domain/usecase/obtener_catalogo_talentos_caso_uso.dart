import 'package:oasis/domain/model/talento.dart';
import 'package:oasis/domain/repository/talento_repositorio.dart';

class ObtenerCatalogoTalentosCasoUso {
  final TalentoRepositorio repositorio;

  ObtenerCatalogoTalentosCasoUso(this.repositorio);

  Future<List<Talento>> call() {
    return repositorio.obtenerCatalogoTalentos();
  }
}