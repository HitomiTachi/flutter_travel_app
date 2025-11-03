import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class TripPlan {
	final String id;
	final String title;
	final String destination;
	final String startDate;
	final String endDate;
	final String duration;
	final double budget;
	final int travelers;
	final TripStatus status;
	final String imageUrl;
	final int activities;
	final double progress;

	TripPlan({
		required this.id,
		required this.title,
		required this.destination,
		required this.startDate,
		required this.endDate,
		required this.duration,
		required this.budget,
		required this.travelers,
		required this.status,
		required this.imageUrl,
		required this.activities,
		required this.progress,
	});

	// Convert to TripPlanData for compatibility with existing screens
	TripPlanData toTripPlanData() {
		return TripPlanData(
			destination: destination,
			startDate: startDate,
			endDate: endDate,
			travelers: travelers,
			budget: budget,
		);
	}

	// Create TripPlan from TripPlanData
	factory TripPlan.fromTripPlanData(TripPlanData data, {
		required String id,
		required String title,
		required String duration,
		required TripStatus status,
		required String imageUrl,
		required int activities,
		required double progress,
	}) {
		return TripPlan(
			id: id,
			title: title,
			destination: data.destination,
			startDate: data.startDate,
			endDate: data.endDate,
			duration: duration,
			budget: data.budget,
			travelers: data.travelers,
			status: status,
			imageUrl: imageUrl,
			activities: activities,
			progress: progress,
		);
	}
}

enum TripStatus {
	completed,
	ongoing,
	planned,
}

// Extension for TripStatus to get display properties
extension TripStatusExtension on TripStatus {
	String get displayText {
		switch (this) {
			case TripStatus.completed:
				return 'Hoàn thành';
			case TripStatus.ongoing:
				return 'Đang thực hiện';
			case TripStatus.planned:
				return 'Kế hoạch';
		}
	}

	String get filterText {
		switch (this) {
			case TripStatus.completed:
				return 'Hoàn thành';
			case TripStatus.ongoing:
				return 'Đang thực hiện';
			case TripStatus.planned:
				return 'Kế hoạch';
		}
	}
}
// File: trip_plan_list_model.dart
// This file was renamed from trip_plan.dart to clarify its role as the model for trip plan lists (used in trip_plans_list_screen, etc).
// Please update all imports referencing trip_plan.dart to trip_plan_list_model.dart.

// ...existing code from trip_plan.dart...
