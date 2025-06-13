import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:gym_app/presentation/blocs/auth/auth_event.dart';
import 'package:gym_app/presentation/blocs/auth/auth_state.dart';
import 'package:gym_app/service_locator.dart';

class AuthScreen extends StatefulWidget {
  final Function(String) onAuthenticated;
  final String language;

  const AuthScreen({
    Key? key,
    required this.onAuthenticated,
    required this.language,
  }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _uuidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RAFIS GYM',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      sl<AppLocalization>().getLocalizedText('authHintText', widget.language),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        widget.onAuthenticated(_uuidController.text.trim());
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          TextField(
                            controller: _uuidController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: sl<AppLocalization>().getLocalizedText('authHintText', widget.language),
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: const Color(0xFF2C2C2E),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => context.read<AuthBloc>().add(
                                AuthSubmitEvent(
                                    uuid: _uuidController.text.trim(),
                                    languageCode: widget.language)),
                          ),
                          if (state is AuthFailure) ...[
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          state is AuthLoading
                              ? const CupertinoActivityIndicator(
                            radius: 14,
                            color: Color(0xFF0A84FF),
                          )
                              : ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                  AuthSubmitEvent(
                                      uuid: _uuidController.text.trim(),
                                      languageCode: widget.language));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(sl<AppLocalization>().getLocalizedText('authSubmitButton', widget.language)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _uuidController.dispose();
    super.dispose();
  }
}