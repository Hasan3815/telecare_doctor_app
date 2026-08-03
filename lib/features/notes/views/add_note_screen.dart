import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/notes_provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    required this.appointmentId,
    required this.doctorId,
  });

  final String appointmentId;
  final String doctorId;

  @override
  State<AddNoteScreen> createState() =>
      _AddNoteScreenState();
}

class _AddNoteScreenState
    extends State<AddNoteScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _noteController =
      TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();

    super.dispose();
  }

  Future<void> _saveNote() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  

  final provider =
      context.read<NotesProvider>();

  final success =
      await provider.addNote(
    appointmentId:
        widget.appointmentId,
    doctorId:
        widget.doctorId,
    note:
        _noteController.text.trim(),
  );

  
  if (!mounted) {
    return;
  }

  if (success) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Session note saved successfully',
        ),
        backgroundColor:
            AppColors.success,
      ),
    );

    Navigator.pop(
      context,
    );

    return;
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(
    SnackBar(
      content: Text(
        provider.errorMessage ??
            'Unable to save note',
      ),
      backgroundColor:
          AppColors.error,
    ),
  );
}

  @override
  Widget build(
    BuildContext context,
  ) {
    final isSaving =
        context.watch<NotesProvider>()
            .isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Session Note',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFEEF2FF,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons
                            .medical_information_outlined,
                        color:
                            AppColors
                                .primary,
                      ),
                      SizedBox(
                        width:
                            12,
                      ),
                      Expanded(
                        child:
                            Text(
                          'Add clinical observations, treatment details, or follow-up instructions.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height:
                      24,
                ),
                Text(
                  'Session Note',
                  style:
                      Theme.of(
                    context,
                  )
                          .textTheme
                          .titleMedium,
                ),
                const SizedBox(
                  height:
                      10,
                ),
                TextFormField(
                  controller:
                      _noteController,
                  minLines:
                      8,
                  maxLines:
                      12,
                  textCapitalization:
                      TextCapitalization
                          .sentences,
                  decoration:
                      InputDecoration(
                    hintText:
                        'Write the session details here...',
                    alignLabelWithHint:
                        true,
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            AppColors
                                .primary,
                        width:
                            2,
                      ),
                    ),
                  ),
                  validator:
                      (
                    value,
                  ) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter a session note';
                    }

                    if (value
                            .trim()
                            .length <
                        10) {
                      return 'Note must contain at least 10 characters';
                    }

                    return null;
                  },
                ),
                const Spacer(),
                AppButton(
                  text:
                      isSaving
                          ? 'Saving...'
                          : 'Save Session Note',
                  onPressed:
                      isSaving
                          ? null
                          : _saveNote,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}