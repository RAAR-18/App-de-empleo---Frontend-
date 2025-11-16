import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/core/ui/app_bottom_bar.dart';
import 'package:oasis/core/ui/app_top_bar.dart';
import 'package:oasis/domain/model/rel_usuario_talento.dart';
import 'package:oasis/domain/model/talento.dart';

class CompetenciasHabilidadesScreen extends ConsumerWidget {
  const CompetenciasHabilidadesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final talentosAsync = ref.watch(talentosUsuarioProvider);
    final estadisticasAsync = ref.watch(estadisticasTalentosProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(talentosUsuarioProvider);
          ref.invalidate(estadisticasTalentosProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              elevation: 2,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => context.go('/perfil'),
              ),
              title: const AppTopBar(title: "Competencias Y Habilidades"),
            ),

            // Descripción
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gestiona tus habilidades profesionales y niveles de dominio',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Lista de talentos
            talentosAsync.when(
              data: (talentos) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final talento = talentos[index];
                      return _buildTalentoCard(context, ref, talento);
                    },
                    childCount: talentos.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text('Error al cargar competencias'),
                      const SizedBox(height: 8),
                      Text('$e', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          ref.invalidate(talentosUsuarioProvider);
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sección de agregar nueva competencia
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => _mostrarDialogoAgregar(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Agregar nueva competencia',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Añade una nueva habilidad a tu perfil profesional',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Estadísticas
            SliverToBoxAdapter(
              child: estadisticasAsync.when(
                data: (stats) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${stats.totalTalentos}',
                          'Total Competencias',
                          colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          '${stats.nivelAvanzado}',
                          'Nivel Avanzado',
                          colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (e, st) => const SizedBox.shrink(),
              ),
            ),

            // Tip profesional
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tip profesional',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mantén actualizadas tus competencias y agrega nuevas habilidades según evoluciona tu carrera profesional.',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Espacio inferior
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomBar(
        currentIndex: 4,
        profileImageBase64: session.imageBase64,
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String valor, String titulo, Color color) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.outline.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: textTheme.displaySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTalentoCard(
      BuildContext context, WidgetRef ref, RelUsuarioTalento talento) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.outline.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          talento.nombreTalento,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getNivelColor(talento.nivelDominio),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                talento.nivelTexto,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onSelected: (value) {
                if (value == 'editar') {
                  _mostrarDialogoEditar(context, ref, talento);
                } else if (value == 'eliminar') {
                  _confirmarEliminar(context, ref, talento);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Editar nivel'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'eliminar',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getNivelColor(NivelDominio nivel) {
    switch (nivel) {
      case NivelDominio.basico:
        return Colors.orange;
      case NivelDominio.intermedio:
        return Colors.blue;
      case NivelDominio.avanzado:
        return Colors.green;
    }
  }

  Future<void> _mostrarDialogoAgregar(
      BuildContext context, WidgetRef ref) async {
    try {
      final catalogo = await ref.read(catalogoTalentosProvider.future);

      if (!context.mounted) return;

      Talento? talentoSeleccionado;
      NivelDominio nivelSeleccionado = NivelDominio.basico;
      final textController = TextEditingController();

      final resultado = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Agregar competencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Autocomplete<Talento>(
                  displayStringForOption: (Talento option) => option.nombre,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Talento>.empty();
                    }
                    return catalogo.where((Talento option) {
                      return option.nombre
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (Talento selection) {
                    setState(() {
                      talentoSeleccionado = selection;
                      textController.text = selection.nombre;
                    });
                  },
                  fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted,
                      ) {
                    // Sincronizar el controlador
                    if (textController.text.isNotEmpty &&
                        fieldTextEditingController.text.isEmpty) {
                      fieldTextEditingController.text = textController.text;
                    }

                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Busca una competencia',
                        hintText: 'Escribe para buscar...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // Limpiar selección si el texto cambia
                        if (talentoSeleccionado != null &&
                            value != talentoSeleccionado!.nombre) {
                          setState(() {
                            talentoSeleccionado = null;
                          });
                        }
                      },
                    );
                  },
                  optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<Talento> onSelected,
                      Iterable<Talento> options,
                      ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                            maxWidth: 300,
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Talento option = options.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(option.nombre),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<NivelDominio>(
                  decoration: const InputDecoration(
                    labelText: 'Nivel de dominio',
                    border: OutlineInputBorder(),
                  ),
                  value: nivelSeleccionado,
                  items: NivelDominio.values.map((n) {
                    return DropdownMenuItem(
                      value: n,
                      child: Text(n.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => nivelSeleccionado = value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  textController.dispose();
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: talentoSeleccionado == null
                    ? null
                    : () {
                  textController.dispose();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
      );

      if (resultado == true && talentoSeleccionado != null) {
        try {
          final session = ref.read(sessionProvider);
          final useCase = ref.read(agregarTalentoUseCaseProvider);

          await useCase(
            session.userId!,
            talentoSeleccionado!.idTalento,
            nivelSeleccionado.valor,
          );

          ref.invalidate(talentosUsuarioProvider);
          ref.invalidate(estadisticasTalentosProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Competencia agregada correctamente')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar catálogo: $e')),
        );
      }
    }
  }

  Future<void> _mostrarDialogoEditar(
      BuildContext context, WidgetRef ref, RelUsuarioTalento talento) async {
    NivelDominio nivelSeleccionado = talento.nivelDominio;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Editar ${talento.nombreTalento}'),
          content: DropdownButtonFormField<NivelDominio>(
            decoration: const InputDecoration(
              labelText: 'Nivel de dominio',
              border: OutlineInputBorder(),
            ),
            value: nivelSeleccionado,
            items: NivelDominio.values.map((n) {
              return DropdownMenuItem(
                value: n,
                child: Text(n.nombre),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => nivelSeleccionado = value);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (resultado == true) {
      try {
        final useCase = ref.read(editarNivelTalentoUseCaseProvider);
        await useCase(
            talento.idUsuario, talento.idTalento, nivelSeleccionado.valor);

        ref.invalidate(talentosUsuarioProvider);
        ref.invalidate(estadisticasTalentosProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nivel actualizado correctamente')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _confirmarEliminar(
      BuildContext context, WidgetRef ref, RelUsuarioTalento talento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar competencia'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${talento.nombreTalento}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        final useCase = ref.read(eliminarTalentoUseCaseProvider);
        await useCase(talento.idUsuario, talento.idTalento);

        ref.invalidate(talentosUsuarioProvider);
        ref.invalidate(estadisticasTalentosProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Competencia eliminada correctamente')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}