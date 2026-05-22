import 'package:final_project/features/train/data/models/cheap_journey.dart';
import 'package:final_project/features/train/data/models/destination.dart';
import 'package:final_project/features/train/data/models/list_city.dart';
import 'package:final_project/features/train/data/models/response/train_booking_response.dart';
import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/train_device.dart';
import 'package:final_project/features/train/data/models/train_model.dart';

class TrainDataState {
  final String? payload;
  final List<ListCity> cities;
  final List<Destination> destinations;
  final List<CheapJourney> cheapJourneys;
  final List<TrainModel> originalDepartureListTrain;
  final List<TrainModel> originalReturnListTrain;
  final List<TrainModel> DepartureListTrain;
  final List<TrainModel> ReturnListTrain;
  final TrainModel? SelectedDepartureTrain;
  final TrainModel? SelectedReturnTrain;
  final SeatClass? SelectedDepartureSeatClass;
  final SeatClass? SelectedReturnSeatClass;
  final TrainDevice? devices;
  final TrainBookingData? summaryTrainResponseData;

  TrainDataState({
    this.payload,
    required this.cities,
    required this.destinations,
    required this.cheapJourneys,
    required this.originalDepartureListTrain,
    required this.originalReturnListTrain,
    required this.DepartureListTrain,
    required this.ReturnListTrain,
    required this.SelectedDepartureTrain,
    required this.SelectedReturnTrain,
    required this.SelectedDepartureSeatClass,
    required this.SelectedReturnSeatClass,
    required this.devices,
    required this.summaryTrainResponseData,
  });

  factory TrainDataState.initial() {
    return TrainDataState(
      payload: null,
      cities: [],
      destinations: [],
      cheapJourneys: [],
      originalDepartureListTrain: [],
      originalReturnListTrain: [],
      DepartureListTrain: [],
      ReturnListTrain: [],
      SelectedDepartureTrain: null,
      SelectedReturnTrain: null,
      SelectedDepartureSeatClass: null,
      SelectedReturnSeatClass: null,
      devices: null,
      summaryTrainResponseData: null,
    );
  }

  TrainDataState copyWith({
    String? payload,
    List<ListCity>? cities,
    List<Destination>? destinations,
    List<CheapJourney>? cheapJourneys,
    List<TrainModel>? originalDepartureListTrain,
    List<TrainModel>? originalReturnListTrain,
    List<TrainModel>? DepartureListTrain,
    List<TrainModel>? ReturnListTrain,
    TrainModel? SelectedDepartureTrain,
    TrainModel? SelectedReturnTrain,
    SeatClass? SelectedDepartureSeatClass,
    SeatClass? SelectedReturnSeatClass,
    TrainDevice? devices,
    TrainBookingData? summaryTrainResponseData
  }) {
    return TrainDataState(
      payload: payload ?? this.payload,
      cities: cities ?? this.cities,
      destinations: destinations ?? this.destinations,
      cheapJourneys: cheapJourneys ?? this.cheapJourneys,
      originalDepartureListTrain: originalDepartureListTrain ?? this.originalDepartureListTrain,
      originalReturnListTrain: originalReturnListTrain ?? this.originalReturnListTrain,
      DepartureListTrain: DepartureListTrain ?? this.DepartureListTrain,
      ReturnListTrain: ReturnListTrain ?? this.ReturnListTrain,
      SelectedDepartureTrain: SelectedDepartureTrain ?? this.SelectedDepartureTrain,
      SelectedReturnTrain: SelectedReturnTrain ?? this.SelectedReturnTrain,
      SelectedDepartureSeatClass: SelectedDepartureSeatClass ?? this.SelectedDepartureSeatClass,
      SelectedReturnSeatClass: SelectedReturnSeatClass ?? this.SelectedReturnSeatClass,
      devices: devices ?? this.devices,
      summaryTrainResponseData: summaryTrainResponseData ?? this.summaryTrainResponseData,
    );
  }
}
