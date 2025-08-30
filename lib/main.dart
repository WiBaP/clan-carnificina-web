import 'package:api_cadastro/model/usuario.dart';
import 'package:api_cadastro/screen/cadastro_screen.dart';
import 'package:api_cadastro/screen/evento_screen.dart';
import 'package:api_cadastro/screen/home_screen.dart';
import 'package:api_cadastro/screen/home_adm_screen.dart';
import 'package:api_cadastro/screen/login_screen.dart';
import 'package:api_cadastro/screen/registro_evento_screen.dart';
import 'package:api_cadastro/screen/rules_screen.dart';
import 'package:api_cadastro/screen/usuario_screen.dart';
import 'package:api_cadastro/screen/all_souls_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: "/login",
      routes: [
        GoRoute(
          path: "/login",
          pageBuilder: (context, state) {
            final mensagem = state.extra as String?;
            return NoTransitionPage(child: LoginScreen(mensagem: mensagem));
          },
        ),
        GoRoute(
          path: "/cadastro",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CadastroScreen()),
        ),
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) {
            final usuarioLogado = state.extra as Usuario;

            // Se for adm, redireciona automaticamente para /homeadm
            if (usuarioLogado.adm == true) {
              return NoTransitionPage(
                child: HomeAdmScreen(usuarioLogado: usuarioLogado),
              );
            }

            return NoTransitionPage(
              child: HomeScreen(usuarioLogado: usuarioLogado),
            );
          },
        ),
        GoRoute(
          path: "/homeadm",
          pageBuilder: (context, state) {
            final usuarioLogado = state.extra as Usuario;
            return NoTransitionPage(
              child: HomeAdmScreen(usuarioLogado: usuarioLogado),
            );
          },
        ),
        GoRoute(
          path: "/usuario",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: UsuarioScreen()),
        ),
        GoRoute(
          path: "/allsouls",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AllSouls()),
        ),
        GoRoute(
          path: "/rules",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RulesScreen()),
        ),
        GoRoute(
          path: "/evento",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: EventoScreen()),
        ),
        GoRoute(
          path: "/registro",
          pageBuilder: (context, state) {
            final usuarioLogado = state.extra as Usuario;
            return NoTransitionPage(
              child: RegistroEventoScreen(usuarioLogado: usuarioLogado),
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
