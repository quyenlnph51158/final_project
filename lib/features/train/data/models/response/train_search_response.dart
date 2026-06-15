import 'package:final_project/features/train/data/models/train_model.dart';
import 'package:final_project/features/train/data/models/train_payload_model.dart';

class TrainSearchResponse {
  final List<TrainModel> DepartureListTrain;
  final List<TrainModel> ReturnListTrain;
  final String? payloadTrain;
  TrainSearchResponse({
    this.DepartureListTrain = const [],
    this.ReturnListTrain = const [],
    this.payloadTrain,
  });
  factory TrainSearchResponse.fromJson(Map<String,dynamic> json){
    return TrainSearchResponse(
        payloadTrain: json['payload']
    );
  }
}