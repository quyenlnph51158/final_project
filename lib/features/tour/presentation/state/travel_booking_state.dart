import 'package:final_project/features/tour/presentation/state/tour_state.dart';
import 'package:final_project/features/tour/presentation/state/travel_filter_state.dart';


import '../../../tour/presentation/state/flight_state.dart';
import 'booking_form_state.dart';
import 'booking_ui_state.dart';


class TravelBookingState {
  final BookingUIState ui;
  final BookingFormState form;
  final TourState tour;
  final FlightState flight;
  final TravelFilterState filter;


  const TravelBookingState({
    required this.ui,
    required this.form,
    required this.tour,
    required this.flight,
    required this.filter,
  });


  factory TravelBookingState.initial() {
    return TravelBookingState(
      ui: BookingUIState.initial(),
      form: BookingFormState.initial(),
      tour: TourState.initial(),
      flight: FlightState.initial(),
      filter: TravelFilterState.initial(),
    );
  }


  TravelBookingState copyWith({
    BookingUIState? ui,
    BookingFormState? form,
    TourState? tour,
    FlightState? flight,
    TravelFilterState? filter,
  }) {
    return TravelBookingState(
      ui: ui ?? this.ui,
      form: form ?? this.form,
      tour: tour ?? this.tour,
      flight: flight ?? this.flight,
      filter: filter ?? this.filter,
    );
  }
}

