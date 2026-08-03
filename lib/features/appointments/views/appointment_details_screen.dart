import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecare_doctor_app/features/vediocalls/views/video_call_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../notes/views/notes_list_screen.dart';
import '../models/appointment_model.dart';
import '../providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appointment =
        context.watch<AppointmentProvider>().appointment;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Details',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _PatientHeader(
                patientName:
                    appointment.patientName,
                patientId:
                    appointment.patientId,
              ),

              const SizedBox(height: 24),

              Text(
                'Patient Information',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),

              const SizedBox(height: 14),

              Card(
                elevation: 0,
                color: Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  side: BorderSide(
                    color:
                        Colors.grey.shade200,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon:
                            Icons.cake_outlined,
                        label:
                            'Age',
                        value:
                            '${appointment.age} years',
                      ),

                      const Divider(
                        height: 28,
                      ),

                      _InfoRow(
                        icon:
                            Icons.phone_outlined,
                        label:
                            'Phone',
                        value:
                            appointment
                                .phoneNumber,
                      ),

                      const Divider(
                        height: 28,
                      ),

                      _InfoRow(
                        icon:
                            Icons.calendar_today_outlined,
                        label:
                            'Appointment',
                        value:
                            _formatDateTime(
                          appointment
                              .appointmentDateTime,
                        ),
                      ),

                      const Divider(
                        height: 28,
                      ),

                      _InfoRow(
                        icon:
                            Icons.info_outline,
                        label:
                            'Status',
                        value:
                            _statusText(
                          appointment.status,
                        ),
                        valueColor:
                            _statusColor(
                          appointment.status,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Session',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),

              const SizedBox(height: 14),
_NotesCard(
  onTap: () {
    final doctorId =
        FirebaseAuth.instance.currentUser?.uid ??
            'doctor_demo';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotesListScreen(
  appointmentId: appointment.id,
  doctorId: doctorId,
)
      ),
    );
  },
),
              const SizedBox(height: 28),

              if (appointment.status ==
                  AppointmentStatus
                      .confirmed)
                SizedBox(
                  width:
                      double.infinity,
                  height:
                      54,
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoCallScreen(
                            appointmentId:
                                appointment.id,
                            patientName:
                                appointment
                                    .patientName,
                          ),
                        ),
                      );
                    },
                    icon:
                        const Icon(
                      Icons
                          .videocam_rounded,
                    ),
                    label:
                        const Text(
                      'Start Video Call',
                    ),
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          AppColors.primary,
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

              if (appointment.status ==
                  AppointmentStatus
                      .unconfirmed)
                SizedBox(
                  width:
                      double.infinity,
                  height:
                      54,
                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      _showCancelDialog(
                        context,
                      );
                    },
                    icon:
                        const Icon(
                      Icons
                          .cancel_outlined,
                    ),
                    label:
                        const Text(
                      'Cancel Appointment',
                    ),
                    style:
                        OutlinedButton
                            .styleFrom(
                      foregroundColor:
                          AppColors.error,
                      side:
                          const BorderSide(
                        color:
                            AppColors.error,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

              if (appointment.status ==
                  AppointmentStatus
                      .cancelled)
                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.error
                            .withValues(
                      alpha: 0.08,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),
                  ),
                  child:
                      const Row(
                    children: [
                      Icon(
                        Icons
                            .cancel_rounded,
                        color:
                            AppColors.error,
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                            Text(
                          'This appointment has been cancelled.',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title: const Text(
            'Cancel Appointment?',
          ),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'Keep',
              ),
            ),

            TextButton(
              onPressed: () {
                context
                    .read<
                      AppointmentProvider
                    >()
                    .cancelAppointment();

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Appointment cancelled',
                    ),
                  ),
                );
              },
              child:
                  const Text(
                'Cancel Appointment',
                style: TextStyle(
                  color:
                      AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(
    DateTime dateTime,
  ) {
    final hour =
        dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour == 0
                ? 12
                : dateTime.hour;

    final minute =
        dateTime.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final period =
        dateTime.hour >= 12
            ? 'PM'
            : 'AM';

    return '${dateTime.day}/'
        '${dateTime.month}/'
        '${dateTime.year}, '
        '$hour:$minute $period';
  }

  String _statusText(
    AppointmentStatus status,
  ) {
    switch (status) {
      case AppointmentStatus
          .confirmed:
        return 'Confirmed';

      case AppointmentStatus
          .unconfirmed:
        return 'Unconfirmed';

      case AppointmentStatus
          .cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(
    AppointmentStatus status,
  ) {
    switch (status) {
      case AppointmentStatus
          .confirmed:
        return AppColors.success;

      case AppointmentStatus
          .unconfirmed:
        return Colors.orange;

      case AppointmentStatus
          .cancelled:
        return AppColors.error;
    }
  }
}

class _PatientHeader
    extends StatelessWidget {
  const _PatientHeader({
    required this.patientName,
    required this.patientId,
  });

  final String patientName;

  final String patientId;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child:
          Row(
        children: [
          const CircleAvatar(
            radius:
                34,
            backgroundColor:
                Colors.white24,
            child:
                Icon(
              Icons.person_rounded,
              color:
                  Colors.white,
              size:
                  38,
            ),
          ),

          const SizedBox(
            width:
                16,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  patientName,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        22,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                  height:
                      5,
                ),

                Text(
                  'Patient ID: $patientId',
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
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

class _InfoRow
    extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;

  final String label;

  final String value;

  final Color? valueColor;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          width:
              42,
          height:
              42,
          decoration:
              BoxDecoration(
            color:
                AppColors.primary
                    .withValues(
              alpha:
                  0.10,
            ),
            borderRadius:
                BorderRadius
                    .circular(
              12,
            ),
          ),
          child:
              Icon(
            icon,
            color:
                AppColors.primary,
          ),
        ),

        const SizedBox(
          width:
              14,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(
                  color:
                      AppColors
                          .textSecondary,
                  fontSize:
                      13,
                ),
              ),

              const SizedBox(
                height:
                    3,
              ),

              Text(
                value,
                style:
                    TextStyle(
                  color:
                      valueColor ??
                          AppColors
                              .textPrimary,
                  fontWeight:
                      FontWeight
                          .w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotesCard
    extends StatelessWidget {
  const _NotesCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      elevation:
          0,
      color:
          Colors.white,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        side:
            BorderSide(
          color:
              Colors.grey.shade200,
        ),
      ),
      child:
          ListTile(
        onTap:
            onTap,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal:
              18,
          vertical:
              8,
        ),
        leading:
            Container(
          width:
              44,
          height:
              44,
          decoration:
              BoxDecoration(
            color:
                AppColors.accent
                    .withValues(
              alpha:
                  0.10,
            ),
            borderRadius:
                BorderRadius
                    .circular(
              12,
            ),
          ),
          child:
              const Icon(
            Icons
                .description_outlined,
            color:
                AppColors.accent,
          ),
        ),
        title:
            const Text(
          'Session Notes',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w700,
          ),
        ),
        subtitle:
            const Text(
          'Add and view consultation notes',
        ),
        trailing:
            const Icon(
          Icons
              .arrow_forward_ios_rounded,
          size:
              17,
        ),
      ),
    );
  }
}