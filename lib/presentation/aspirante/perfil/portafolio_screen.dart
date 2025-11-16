import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/domain/model/imagen_portafolio.dart';
import 'package:oasis/core/ui/app_bottom_bar.dart';

class PortafolioScreen extends ConsumerStatefulWidget {
  const PortafolioScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PortafolioScreen> createState() => _PortafolioScreenState();
}

class _PortafolioScreenState extends ConsumerState<PortafolioScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(sessionProvider);
      if (session.userId != null) {
        ref.read(portafolioNotifierProvider.notifier).cargarPortafolio(session.userId!);
      }
    });
  }

  Future<void> _agregarImagen() async {
    final session = ref.read(sessionProvider);
    if (session.userId == null) return;

    final state = ref.read(portafolioNotifierProvider);

    // Verificar si está en modo edición
    if (state.modoEdicion) {
      _mostrarMensaje('Debes salir del modo edición primero', false);
      return;
    }

    if (!state.puedeAgregarMas) {
      _mostrarMensaje('Has alcanzado el límite de ${state.limiteMaximo} imágenes', false);
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return;

      final nombreProyecto = await _mostrarDialogoNombre();
      if (nombreProyecto == null || nombreProyecto.trim().isEmpty) return;

      final exito = await ref
          .read(portafolioNotifierProvider.notifier)
          .subirImagen(session.userId!, image.path, nombreProyecto);

      if (exito && mounted) {
        final espacios = ref.read(portafolioNotifierProvider).espaciosRestantes;
        _mostrarMensaje('Imagen agregada. $espacios espacios restantes', true);
      }
    } catch (e) {
      _mostrarMensaje('Error: ${e.toString()}', false);
    }
  }

  Future<String?> _mostrarDialogoNombre() async {
    final TextEditingController controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Nombre del Proyecto',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Ej: App Móvil de Finanzas',
            labelText: 'Nombre',
            hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            labelStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
          ),
          maxLength: 50,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarImagen(int idImagen) async {
    final session = ref.read(sessionProvider);
    if (session.userId == null) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Eliminar imagen',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          '¿Estás seguro de eliminar esta imagen?',
          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final exito = await ref
        .read(portafolioNotifierProvider.notifier)
        .eliminarImagen(idImagen, session.userId!);

    if (exito && mounted) {
      _mostrarMensaje('Imagen eliminada correctamente', true);
    }
  }

  void _verImagenCompleta(ImagenPortafolio imagen) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imagen.urlImagen,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red, size: 48),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black87 : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  imagen.nombreProyecto,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black87 : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje, bool esExito) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esExito ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(portafolioNotifierProvider);
    final session = ref.watch(sessionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores adaptativos
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.go('/perfil'),
        ),
        title: Text(
          'Portafolio',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: state.isLoading && state.imagenes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(subtextColor),

            if (state.imagenes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildGridImagenes(state, isDark, cardColor, borderColor, textColor),
              ),

            if (state.puedeAgregarMas && !state.modoEdicion)
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildBotonAgregar(state, isDark, borderColor, subtextColor),
              ),

            if (state.modoEdicion)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Modo edición activo. Toca una imagen para eliminarla.',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildEstadisticas(state, borderColor, textColor, subtextColor),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBotonEliminar(state),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildTip(isDark),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: 4,
        profileImageBase64: session.imageBase64,
      ),
    );
  }

  Widget _buildHeader(Color subtextColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 48,
            color: subtextColor,
          ),
          const SizedBox(height: 12),
          Text(
            'Muestra tus mejores proyectos y trabajos realizados',
            style: TextStyle(color: subtextColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGridImagenes(state, bool isDark, Color cardColor, Color borderColor, Color textColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: state.imagenes.length,
      itemBuilder: (context, index) {
        final imagen = state.imagenes[index];
        return _buildTarjetaImagen(imagen, state.modoEdicion, isDark, cardColor, borderColor, textColor);
      },
    );
  }

  Widget _buildTarjetaImagen(
      ImagenPortafolio imagen,
      bool modoEdicion,
      bool isDark,
      Color cardColor,
      Color borderColor,
      Color textColor,
      ) {
    return GestureDetector(
      onTap: modoEdicion ? () => _eliminarImagen(imagen.idImagen) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: imagen.urlImagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  if (modoEdicion)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete, color: Colors.white, size: 20),
                      ),
                    ),
                  if (!modoEdicion)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _verImagenCompleta(imagen),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                imagen.nombreProyecto,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonAgregar(state, bool isDark, Color borderColor, Color subtextColor) {
    return InkWell(
      onTap: state.isLoading ? null : _agregarImagen,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 32,
                color: isDark ? Colors.blue[300] : Colors.blue[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agregar nuevo proyecto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sube imágenes y detalles de tu trabajo',
              style: TextStyle(fontSize: 13, color: subtextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticas(state, Color borderColor, Color textColor, Color subtextColor) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${state.totalProyectos}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Proyectos',
                  style: TextStyle(fontSize: 13, color: subtextColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonEliminar(state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.imagenes.isEmpty
                ? null
                : () => ref.read(portafolioNotifierProvider.notifier).toggleModoEdicion(),
            icon: Icon(state.modoEdicion ? Icons.check : Icons.edit, size: 18),
            label: Text(
              state.modoEdicion ? 'Terminar edición' : 'Eliminar proyecto',
              style: const TextStyle(fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTip(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.blue[700]! : Colors.blue[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: isDark ? Colors.blue[300] : Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip profesional',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.blue[200] : Colors.blue[900],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mantén tu portafolio actualizado con tus proyectos más recientes y destacados.',
                  style: TextStyle(
                    color: isDark ? Colors.blue[100] : Colors.blue[800],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}