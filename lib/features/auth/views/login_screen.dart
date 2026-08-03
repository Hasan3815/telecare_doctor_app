import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen
    extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen>
      createState() =>
          _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _emailController =
      TextEditingController(
    text:
        'doctor@telecare.com',
  );

  final _passwordController =
      TextEditingController(
    text:
        'Doctor@123',
  );

  bool _obscurePassword =
      true;

  @override
  void dispose() {
    _emailController
        .dispose();

    _passwordController
        .dispose();

    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(
      context,
    ).unfocus();

    if (!_formKey
        .currentState!
        .validate()) {
      return;
    }

    final authProvider =
        context.read<
          AuthProvider
        >();

    final success =
        await authProvider
            .login(
      email:
          _emailController
              .text,
      password:
          _passwordController
              .text,
    );

    if (!mounted ||
        success) {
      return;
    }

    final message =
        authProvider
            .errorMessage ??
        'Login failed';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(message),
        backgroundColor:
            AppColors.error,
        behavior:
            SnackBarBehavior
                .floating,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final isLoading =
        context.watch<
          AuthProvider
        >().isLoading;

    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: SafeArea(
        child:
            Center(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets
                    .all(24),
            child:
                ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 460,
              ),
              child:
                  Form(
                key:
                    _formKey,
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      alignment:
                          Alignment
                              .center,
                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .primary,
                        borderRadius:
                            BorderRadius
                                .circular(
                          24,
                        ),
                      ),
                      child:
                          const Icon(
                        Icons
                            .medical_services_rounded,
                        color:
                            Colors
                                .white,
                        size:
                            46,
                      ),
                    ),
                    const SizedBox(
                      height:
                          28,
                    ),
                    const Text(
                      AppStrings
                          .loginTitle,
                      textAlign:
                          TextAlign
                              .center,
                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textPrimary,
                        fontSize:
                            30,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    const SizedBox(
                      height:
                          10,
                    ),
                    const Text(
                      AppStrings
                          .loginSubtitle,
                      textAlign:
                          TextAlign
                              .center,
                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textSecondary,
                        fontSize:
                            15,
                        height:
                            1.5,
                      ),
                    ),
                    const SizedBox(
                      height:
                          38,
                    ),
                    AppTextField(
                      controller:
                          _emailController,
                      label:
                          AppStrings
                              .email,
                      hint:
                          'doctor@telecare.com',
                      prefixIcon:
                          Icons
                              .email_outlined,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      validator:
                          Validators
                              .validateEmail,
                    ),
                    const SizedBox(
                      height:
                          18,
                    ),
                    TextFormField(
                      controller:
                          _passwordController,
                      obscureText:
                          _obscurePassword,
                      validator:
                          Validators
                              .validatePassword,
                      decoration:
                          InputDecoration(
                        labelText:
                            AppStrings
                                .password,
                        hintText:
                            'Enter password',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_outline,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed:
                              () {
                            setState(
                              () {
                                _obscurePassword =
                                    !_obscurePassword;
                              },
                            );
                          },
                          icon:
                              Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                          ),
                        ),
                        filled:
                            true,
                        fillColor:
                            AppColors
                                .surface,
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              18,
                          vertical:
                              17,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                AppColors
                                    .border,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                AppColors
                                    .border,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                AppColors
                                    .primary,
                            width:
                                1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height:
                          28,
                    ),
                    AppButton(
                      text:
                          AppStrings
                              .signIn,
                      icon:
                          Icons
                              .login_rounded,
                      isLoading:
                          isLoading,
                      onPressed:
                          _login,
                    ),
                    const SizedBox(
                      height:
                          24,
                    ),
                    Container(
                      padding:
                          const EdgeInsets
                              .all(16),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFEFF6FF,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                      child:
                          const Column(
                        children: [
                          Text(
                            'Demo Doctor Account',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  AppColors
                                      .primary,
                            ),
                          ),
                          SizedBox(
                            height:
                                8,
                          ),
                          Text(
                            'doctor@telecare.com',
                          ),
                          SizedBox(
                            height:
                                3,
                          ),
                          Text(
                            'Doctor@123',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}