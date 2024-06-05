import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soccer_simulator/ui/pages/create/create_save_slot_page.dart';
import 'package:soccer_simulator/ui/pages/create/select_club_page.dart';
import 'package:soccer_simulator/ui/pages/create/select_league_page.dart';
import 'package:soccer_simulator/ui/pages/start/start_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      onExit: (context, state) {
        return false;
      },
      builder: (BuildContext context, GoRouterState state) {
        return const StartPage();
      },
    ),
    GoRoute(
      path: SelectLeaguePage.routes,
      builder: (BuildContext context, GoRouterState state) {
        return const SelectLeaguePage();
      },
    ),
    GoRoute(
      path: SelectClubPage.routes,
      builder: (BuildContext context, GoRouterState state) {
        return const SelectClubPage();
      },
    ),
    GoRoute(
      path: CreateSaveSlotPage.routes,
      builder: (BuildContext context, GoRouterState state) {
        return const CreateSaveSlotPage();
      },
    ),
    // GoRoute(
    //   path: '/league',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const LeaguePage();
    //   },
    // ),
    // GoRoute(
    //   path: '/setting',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SettingPage();
    //   },
    // ),
    // GoRoute(
    //   path: '/fixture',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const FixturePage();
    //   },
    // ),
    // GoRoute(
    //   path: '/players',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const PlayerListPage();
    //   },
    //   routes: <RouteBase>[
    //     GoRoute(
    //       path: 'detail',
    //       builder: (BuildContext context, GoRouterState state) {
    //         return const PlayerDetail();
    //       },
    //     ),
    //   ],
    // ),
  ],
);
