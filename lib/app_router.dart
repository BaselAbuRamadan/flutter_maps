import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/buisness_logic/maps/maps_cubit.dart';
import 'package:flutter_maps/constants/strings.dart';
import 'package:flutter_maps/data/repository/map_repo.dart';
import 'package:flutter_maps/data/webservices/placesWebServices.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'package:flutter_maps/presentation/screens/map_screen.dart';
import 'package:flutter_maps/presentation/screens/otp_screen.dart';

import 'buisness_logic/phone_auth/phone_auth_cubit.dart';

class AppRouter {
  PhoneAuthCubit?  phoneAuthCubit;
  AppRouter(){
    phoneAuthCubit = PhoneAuthCubit();
  }


  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) =>
                    MapsCubit(MapsRepository(PlacesWebServices(),),
                    ),child: MapScreen(),
            ) );
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!,
              child: LoginScreen(),
            ));
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!,
              child: OtpScreen(phoneNumber :phoneNumber),
            ));
    }
  }
}