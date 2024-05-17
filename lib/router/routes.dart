import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/pages/fixture/fixture_page.dart';
import 'package:soccer_simulator/pages/league/league_page.dart';
import 'package:soccer_simulator/pages/player/player_detail.dart';
import 'package:soccer_simulator/pages/player/player_list.dart';
import 'package:soccer_simulator/pages/start/start_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      onExit: (context) {
        return false;
      },
      builder: (BuildContext context, GoRouterState state) {
        return const StartPage();
      },
    ),
    GoRoute(
      onExit: (context) {
        return false;
      },
      path: '/league',
      builder: (BuildContext context, GoRouterState state) {
        return const LeaguePage();
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
