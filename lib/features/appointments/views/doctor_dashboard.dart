
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/appointment_model.dart';
import '../providers/appointment_provider.dart';
import 'appointment_details_screen.dart';

class DoctorDashboard
    extends StatelessWidget {
  const DoctorDashboard({
    super.key,
  });

  String _formatDate(
    DateTime dateTime,
  ) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour =
        dateTime.hour % 12 == 0
            ? 12
            : dateTime.hour % 12;

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

    return '${dateTime.day} '
        '${months[dateTime.month - 1]} '
        '${dateTime.year} • '
        '$hour:$minute $period';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final doctor =
        context.watch<
          AuthProvider
        >().doctor;

    final appointment =
        context.watch<
          AppointmentProvider
        >().appointment;

    return Scaffold(
      backgroundColor:
          AppColors.background,
      appBar:
          AppBar(
        backgroundColor:
            AppColors.surface,
        surfaceTintColor:
            Colors.transparent,
        title:
            const Text(
          'TeleCare Doctor',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip:
                'Logout',
            onPressed:
                () async {
              await context
                  .read<
                    AuthProvider
                  >()
                  .logout();
            },
            icon:
                const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body:
          SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                'Welcome, Doctor',
                style:
                    Theme.of(
                  context,
                )
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors
                              .textPrimary,
                    ),
              ),
              const SizedBox(
                height:
                    6,
              ),
              Text(
                doctor?.email ??
                    'doctor@telecare.com',
                style:
                    const TextStyle(
                  color:
                      AppColors
                          .textSecondary,
                ),
              ),
              const SizedBox(
                height:
                    28,
              ),
              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                ),
                child:
                    const Row(
                  children: [
                    Icon(
                      Icons
                          .calendar_month_rounded,
                      color:
                          Colors.white,
                      size:
                          42,
                    ),
                    SizedBox(
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
                            'Today’s Schedule',
                            style:
                                TextStyle(
                              color:
                                  Colors.white70,
                              fontSize:
                                  14,
                            ),
                          ),
                          SizedBox(
                            height:
                                4,
                          ),
                          Text(
                            '1 Upcoming Appointment',
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height:
                    30,
              ),
              const Text(
                'Upcoming Appointment',
                style:
                    TextStyle(
                  fontSize:
                      19,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors
                          .textPrimary,
                ),
              ),
              const SizedBox(
                height:
                    14,
              ),
              InkWell(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                onTap:
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              const AppointmentDetailsScreen(),
                    ),
                  );
                },
                child:
                    Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    border:
                        Border.all(
                      color:
                          AppColors.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black
                                .withValues(
                          alpha:
                              0.04,
                        ),
                        blurRadius:
                            14,
                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),
                  child:
                      Row(
                    children: [
                      Container(
                        width:
                            58,
                        height:
                            58,
                        alignment:
                            Alignment.center,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFEDE9FE,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        child:
                            const Icon(
                          Icons
                              .person_rounded,
                          color:
                              AppColors
                                  .primary,
                          size:
                              30,
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
                              appointment
                                  .patientName,
                              style:
                                  const TextStyle(
                                fontSize:
                                    17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height:
                                  5,
                            ),
                            Text(
                              _formatDate(
                                appointment
                                    .appointmentDateTime,
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .textSecondary,
                              ),
                            ),
                            const SizedBox(
                              height:
                                  8,
                            ),
                            _StatusBadge(
                              status:
                                  appointment
                                      .status,
                              text:
                                  appointment
                                      .statusText,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons
                            .chevron_right_rounded,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge
    extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.text,
  });

  final AppointmentStatus
      status;

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case AppointmentStatus
            .confirmed:
        backgroundColor =
            const Color(
          0xFFDCFCE7,
        );

        textColor =
            const Color(
          0xFF15803D,
        );

        break;

      case AppointmentStatus
            .unconfirmed:
        backgroundColor =
            const Color(
          0xFFFEF3C7,
        );

        textColor =
            const Color(
          0xFFB45309,
        );

        break;

      case AppointmentStatus
            .cancelled:
        backgroundColor =
            const Color(
          0xFFFEE2E2,
        );

        textColor =
            const Color(
          0xFFB91C1C,
        );

        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            10,
        vertical:
            5,
      ),
      decoration:
          BoxDecoration(
        color:
            backgroundColor,
        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),
      child:
          Text(
        text,
        style:
            TextStyle(
          color:
              textColor,
          fontSize:
              12,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}

