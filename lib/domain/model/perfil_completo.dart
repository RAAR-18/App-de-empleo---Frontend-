import 'package:oasis/domain/model/perfil.dart';
import 'package:oasis/domain/model/palabra_clave.dart';

class PerfilCompleto {
  final Perfil perfil;
  final List<PalabraClave> palabrasClave;

  const PerfilCompleto({
    required this.perfil,
    required this.palabrasClave,
  });

  PerfilCompleto copyWith({
    Perfil? perfil,
    List<PalabraClave>? palabrasClave,
  }) {
    return PerfilCompleto(
      perfil: perfil ?? this.perfil,
      palabrasClave: palabrasClave ?? this.palabrasClave,
    );
  }

  @override
  String toString() {
    return 'PerfilCompleto(perfil: $perfil, palabrasClave: $palabrasClave)';
  }

  @override
  bool operator ==(Object other) {
    return other is PerfilCompleto && other.perfil == perfil;
  }

  @override
  int get hashCode => perfil.hashCode;
}
