import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/utils/app_size.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'routes/route_manager.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppSize.size = MediaQuery.of(context).size;
      ResponsiveUtils.initialize(context);
      return GetMaterialApp(
        
        scrollBehavior: CustomScrollBehavior(),
        
        navigatorObservers: [MyRouteObserver()],
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.blueLighter, surface: AppColors.black),
          scaffoldBackgroundColor: AppColors.black,
          useMaterial3: true,
          fontFamily: AppStrings.fontFamilyName,
        
        ),
        initialRoute: RouteManager.initial,
        getPages: RouteManager.getPages(),
      );
    });
  }
}

class MyRouteObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('Route pushed: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('Route popped: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }
}


class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // or ClampingScrollPhysics, etc.
  }

  @override
  ScrollViewKeyboardDismissBehavior getKeyboardDismissBehavior(BuildContext context) {
    return ScrollViewKeyboardDismissBehavior.onDrag;
  }
}
