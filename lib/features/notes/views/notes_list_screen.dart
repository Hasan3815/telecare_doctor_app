import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../models/session_note_model.dart';
import '../providers/notes_provider.dart';
import 'add_note_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({
    super.key,
    required this.appointmentId,
    required this.doctorId,
  });

  final String appointmentId;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.read<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session Notes',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return AddNoteScreen(
                  appointmentId: appointmentId,
                  doctorId: doctorId,
                );
              },
            ),
          );
        },
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Note',
        ),
      ),
      body: StreamBuilder<List<SessionNoteModel>>(
        stream: notesProvider.getNotes(
          appointmentId: appointmentId,
        ),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const LoadingWidget(
              message: 'Loading session notes...',
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 56,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Unable to load notes',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 72,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'No session notes yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Tap “Add Note” to create the first session note.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount: notes.length,
            separatorBuilder: (
              context,
              index,
            ) {
              return const SizedBox(
                height: 12,
              );
            },
            itemBuilder: (
              context,
              index,
            ) {
              final note = notes[index];

              return _SessionNoteCard(
                note: note,
              );
            },
          );
        },
      ),
    );
  }
}

class _SessionNoteCard extends StatelessWidget {
  const _SessionNoteCard({
    required this.note,
  });

  final SessionNoteModel note;

  Future<void> _showDeleteDialog(
  BuildContext context,
) async {
  final shouldDelete =
      await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'Delete Session Note?',
        ),
        content: const Text(
          'This session note will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                false,
              );
            },
            child: const Text(
              'Cancel',
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                true,
              );
            },
            style:
                FilledButton.styleFrom(
              backgroundColor:
                  AppColors.error,
            ),
            child: const Text(
              'Delete',
            ),
          ),
        ],
      );
    },
  );

  if (shouldDelete != true ||
      !context.mounted) {
    return;
  }

  final provider =
      context.read<NotesProvider>();

  final success =
      await provider.deleteNote(
    noteId: note.id,
  );

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(
    SnackBar(
      content: Text(
        success
            ? 'Session note deleted'
            : provider.errorMessage ??
                'Unable to delete note',
      ),
      backgroundColor:
          success
              ? AppColors.success
              : AppColors.error,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final date =
        '${note.createdAt.day.toString().padLeft(2, '0')}/'
        '${note.createdAt.month.toString().padLeft(2, '0')}/'
        '${note.createdAt.year}';

    final time =
        '${note.createdAt.hour.toString().padLeft(2, '0')}:'
        '${note.createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
        side: const BorderSide(
          color: AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            
            Row(
  children: [
    const CircleAvatar(
      backgroundColor:
          Color(0xFFEDE9FE),
      child: Icon(
        Icons.description_outlined,
        color: AppColors.accent,
      ),
    ),
    const SizedBox(
      width: 12,
    ),
    Expanded(
      child: Text(
        'Doctor Session Note',
        style: Theme.of(
          context,
        ).textTheme.titleMedium,
      ),
    ),
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteDialog(
            context,
          );
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Delete Note',
                ),
              ],
            ),
          ),
        ];
      },
      icon: const Icon(
        Icons.more_vert_rounded,
      ),
    ),
  ],
),
            const SizedBox(
              height: 16,
            ),
            Text(
              note.note,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  '$date at $time',
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}