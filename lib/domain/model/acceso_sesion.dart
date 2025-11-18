import 'package:jwt_decode/jwt_decode.dart';

class AccesoSesion {
  final String? token;
  final String? imageBase64;
  final int? expiraEn;
  final int? userId;
  final int? empresaId;
  final String? email;
  final int? estadoVerificacionCorreo;

  const AccesoSesion({
    this.token,
    this.imageBase64,
    this.expiraEn,
    this.userId,
    this.empresaId,
    this.email,
    this.estadoVerificacionCorreo
  });

  bool get isLoggedIn => token != null;
  bool get correoVerificado => estadoVerificacionCorreo == 3;

  bool get isExpired {
    if (expiraEn == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= expiraEn!;
  }

  static String? extractEmailFromToken(String? token) {
    if (token == null || token.isEmpty) return null;

    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return payload['sub'] as String?; // 'sub' contiene el email
    } catch (e) {
      return null;
    }
  }

  factory AccesoSesion.fromToken({
    required String token,
    String? imageBase64,
    int? expiraEn,
    int? userId,
    int? empresaId,
    int? estadoVerificacionCorreo,
  }) {
    final email = extractEmailFromToken(token);

    return AccesoSesion(
      token: token,
      imageBase64: imageBase64,
      expiraEn: expiraEn,
      userId: userId,
      empresaId: empresaId,
      email: email,
      estadoVerificacionCorreo: estadoVerificacionCorreo,
    );
  }

  AccesoSesion copyWith({
    String? token,
    String? imageBase64,
    int? expiraEn,
    int? userId,
    int? empresaId,
    String? email,
    int? estadoVerificacionCorreo,
  }) {
    return AccesoSesion(
      token: token ?? this.token,
      imageBase64: imageBase64 ?? this.imageBase64,
      expiraEn: expiraEn ?? this.expiraEn,
      userId: userId ?? this.userId,
      empresaId: empresaId ?? this.empresaId,
      email: email ?? this.email,
      estadoVerificacionCorreo: estadoVerificacionCorreo ?? this.estadoVerificacionCorreo,
    );
  }
}
