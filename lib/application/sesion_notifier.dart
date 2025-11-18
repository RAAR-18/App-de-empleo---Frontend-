import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/domain/model/acceso_sesion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SesionNotifier extends StateNotifier<AccesoSesion> {
  static const _tokenKey = "swallow_token";
  static const _imageKey = "swallow_image_base64";
  static const _expiraKey = "swallow_expira_en";
  static const _userIdKey = "swallow_user_id";
  static const _empresaIdKey = "swallow_empresa_id";
  static const _emailKey = "swallow_email";
  static const _estadoVerificacionKey = "swallow_estado_verificacion_correo";

  /// Constructor principal: recibe un estado inicial
  SesionNotifier([super.initial = const AccesoSesion()]);

  /// Cargar valores desde SharedPreferences (si quieres refrescar manualmente)
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    String? email = prefs.getString(_emailKey);
    if (email == null || email.isEmpty) {
      email = AccesoSesion.extractEmailFromToken(token);
    }

    state = AccesoSesion(
      token: prefs.getString(_tokenKey),
      imageBase64: prefs.getString(_imageKey),
      expiraEn: prefs.getInt(_expiraKey),
      userId: prefs.getInt(_userIdKey),
      empresaId: prefs.getInt(_empresaIdKey),
      email: email,
      estadoVerificacionCorreo: prefs.getInt(_estadoVerificacionKey),
    );
  }

  /// Guardar sesión
  Future<void> saveSession(
    String token,
    String imageBase64,
    int expiraEn, {
    int? userId,
    int? empresaId,
        int? estadoVerificacionCorreo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final email = AccesoSesion.extractEmailFromToken(token);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_imageKey, imageBase64);
    await prefs.setInt(_expiraKey, expiraEn);
    
    // Guardar userId y empresaId si están disponibles
    if (userId != null) {
      await prefs.setInt(_userIdKey, userId);
    }
    if (empresaId != null) {
      await prefs.setInt(_empresaIdKey, empresaId);
    }

    if (email != null) {
      await prefs.setString(_emailKey, email);
    }

    if (estadoVerificacionCorreo != null) {
      await prefs.setInt(_estadoVerificacionKey, estadoVerificacionCorreo);
    }

    state = AccesoSesion(
      token: token,
      imageBase64: imageBase64,
      expiraEn: expiraEn,
      userId: userId,
      empresaId: empresaId,
      email: email,
      estadoVerificacionCorreo: estadoVerificacionCorreo,
    );
  }

  Future<void> updateEstadoVerificacion(int estadoVerificacion) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_estadoVerificacionKey, estadoVerificacion);

    state = state.copyWith(estadoVerificacionCorreo: estadoVerificacion);
  }

  /// Limpiar sesión
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_imageKey);
    await prefs.remove(_expiraKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_empresaIdKey);
    await prefs.remove(_emailKey);

    state = const AccesoSesion();
  }

  Future<void> updateEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);

    state = state.copyWith(email: email);
  }
}



