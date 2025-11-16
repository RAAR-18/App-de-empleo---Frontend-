import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/domain/model/ubicacion.dart';
import 'package:oasis/application/datos_basicos_editar_notifier.dart';
import 'package:oasis/core/ui/app_bottom_bar.dart';

class DatosBasicosScreen extends ConsumerStatefulWidget {
  const DatosBasicosScreen({super.key});

  @override
  ConsumerState<DatosBasicosScreen> createState() =>
      _DatosBasicosScreenState();
}

class _DatosBasicosScreenState extends ConsumerState<DatosBasicosScreen> {
  // Controladores de texto
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _documentoController = TextEditingController();
  final _profesionController = TextEditingController();
  final _ubicacionController = TextEditingController();

  // Variables de estado
  Ubicacion? _ubicacionSeleccionada;
  File? _imagenSeleccionada;
  bool _subiendoImagen = false;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _documentoController.dispose();
    _profesionController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final datosBasicosAsync = ref.watch(datosBasicosProvider);
    final edicionState = ref.watch(datosBasicosEdicionNotifierProvider);
    final session = ref.watch(sessionProvider);
    final idUsuario = session.userId;

    final fotoPerfilAsync = idUsuario != null
        ? ref.watch(fotoPerfilProvider(idUsuario))
        : const AsyncValue.data(null);


    ref.listen<DatosBasicosEdicionState>(
      datosBasicosEdicionNotifierProvider,
          (previous, next) {
        if (next.estado == EdicionEstado.exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Datos actualizados correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          ref.invalidate(datosBasicosProvider);
          if (idUsuario != null) {
            ref.invalidate(fotoPerfilProvider(idUsuario));
          }
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .limpiarEstado();
            }
          });
        } else if (next.estado == EdicionEstado.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.mensajeError}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    final bool modoEdicion = edicionState.estado == EdicionEstado.editando ||
        edicionState.estado == EdicionEstado.guardando;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () {
                  if (modoEdicion && edicionState.hayCambios) {
                    _mostrarDialogoCancelar(context, ref);
                  } else {
                    context.go('/perfil');
                  }
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Datos Básicos',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      modoEdicion
                          ? 'Editando información'
                          : 'Información personal y profesional',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!modoEdicion)
                datosBasicosAsync.when(
                  data: (datos) => IconButton(
                    icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                    onPressed: () {
                      ref
                          .read(datosBasicosEdicionNotifierProvider.notifier)
                          .iniciarEdicion(datos);

                      // Inicializar controladores
                      _nombresController.text = datos.nombresUsuario;
                      _apellidosController.text = datos.apellidosUsuario;
                      _documentoController.text = datos.documentoUsuario;
                      _profesionController.text = datos.profesion;
                      _ubicacionController.text = datos.ubicacion;
                      _ubicacionSeleccionada = datos.idUbicacion != null
                          ? Ubicacion(
                        idUbicacion: datos.idUbicacion!,
                        nombreUbicacion: datos.ubicacion,
                      )
                          : null;
                    },
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
      body: datosBasicosAsync.when(
        data: (datosBasicos) {
          if (!modoEdicion) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _nombresController.text = datosBasicos.nombresUsuario;
                _apellidosController.text = datosBasicos.apellidosUsuario;
                _documentoController.text = datosBasicos.documentoUsuario;
                _profesionController.text = datosBasicos.profesion;
                _ubicacionController.text = datosBasicos.ubicacion;
              }
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSeccionFotoPerfil(
                  context,
                  colorScheme,
                  textTheme,
                  fotoPerfilAsync,
                  modoEdicion,
                ),
                const SizedBox(height: 24),
                _buildSeccionInformacionPersonal(
                  context,
                  colorScheme,
                  textTheme,
                  modoEdicion,
                ),
                const SizedBox(height: 24),
                _buildSeccionInformacionProfesional(
                  context,
                  colorScheme,
                  textTheme,
                  modoEdicion,
                ),
                const SizedBox(height: 24),
                if (modoEdicion) _buildBotonesAccion(context, colorScheme),
                const SizedBox(height: 16),
                _buildFooterInformativo(context, colorScheme, textTheme),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error al cargar datos', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(datosBasicosProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: 4,
        profileImageBase64: session.imageBase64,
      ),
    );
  }

  Widget _buildSeccionFotoPerfil(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      AsyncValue<String?> fotoPerfilAsync,
      bool modoEdicion,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Foto de Perfil',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Avatar
          Stack(
            children: [
              GestureDetector(
                onTap: modoEdicion ? _seleccionarImagen : null,
                child: fotoPerfilAsync.when(
                  data: (urlFoto) {
                    // Si hay imagen seleccionada localmente, mostrarla
                    if (_imagenSeleccionada != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: FileImage(_imagenSeleccionada!),
                      );
                    }

                    // Si hay URL de foto de perfil, mostrarla
                    if (urlFoto != null && urlFoto.isNotEmpty) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: NetworkImage(urlFoto),
                        onBackgroundImageError: (exception, stackTrace) {
                        },
                      );
                    }

                    // Si no hay foto, mostrar icono
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    );
                  },
                  loading: () => CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primaryContainer,
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: colorScheme.error,
                      ),
                    );
                  },
                ),
              ),

              // Indicador de carga al subir imagen
              if (_subiendoImagen)
                Positioned.fill(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black54,
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                ),

              // Botón de editar en modo edición
              if (modoEdicion && !_subiendoImagen)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _seleccionarImagen,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          if (modoEdicion && !_subiendoImagen) ...[
            const SizedBox(height: 12),
            Text(
              'Toca para cambiar la foto',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Sección: Información Personal
  Widget _buildSeccionInformacionPersonal(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      bool modoEdicion,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Información Personal',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nombres
          _buildCampo(
            context,
            'Nombres',
            _nombresController,
            colorScheme,
            textTheme,
            modoEdicion,
            onChanged: (value) {
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .actualizarNombres(value);
            },
          ),
          const SizedBox(height: 12),

          // Apellidos
          _buildCampo(
            context,
            'Apellidos',
            _apellidosController,
            colorScheme,
            textTheme,
            modoEdicion,
            onChanged: (value) {
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .actualizarApellidos(value);
            },
          ),
          const SizedBox(height: 12),

          // Documento
          _buildCampo(
            context,
            'Número de Cédula',
            _documentoController,
            colorScheme,
            textTheme,
            modoEdicion,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .actualizarDocumento(value);
            },
          ),
        ],
      ),
    );
  }

  // Sección: Información Profesional
  Widget _buildSeccionInformacionProfesional(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      bool modoEdicion,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Información Profesional',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Profesión
          _buildCampo(
            context,
            'Profesión/Cargo',
            _profesionController,
            colorScheme,
            textTheme,
            modoEdicion,
            onChanged: (value) {
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .actualizarProfesion(value);
            },
          ),
          const SizedBox(height: 12),

          // Ubicación con autocompletado
          _buildCampoUbicacion(
            context,
            colorScheme,
            textTheme,
            modoEdicion,
          ),
        ],
      ),
    );
  }

  // Campo de texto (lectura o edición)
  Widget _buildCampo(
      BuildContext context,
      String label,
      TextEditingController controller,
      ColorScheme colorScheme,
      TextTheme textTheme,
      bool modoEdicion, {
        TextInputType? keyboardType,
        Function(String)? onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: modoEdicion,
          keyboardType: keyboardType,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: modoEdicion
                ? colorScheme.surface
                : colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Campo de ubicación con autocompletado
  Widget _buildCampoUbicacion(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      bool modoEdicion,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubicación',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        if (!modoEdicion)
          TextFormField(
            controller: _ubicacionController,
            enabled: false,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
          )
        else
          Autocomplete<Ubicacion>(
            initialValue: TextEditingValue(text: _ubicacionController.text),
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Ubicacion>.empty();
              }

              try {
                final useCase = ref.read(buscarUbicacionesUseCaseProvider);
                final ubicaciones = await useCase(textEditingValue.text);
                return ubicaciones;
              } catch (e) {
                return const Iterable<Ubicacion>.empty();
              }
            },
            displayStringForOption: (Ubicacion ubicacion) =>
            ubicacion.nombreUbicacion,
            onSelected: (Ubicacion ubicacion) {
              setState(() {
                _ubicacionSeleccionada = ubicacion;
                _ubicacionController.text = ubicacion.nombreUbicacion;
              });
              ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .actualizarUbicacion(
                ubicacion.idUbicacion,
                ubicacion.nombreUbicacion,
              );
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              // Sincronizar con nuestro controller al entrar en modo edición
              if (_ubicacionController.text.isNotEmpty && controller.text.isEmpty) {
                controller.text = _ubicacionController.text;
              }

              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  suffixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  hintText: 'Escribe para buscar...',
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: MediaQuery.of(context).size.width - 64,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final ubicacion = options.elementAt(index);
                        return ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: colorScheme.primary,
                          ),
                          title: Text(
                            ubicacion.nombreUbicacion,
                            style: textTheme.bodyMedium,
                          ),
                          onTap: () => onSelected(ubicacion),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // Botones de acción (Guardar / Cancelar)
  Widget _buildBotonesAccion(BuildContext context, ColorScheme colorScheme) {
    final edicionState = ref.watch(datosBasicosEdicionNotifierProvider);
    final guardando = edicionState.estado == EdicionEstado.guardando;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: guardando
                ? null
                : () {
              if (edicionState.hayCambios) {
                _mostrarDialogoCancelar(context, ref);
              } else {
                ref
                    .read(datosBasicosEdicionNotifierProvider.notifier)
                    .cancelar();
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: guardando
                ? null
                : () async {
              // Subir imagen primero si hay una seleccionada
              if (_imagenSeleccionada != null) {
                await _subirImagenPerfil();
              }
              // Guardar datos
              await ref
                  .read(datosBasicosEdicionNotifierProvider.notifier)
                  .guardarCambios();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: guardando
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            )
                : const Text('Guardar cambios'),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterInformativo(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Estos datos son utilizados únicamente para procesos de verificación y contacto relacionados con oportunidades laborales. Tu información está protegida según nuestras políticas de privacidad.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Seleccionar imagen desde galería
  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagenSeleccionada = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Subir imagen de perfil
  Future<void> _subirImagenPerfil() async {
    if (_imagenSeleccionada == null) return;

    setState(() => _subiendoImagen = true);

    try {
      final session = ref.read(sessionProvider);
      final idUsuario = session.userId;

      if (idUsuario == null) {
        throw Exception('No hay usuario en sesión');
      }

      final useCase = ref.read(subirFotoPerfilUseCaseProvider);
      await useCase(idUsuario, _imagenSeleccionada!.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }

      setState(() {
        _imagenSeleccionada = null;
      });

      // Refrescar provider de foto
      ref.invalidate(fotoPerfilProvider(idUsuario));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _subiendoImagen = false);
    }
  }

  // Mostrar diálogo de confirmación al cancelar
  void _mostrarDialogoCancelar(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar edición?'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Estás seguro de que deseas cancelar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(datosBasicosEdicionNotifierProvider.notifier).cancelar();
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}