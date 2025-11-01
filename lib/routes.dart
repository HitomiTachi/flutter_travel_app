import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/representation/screen/guest_and_room_booking.dart';
import 'package:flutter_travels_apps/representation/screen/hotel_booking_screen.dart';
import 'package:flutter_travels_apps/representation/screen/hotel_detail_screen.dart';
import 'package:flutter_travels_apps/representation/screen/hotel_screen.dart';
import 'package:flutter_travels_apps/representation/screen/intro_screen.dart';
import 'package:flutter_travels_apps/representation/screen/main_app.dart';
import 'package:flutter_travels_apps/representation/screen/select_date_screen.dart';
import 'package:flutter_travels_apps/representation/screen/splash_screen.dart';
import 'package:flutter_travels_apps/representation/screen/trip_creation_screen.dart';
import 'package:flutter_travels_apps/representation/screen/trip_planning_screen.dart';
import 'package:flutter_travels_apps/representation/screen/detailed_trip_plan_screen.dart';

import 'package:flutter_travels_apps/representation/screen/accommodation_booking_screen.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_details_screen.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_list_screen.dart';
import 'package:flutter_travels_apps/representation/screen/like_screen.dart';
import 'package:flutter_travels_apps/representation/screen/profile_screen.dart';
import 'package:flutter_travels_apps/representation/screen/personal_info_screen.dart';
import 'package:flutter_travels_apps/representation/screen/trip_plans_list_screen.dart';
import 'package:flutter_travels_apps/representation/screen/global_search_screen.dart';
import 'package:flutter_travels_apps/representation/screen/settings_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  MainApp.routeName: (context) => const MainApp(),
  HotelBookingScreen.routeName: (context) => const HotelBookingScreen(),
  TripCreationScreen.routeName: (context) => const TripCreationScreen(),
  SelectDateScreen.routeName: (context) => SelectDateScreen(),
  GuestAndRoomBookingScreen.routeName: (context) => GuestAndRoomBookingScreen(),
  TripPlanningScreen.routeName: (context) => const TripPlanningScreen(),
  DetailedTripPlanScreen.routeName: (context) => const DetailedTripPlanScreen(),

  AccommodationBookingScreen.routeName: (context) =>
      const AccommodationBookingScreen(),
  AccommodationDetailsScreen.routeName: (context) =>
      const AccommodationDetailsScreen(),
  AccommodationListScreen.routeName: (context) =>
      const AccommodationListScreen(),
  LikeScreen.routeName: (context) => const LikeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
  TripPlansListScreen.routeName: (context) => const TripPlansListScreen(),
  HotelScreen.routeName: (context) => HotelScreen(),
  HotelDetailScreen.routeName: (context) => HotelDetailScreen(),
  GlobalSearchScreen.routeName: (context) => const GlobalSearchScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  // ReviewScreen, TripBudgetScreen, PackingChecklistScreen are handled dynamically with arguments
};
