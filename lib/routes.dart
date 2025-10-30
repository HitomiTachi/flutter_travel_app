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
<<<<<<< HEAD
import 'package:flutter_travels_apps/representation/screen/trip_plans_list_screen.dart';
=======
import 'package:flutter_travels_apps/representation/screen/settings_screen.dart';
import 'package:flutter_travels_apps/representation/screen/travel_checklist_screen.dart';
import 'package:flutter_travels_apps/representation/screen/currency_converter_screen.dart';
import 'package:flutter_travels_apps/representation/screen/trip_plans_list_screen.dart';
import 'package:flutter_travels_apps/representation/screen/budget_screen.dart';
import 'package:flutter_travels_apps/representation/screen/all_services_screen.dart';
import 'package:flutter_travels_apps/representation/screen/search_destinations_screen.dart';
import 'package:flutter_travels_apps/representation/screen/notifications_screen.dart';
>>>>>>> 72ffec4 (Initial commit)

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

<<<<<<< HEAD
  AccommodationBookingScreen.routeName: (context) => const AccommodationBookingScreen(),
  AccommodationDetailsScreen.routeName: (context) => const AccommodationDetailsScreen(),
  AccommodationListScreen.routeName: (context) => const AccommodationListScreen(),
  LikeScreen.routeName: (context) => const LikeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
  TripPlansListScreen.routeName: (context) => const TripPlansListScreen(),
  HotelScreen.routeName: (context) => HotelScreen(),
  HotelDetailScreen.routeName: (context) => HotelDetailScreen(),
=======
  AccommodationBookingScreen.routeName: (context) =>
      const AccommodationBookingScreen(),
  AccommodationDetailsScreen.routeName: (context) =>
      const AccommodationDetailsScreen(),
  AccommodationListScreen.routeName: (context) =>
      const AccommodationListScreen(),
  LikeScreen.routeName: (context) => const LikeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  TravelChecklistScreen.routeName: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      return TravelChecklistScreen(
        tripId: args['tripId'] as String?,
        tripName: args['tripName'] as String?,
      );
    }
    return const TravelChecklistScreen();
  },
  CurrencyConverterScreen.routeName: (context) =>
      const CurrencyConverterScreen(),
  BudgetScreen.routeName: (context) => const BudgetScreen(),
  TripPlansListScreen.routeName: (context) => const TripPlansListScreen(),
  HotelScreen.routeName: (context) => HotelScreen(),
  HotelDetailScreen.routeName: (context) => HotelDetailScreen(),
  AllServicesScreen.routeName: (context) => const AllServicesScreen(),
  SearchDestinationsScreen.routeName: (context) =>
      const SearchDestinationsScreen(),
  NotificationsScreen.routeName: (context) => const NotificationsScreen(),
>>>>>>> 72ffec4 (Initial commit)
};
