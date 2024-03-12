import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/pages/player/player_detail.dart';
import 'package:soccer_simulator/pages/player/player_list.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
    ),
    GoRoute(
      path: '/players',
      builder: (BuildContext context, GoRouterState state) {
        return const PlayerListPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'detail',
          builder: (BuildContext context, GoRouterState state) {
            return const PlayerDetail();
          },
        ),
      ],
    ),
  ],
);
