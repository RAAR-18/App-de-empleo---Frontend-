import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/application/palabras_clave_notifier.dart';
import 'package:oasis/domain/model/palabra_clave.dart';
import 'package:oasis/core/ui/app_bottom_bar.dart';

class PalabrasClaveScreen extends ConsumerStatefulWidget {
  const PalabrasClaveScreen({super.key});

  @override
  ConsumerState<PalabrasClaveScreen> createState() => _PalabrasClaveScreenState();
}

class _PalabrasClaveScreenState extends ConsumerState<PalabrasClaveScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(sessionProvider);
      if (session.userId != null) {
        ref.read(palabrasClaveNotifierProvider.notifier)
            .cargarPalabrasClave(session.userId!);
      }
    });

    _searchController.addListener(() {
      ref.read(palabrasClaveNotifierProvider.notifier)
          .actualizarTextoBusqueda(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final session = ref.watch(sessionProvider);
    final state = ref.watch(palabrasClaveNotifierProvider);
    final notifier = ref.read(palabrasClaveNotifierProvider.notifier);

    // Cargar catálogo de palabras disponibles
    final catalogoAsync = ref.watch(catalogoPalabrasClaveProvider);

    ref.listen<PalabrasClaveState>(
      palabrasClaveNotifierProvider,
          (previous, next) {
        if (next.error != null && next.error != previous?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          notifier.limpiarError();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Palabras Clave'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading || catalogoAsync.isLoading
          ? Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      )
          : catalogoAsync.when(
        data: (catalogo) => _buildContent(
          context,
          colorScheme,
          textTheme,
          state,
          notifier,
          catalogo,
          session.userId!,
        ),
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error al cargar el catálogo', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(error.toString(), style: textTheme.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(catalogoPalabrasClaveProvider),
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

  Widget _buildContent(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      PalabrasClaveState state,
      PalabrasClaveNotifier notifier,
      List<PalabraClave> catalogo,
      int userId,
      ) {
    // Filtrar catálogo según búsqueda
    final palabrasFiltradas = state.textoBusqueda.isEmpty
        ? <PalabraClave>[]
        : catalogo.where((palabra) {
      return palabra.textoPalabraClave
          .toLowerCase()
          .contains(state.textoBusqueda.toLowerCase());
    }).toList();

    // Obtener palabras seleccionadas del catálogo
    final palabrasSeleccionadas = catalogo
        .where((p) => state.idsSeleccionados.contains(p.idPalabraClave))
        .toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de agregar palabra clave
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Agregar Palabra Clave',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nueva habilidad o tecnología',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Campo de búsqueda
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Ej: React, Python, Diseño UI',
                          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                          suffixIcon: state.textoBusqueda.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              notifier.limpiarBusqueda();
                            },
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                        ),
                      ),
                      // Mostrar sugerencias si hay búsqueda
                      if (state.textoBusqueda.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        if (palabrasFiltradas.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 20, color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No se encontraron resultados',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: palabrasFiltradas.length,
                              itemBuilder: (context, index) {
                                final palabra = palabrasFiltradas[index];
                                final yaSeleccionada = state.idsSeleccionados.contains(palabra.idPalabraClave);

                                return ListTile(
                                  dense: true,
                                  title: Text(palabra.textoPalabraClave),
                                  trailing: yaSeleccionada
                                      ? Icon(Icons.check_circle, color: colorScheme.primary)
                                      : Icon(Icons.add_circle_outline, color: colorScheme.primary),
                                  onTap: yaSeleccionada
                                      ? null
                                      : () {
                                    notifier.agregarPalabraClave(palabra.idPalabraClave);
                                    _searchController.clear();
                                    notifier.limpiarBusqueda();
                                    _searchFocusNode.unfocus();
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                      const SizedBox(height: 12),
                      // Info helper
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 20, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Las palabras clave ayudan a los empleadores a encontrar tu perfil cuando buscan candidatos con habilidades específicas.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de palabras seleccionadas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tag, color: colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Mis Palabras Clave',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${palabrasSeleccionadas.length}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (palabrasSeleccionadas.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No has agregado palabras clave',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: palabrasSeleccionadas.map((palabra) {
                            return Chip(
                              label: Text(palabra.textoPalabraClave),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => notifier.eliminarPalabraClave(palabra.idPalabraClave),
                              backgroundColor: colorScheme.primary,
                              labelStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              deleteIconColor: colorScheme.onPrimary,
                              side: BorderSide.none,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Botones de acción (fijos al fondo)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: state.isSaving || state.idsSeleccionados.isEmpty
                        ? null
                        : () async {
                      final guardado = await notifier.guardarCambios(userId);

                      if (guardado && mounted) {
                        // Invalidar providers para recargar
                        ref.invalidate(palabrasClaveProvider);
                        ref.invalidate(perfilProvider);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Palabras clave actualizadas correctamente',
                            ),
                            backgroundColor: colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        context.pop();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isSaving
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                        : const Text(
                      'Guardar cambios',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}