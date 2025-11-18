import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oasis/application/sesion_notifier.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/app.dart';
import 'domain/model/acceso_sesion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Cargar datos de sesión desde SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("swallow_token");
  final image = prefs.getString("swallow_image_base64");
  final expira = prefs.getInt("swallow_expira_en");
  final userId = prefs.getInt("swallow_user_id");
  final empresaId = prefs.getInt("swallow_empresa_id");
  final email = prefs.getString("swallow_email");
  final estadoVerificacion = prefs.getInt("swallow_estado_verificacion_correo");

  String? emailFinal = email;
  if ((emailFinal == null || emailFinal.isEmpty) && token != null) {
    emailFinal = AccesoSesion.extractEmailFromToken(token);
  }

  // Crear sesión inicial con todos los datos incluidos userId y empresaId
  final initialSession = AccesoSesion(
    token: token,
    imageBase64: image,
    expiraEn: expira,
    userId: userId,
    empresaId: empresaId,
    email: emailFinal,
    estadoVerificacionCorreo: estadoVerificacion,
  );
  runApp(
    ProviderScope(
      overrides: [
        sessionProvider.overrideWith((ref) => SesionNotifier(initialSession)),
      ],
      child: const App(),
    ),
  );
}
