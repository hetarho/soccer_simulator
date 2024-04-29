import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/main.dart';
import 'package:soccer_simulator/pages/fixture/fixture_page.dart';
import 'package:soccer_simulator/pages/player/player_detail.dart';
import 'package:soccer_simulator/pages/player/player_list.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      onExit: (context) {
        return false;
      },
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
    ),
    GoRoute(
      path: '/fixture',
      builder: (BuildContext context, GoRouterState state) {
        return const FixturePage();
      },
    ),
    GoRoute(
      path: '/players',
      builder: (BuildContext context, GoRouterState state) {
        return PlayerListPage();
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
