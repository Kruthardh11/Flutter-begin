import 'package:firebase_integrate/api/http_crud.dart';
import 'package:firebase_integrate/crud/sport_details.dart';
import 'package:firebase_integrate/form/form_page_one.dart';
import 'package:firebase_integrate/main.dart';
import 'package:firebase_integrate/routing/error_page.dart';
import 'package:firebase_integrate/routing/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: MyAppRouteConstants.homeRouteName,
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: MyHomePage());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.formRouteName,
        path: '/user_details/:userName/:email',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: FormPageOne(
                  email: state.pathParameters['email']!,
                  userName: state.pathParameters['userName']!));
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.sportsRouteName,
        path: '/crud_operations',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SportDetails());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.httpRouteName,
        path: '/http_requests',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HttpCrud());
        },
      )
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorPage());
    },
  );
}
