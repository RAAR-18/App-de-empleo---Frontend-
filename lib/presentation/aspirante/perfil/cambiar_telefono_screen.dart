import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/application/cambio_telefono_notifier.dart';

import '../../../core/ui/app_bottom_bar.dart';

class CambiarTelefonoScreen extends ConsumerStatefulWidget {
  const CambiarTelefonoScreen({super.key});

  @override
  ConsumerState<CambiarTelefonoScreen> createState() =>
      _CambiarTelefonoScreenState();
}

class _CambiarTelefonoScreenState
    extends ConsumerState<CambiarTelefonoScreen> {
  final _nuevoTelefonoController = TextEditingController();
  final _pinAnteriorController = TextEditingController();
  final _pinNuevoController = TextEditingController();

  final _formKeyTelefono = GlobalKey<FormState>();
  final _formKeyPinAnterior = GlobalKey<FormState>();
  final _formKeyPinNuevo = GlobalKey<FormState>();

  @override
  void dispose() {
    _nuevoTelefonoController.dispose();
    _pinAnteriorController.dispose();
    _pinNuevoController.dispose();
    super.dispose();
  }

  Future<void> _iniciarCambioTelefono() async {
    if (!_formKeyTelefono.currentState!.validate()) return;

    final session = ref.read(sessionProvider);
    if (session.userId == null) {
      _mostrarSnackBar('Error: Usuario no autenticado', color: Colors.red);
      return;
    }

    final notifier = ref.read(cambioTelefonoNotifierProvider.notifier);
    await notifier.iniciarCambio(
      idUsuario: session.userId!,
      telefonoNuevo: _nuevoTelefonoController.text,
    );
  }

  Future<void> _verificarPinAnterior() async {
    if (!_formKeyPinAnterior.currentState!.validate()) return;

    final notifier = ref.read(cambioTelefonoNotifierProvider.notifier);
    await notifier.verificarPinAnterior(_pinAnteriorController.text);
  }

  Future<void> _verificarPinNuevo() async {
    if (!_formKeyPinNuevo.currentState!.validate()) return;

    final notifier = ref.read(cambioTelefonoNotifierProvider.notifier);
    await notifier.verificarPinNuevo(_pinNuevoController.text);
  }

  void _reenviarCodigo() async {
    final state = ref.read(cambioTelefonoNotifierProvider);
    final notifier = ref.read(cambioTelefonoNotifierProvider.notifier);

    if (state.step == CambioTelefonoStep.verificandoAnterior) {
      await notifier.reenviarCodigoAnterior();
    } else if (state.step == CambioTelefonoStep.verificandoNuevo) {
      await notifier.reenviarCodigoNuevo();
    }
  }

  void _mostrarSnackBar(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 64,
          ),
          title: const Text('¡Teléfono actualizado!'),
          content: const Text(
            'Tu número de teléfono ha sido actualizado exitosamente.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();

                ref.invalidate(telefonoActualProvider);

                ref.invalidate(cambioTelefonoNotifierProvider);

                context.pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(cambioTelefonoNotifierProvider);
    final session = ref.watch(sessionProvider);
    ref.listen<CambioTelefonoState>(
      cambioTelefonoNotifierProvider,
          (previous, next) {
        if (next.error != null && next.error!.isNotEmpty) {
          _mostrarSnackBar(next.error!, color: Colors.red);
        }

        if (next.mensaje != null &&
            next.mensaje!.isNotEmpty &&
            next.error == null &&
            previous?.mensaje != next.mensaje) {
          _mostrarSnackBar(next.mensaje!, color: Colors.green);
        }

        if (next.step == CambioTelefonoStep.completado &&
            previous?.step != CambioTelefonoStep.completado) {
          _mostrarDialogoExito();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/perfil'),
        ),
        title: const Text('Cambiar Teléfono'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: state.isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text('Procesando...', style: textTheme.bodyLarge),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildCurrentStepContent(colorScheme, textTheme, state),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: 4,
        profileImageBase64: session.imageBase64,
      ),
    );
  }

  Widget _buildCurrentStepContent(
      ColorScheme colorScheme,
      TextTheme textTheme,
      CambioTelefonoState state,
      ) {
    switch (state.step) {
      case CambioTelefonoStep.inicial:
        return _buildIngresoStep(colorScheme, textTheme);
      case CambioTelefonoStep.verificandoAnterior:
        return _buildVerificarAnteriorStep(colorScheme, textTheme, state);
      case CambioTelefonoStep.verificandoNuevo:
        return _buildVerificarNuevoStep(colorScheme, textTheme, state);
      case CambioTelefonoStep.completado:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Cambio completado!',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIngresoStep(ColorScheme colorScheme, TextTheme textTheme) {
    return Form(
      key: _formKeyTelefono,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(1, 3, colorScheme),
          const SizedBox(height: 32),

          Icon(Icons.phone_android, size: 80, color: colorScheme.primary),
          const SizedBox(height: 24),

          Text(
            'Número de Teléfono',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            'Gestión del número de teléfono para tu cuenta',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),


          FutureBuilder<String>(
            future: _obtenerTelefonoActual(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildInfoCard(
                  colorScheme,
                  textTheme,
                  icon: Icons.phone,
                  titulo: 'Número de Teléfono Actual',
                  contenido: 'Cargando...',
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return _buildInfoCard(
                  colorScheme,
                  textTheme,
                  icon: Icons.phone,
                  titulo: 'Número de Teléfono Actual',
                  contenido: 'No disponible',
                );
              }

              return _buildInfoCard(
                colorScheme,
                textTheme,
                icon: Icons.phone,
                titulo: 'Número de Teléfono Actual',
                contenido: snapshot.data!,
              );
            },
          ),
          const SizedBox(height: 24),

          // Nuevo teléfono
          _buildInfoCard(
            colorScheme,
            textTheme,
            icon: Icons.phone_iphone,
            titulo: 'Nuevo Número de Teléfono',
            contenido: TextFormField(
              controller: _nuevoTelefonoController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: '3001234567',
                prefixIcon: Icon(Icons.phone, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el nuevo número';
                }
                if (value.length < 10) {
                  return 'Número inválido (mínimo 10 dígitos)';
                }
                return null;
              },
            ),
            esTarjetaExpandida: true,
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _iniciarCambioTelefono,
            icon: const Icon(Icons.phone_forwarded),
            label: const Text('Cambiar Número'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Información adicional
          _buildInfoBox(colorScheme, textTheme),
        ],
      ),
    );
  }

  // Método para obtener el teléfono actual
  Future<String> _obtenerTelefonoActual() async {
    try {
      final session = ref.read(sessionProvider);
      if (session.userId == null) {
        return 'Usuario no autenticado';
      }

      try {
        final telefono = await ref.read(telefonoActualProvider.future);
        return telefono;
      } catch (e) {
        // Si el provider no existe, intentar llamar directamente a la API
        final dio = ref.read(dioProvider);
        final response = await dio.get('/user/acceso/${session.userId}/telefono');

        if (response.statusCode == 200 && response.data['data'] != null) {
          return response.data['data']['telefono'] as String;
        }

        return 'No disponible';
      }
    } catch (e) {
      return 'No disponible';
    }
  }

  Widget _buildVerificarAnteriorStep(
      ColorScheme colorScheme,
      TextTheme textTheme,
      CambioTelefonoState state,
      ) {
    return Form(
      key: _formKeyPinAnterior,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicador de progreso
          _buildProgressIndicator(2, 3, colorScheme),
          const SizedBox(height: 32),

          // Icono de mensaje
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read,
              size: 60,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),

          // Título
          Text(
            'Código de verificación enviado',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Teléfono enmascarado
          Text(
            'Enviado a ${state.telefonoAnterior ?? "****"}',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Mensaje informativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: colorScheme.secondary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hemos enviado un código de verificación por SMS a tu teléfono anterior. Revisa tus mensajes.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Campo de código
          TextFormField(
            controller: _pinAnteriorController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: '000000',
              hintStyle: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                letterSpacing: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa el código';
              }
              if (value.length != 6) {
                return 'El código debe tener 6 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Botón verificar
          FilledButton(
            onPressed: _verificarPinAnterior,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Verificar Código'),
          ),
          const SizedBox(height: 16),

          // Botón reenviar
          TextButton.icon(
            onPressed: _reenviarCodigo,
            icon: const Icon(Icons.refresh),
            label: const Text('Reenviar Código'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificarNuevoStep(
      ColorScheme colorScheme,
      TextTheme textTheme,
      CambioTelefonoState state,
      ) {
    return Form(
      key: _formKeyPinNuevo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicador de progreso
          _buildProgressIndicator(3, 3, colorScheme),
          const SizedBox(height: 32),

          // Icono de verificación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user,
              size: 60,
              color: colorScheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: 24),

          // Título
          Text(
            '¡Ya casi terminamos!',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtítulo
          Text(
            'Verifica el código enviado a tu nuevo número',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Teléfono nuevo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  state.telefonoNuevo ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Campo de código
          TextFormField(
            controller: _pinNuevoController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: '000000',
              hintStyle: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                letterSpacing: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa el código';
              }
              if (value.length != 6) {
                return 'El código debe tener 6 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Botón completar
          FilledButton(
            onPressed: _verificarPinNuevo,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Completar Cambio'),
          ),
          const SizedBox(height: 16),

          // Botón reenviar
          TextButton.icon(
            onPressed: _reenviarCodigo,
            icon: const Icon(Icons.refresh),
            label: const Text('Reenviar Código'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      int current, int total, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index < current;
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < total - 1)
              Container(
                width: 40,
                height: 2,
                color: index < current - 1
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoCard(
      ColorScheme colorScheme,
      TextTheme textTheme, {
        required IconData icon,
        required String titulo,
        required dynamic contenido,
        bool esTarjetaExpandida = false,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (contenido is String)
            Text(
              contenido,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            )
          else
            contenido,
        ],
      ),
    );
  }

  Widget _buildInfoBox(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '¿Por qué verificar tu teléfono?',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            colorScheme,
            textTheme,
            'Recibe notificaciones importantes sobre ofertas laborales por SMS',
          ),
          _buildBulletPoint(
            colorScheme,
            textTheme,
            'Permite que los empleadores te contacten directamente',
          ),
          _buildBulletPoint(
            colorScheme,
            textTheme,
            'Mejora la seguridad de tu cuenta con verificación en dos pasos',
          ),
          _buildBulletPoint(
            colorScheme,
            textTheme,
            'Aumenta tu credibilidad ante empleadores',
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(
      ColorScheme colorScheme,
      TextTheme textTheme,
      String texto,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}