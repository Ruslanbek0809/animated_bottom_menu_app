import 'dart:async';

import 'package:animated_bottom_menu/application/app_action/app_action_cubit.dart';
import 'package:animated_bottom_menu/infrastructure/core/dependency_injection/di.dart';
import 'package:animated_bottom_menu/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  //* CONFIGURES dependency injection to init modules and singletons.
  await configureDependencyInjection();

  return runApp(await builder());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppActionCubit>()),
      ],
      child: const MaterialApp(home: AnimatedBottomMenuPage()),
    );
  }
}
