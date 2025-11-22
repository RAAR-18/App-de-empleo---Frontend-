import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/core/ui/app_top_bar.dart';

class VerificacionCorreoScreen extends ConsumerStatefulWidget {
  const VerificacionCorreoScreen({super.key});

  @override
  ConsumerState<VerificacionCorreoScreen> createState() =>
      _VerificacionCorreoScreenState();
}

class _VerificacionCorreoScreenState
    extends ConsumerState<VerificacionCorreoScreen> {
  final _codigoController = TextEditingController();
  bool _codigoEnviado = false;
  bool _isLoadingEstado = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEstadoInicial();
    });
  }

  Future<void> _cargarEstadoInicial() async {
    setState(() => _isLoadingEstado = true);

    try {
      final accesoInfoAsyncValue = ref.read(accesoInfoProvider);

      await accesoInfoAsyncValue.when(
        data: (accesoInfo) async {
          final correo = accesoInfo.email;

          if (correo != null && correo.isNotEmpty) {
            try {
              await ref.read(verificaionCorreoNotifierProvider.notifier)
                  .obtenerEstado(correo);
            } catch (e) {
              print('Error al obtener estado de verificación: $e');
            }
          } else {
            print('No hay correo en acceso_info');
          }
        },
        loading: () async {
          print('Cargando información de acceso...');
        },
        error: (error, stack) async {
          print('Error al cargar acceso_info: $error');
        },
      );
    } catch (e) {
      print('Error en _cargarEstadoInicial: $e');
    }

    setState(() => _isLoadingEstado = false);
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    final accesoInfoAsyncValue = ref.read(accesoInfoProvider);

    String? correo;
    accesoInfoAsyncValue.whenData((accesoInfo) {
      correo = accesoInfo.email;
    });

    if (correo == null || correo!.isEmpty) {
      _mostrarError('No se encontró el correo en la información de acceso');
      return;
    }

    await ref.read(verificaionCorreoNotifierProvider.notifier)
        .enviarCodigo(correo!);

    final state = ref.read(verificaionCorreoNotifierProvider);

    if (state.codigoEnviado && state.error == null) {
      setState(() {
        _codigoEnviado = true;
      });

      if (mounted) {
        _mostrarExito(
            state.verificacion?.mensaje ?? 'Código enviado exitosamente');
      }
    } else if (state.error != null) {
      _mostrarError(state.error!);
    }
  }

  Future<void> _verificarCodigo() async {
    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty) {
      _mostrarError('Ingresa el código de verificación');
      return;
    }

    if (codigo.length != 6) {
      _mostrarError('El código debe tener 6 dígitos');
      return;
    }

    final accesoInfoAsyncValue = ref.read(accesoInfoProvider);

    String? correo;
    accesoInfoAsyncValue.whenData((accesoInfo) {
      correo = accesoInfo.email;
    });

    if (correo == null || correo!.isEmpty) {
      _mostrarError('No se encontró el correo en la información de acceso');
      return;
    }

    await ref.read(verificaionCorreoNotifierProvider.notifier)
        .verificarCodigo(correo!, codigo);

    final state = ref.read(verificaionCorreoNotifierProvider);

    if (state.codigoVerificado && state.error == null) {
      if (mounted) {
        _mostrarExito('¡Correo verificado exitosamente!');

        // Esperar 2 segundos y regresar
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    } else if (state.error != null) {
      _mostrarError(state.error!);
    }
  }

  void _cancelarVerificacion() {
    setState(() {
      _codigoEnviado = false;
      _codigoController.clear();
    });
    ref.read(verificaionCorreoNotifierProvider.notifier).resetCodigoEnviado();
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(verificaionCorreoNotifierProvider);
    final session = ref.watch(sessionProvider);

    final accesoInfoAsyncValue = ref.watch(accesoInfoProvider);

    return accesoInfoAsyncValue.when(
      data: (accesoInfo) {
        final correo = accesoInfo.email ?? '';

        if (correo.isEmpty) {
          return _buildPantallaError(colorScheme, textTheme);
        }

        if (_isLoadingEstado) {
          return _buildPantallaCargando(colorScheme, textTheme);
        }

        // Verificar si ya está verificado desde estadoVerificacionCorreo o desde la API
        if (accesoInfo.estadoVerificacionCorreo == 3 ||
            state.verificacion?.estaVerificado == true) {
          return _buildPantallaVerificado(colorScheme, textTheme);
        }

        if (_codigoEnviado) {
          return _buildPantallaIngresoCodigo(correo, colorScheme, textTheme, state);
        }

        return _buildPantallaPrincipal(correo, colorScheme, textTheme, state, accesoInfo);
      },
      loading: () => _buildPantallaCargando(colorScheme, textTheme),
      error: (error, stack) => _buildPantallaError(colorScheme, textTheme),
    );
  }

  Widget _buildPantallaCargando(ColorScheme colorScheme, TextTheme textTheme) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const AppTopBar(title: "Correo Electrónico"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/perfil'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Verificando estado del correo...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPantallaPrincipal(
      String correo,
      ColorScheme colorScheme,
      TextTheme textTheme,
      state,
      accesoInfo,
      ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const AppTopBar(title: "Correo Electrónico"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/perfil'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTarjetaCorreo(correo, colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildSeccionDireccionCorreo(correo, state, colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildBotonPrincipal(state, colorScheme, textTheme),
            const SizedBox(height: 24),
            _buildSeccionInformativa(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildPantallaIngresoCodigo(
      String correo,
      ColorScheme colorScheme,
      TextTheme textTheme,
      state,
      ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const AppTopBar(title: "Verificar Correo"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: _cancelarVerificacion,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.email_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ingresa el código de verificación',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                children: [
                  const TextSpan(
                    text: 'Ingresa el código de 6 dígitos que enviamos a:\n',
                  ),
                  TextSpan(
                    text: correo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildCampoCodigoMejorado(colorScheme, textTheme),
            const SizedBox(height: 32),
            if (state.isLoading)
              Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              )
            else
              FilledButton.icon(
                onPressed: _verificarCodigo,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Verificar Código'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _cancelarVerificacion,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancelar'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: state.isLoading ? null : _enviarCodigo,
                child: Text(
                  '¿No recibiste el código? Reenviar',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoCodigoMejorado(
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return TextField(
      controller: _codigoController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      autofocus: true,
      style: textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 16,
        color: colorScheme.primary,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: '• • • • • •',
        hintStyle: textTheme.displaySmall?.copyWith(
          letterSpacing: 16,
          color: colorScheme.onSurface.withOpacity(0.3),
        ),
        counterText: '',
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
          BorderSide(color: colorScheme.outline.withOpacity(0.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 3),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
      ),
    );
  }

  Widget _buildTarjetaCorreo(
      String correo,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.email_outlined,
              color: colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Correo Electrónico',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona y verifica tu correo electrónico',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionDireccionCorreo(
      String correo,
      state,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    final estaVerificado = state.verificacion?.estaVerificado ?? false;
    final estadoTexto = state.verificacion?.estadoTexto ?? 'Sin verificar';

    Color badgeColor;
    if (estaVerificado) {
      badgeColor = Colors.green;
    } else if (state.verificacion?.estaPendiente ?? false) {
      badgeColor = Colors.blue;
    } else {
      badgeColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mail_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Dirección de Correo',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    correo,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    estadoTexto,
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonPrincipal(
      state,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return FilledButton.icon(
      onPressed: _enviarCodigo,
      icon: const Icon(Icons.send),
      label: const Text('Verificar Correo'),
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSeccionInformativa(
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                '¿Por qué verificar tu correo?',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildItemInformativo(
            '• Asegura que las ofertas laborales lleguen directamente a tu bandeja',
            colorScheme,
            textTheme,
          ),
          _buildItemInformativo(
            '• Permite recuperar tu cuenta en caso de olvido de contraseña',
            colorScheme,
            textTheme,
          ),
          _buildItemInformativo(
            '• Protege tu perfil de accesos no autorizados',
            colorScheme,
            textTheme,
          ),
          _buildItemInformativo(
            '• Aumenta la confianza de los empleadores',
            colorScheme,
            textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildItemInformativo(
      String texto,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.8),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildPantallaVerificado(
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const AppTopBar(title: "Correo Electrónico"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/perfil'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '¡Correo Verificado!',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Tu correo electrónico ha sido verificado exitosamente',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go('/perfil'),
                child: const Text('Volver al perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPantallaError(
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const AppTopBar(title: "Correo Electrónico"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 24),
              Text(
                'No se encontró el correo',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Por favor, inicia sesión nuevamente para continuar',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  ref.read(sessionProvider.notifier).clearSession();
                  context.go('/bienvenida');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}