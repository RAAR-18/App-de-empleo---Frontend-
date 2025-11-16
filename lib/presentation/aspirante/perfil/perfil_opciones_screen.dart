import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/core/di/providers.dart';
import 'package:oasis/core/ui/app_bottom_bar.dart';
import 'package:oasis/core/ui/app_top_bar.dart';
import 'package:oasis/presentation/aspirante/perfil/perfil_resumen_card.dart';

class PerfilOpcionesScreen extends ConsumerWidget {
  const PerfilOpcionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final perfilAsync = ref.watch(perfilProvider);
    final palabrasClaveAsync = ref.watch(palabrasClaveProvider);

    final idUsuario = session.userId;
    final fotoPerfilAsync = idUsuario != null
        ? ref.watch(fotoPerfilProvider(idUsuario))
        : const AsyncValue.data(null);

    final opciones = [
      "Datos básicos",
      "Mi CV",
      "Competencias y habilidades",
      "Portafolio",
      "Configuración general",
      "Cerrar sesión",
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(perfilProvider);
          ref.invalidate(palabrasClaveProvider);
          if (idUsuario != null) {
            ref.invalidate(fotoPerfilProvider(idUsuario));
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              elevation: 2,
              title: const AppTopBar(title: "Perfil"),
            ),

            SliverToBoxAdapter(
              child: _buildPerfilCard(
                context,
                ref,
                perfilAsync,
                palabrasClaveAsync,
                fotoPerfilAsync,
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final opcion = opciones[index];
                  final isCerrarSesion = opcion == "Cerrar sesión";

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
                        opcion,
                        style: textTheme.titleMedium?.copyWith(
                          color: isCerrarSesion
                              ? colorScheme.error
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () async {
                        switch (opcion) {
                          case "Datos básicos":
                            context.go('/perfil/datos');
                            break;
                          case "Mi CV":
                            context.go('/perfil/cv');
                            break;
                          case "Competencias y habilidades":
                            context.go('/perfil/competencias');
                            break;
                          case "Portafolio":
                            context.go('/perfil/portafolio');
                            break;
                          case "Cerrar sesión":
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Cerrar sesión"),
                                  content: const Text(
                                    "¿Estás seguro de que deseas cerrar la sesión?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Aceptar"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmar == true) {
                              ref.read(sessionProvider.notifier).clearSession();
                              if (context.mounted) {
                                context.go('/bienvenida');
                              }
                            }
                            break;
                        }
                      },
                    ),
                  );
                },
                childCount: opciones.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: 4,
        profileImageBase64: session.imageBase64,
      ),
    );
  }

  Widget _buildPerfilCard(
      BuildContext context,
      WidgetRef ref,
      AsyncValue perfilAsync,
      AsyncValue palabrasClaveAsync,
      AsyncValue<String?> fotoPerfilAsync,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (perfilAsync.isLoading || palabrasClaveAsync.isLoading) {
      return Container(
        margin: const EdgeInsets.all(16),
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      );
    }

    if (perfilAsync.hasError) {
      return _buildErrorCard(
        context,
        ref,
        'Error al cargar el perfil',
        perfilAsync.error.toString(),
      );
    }

    if (palabrasClaveAsync.hasError) {
      return _buildErrorCard(
        context,
        ref,
        'Error al cargar palabras clave',
        palabrasClaveAsync.error.toString(),
      );
    }

    if (perfilAsync.hasValue && palabrasClaveAsync.hasValue) {
      final perfil = perfilAsync.value;
      final palabrasClave = palabrasClaveAsync.value ?? [];

      // Convertir List<PalabraClave> a List<String>
      final palabrasClaveTexto = palabrasClave
          .map((p) => p.textoPalabraClave)
          .toList()
          .cast<String>();

      return PerfilResumenCard(
        nombre: perfil.nombreCompleto,
        profesion: perfil.profesion ?? 'Si especificar',
        ubicacion: perfil.ubicacion ?? 'Ubicacion no registrada ',
        progreso: 0.7,
        palabrasClave: palabrasClaveTexto,
        urlFotoPerfil: fotoPerfilAsync.value,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorCard(
      BuildContext context,
      WidgetRef ref,
      String titulo,
      String mensaje,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mensaje,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ref.invalidate(perfilProvider);
              ref.invalidate(palabrasClaveProvider);
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}