import 'package:final_project/features/train/data/models/seat_class.dart';
import 'package:final_project/features/train/data/models/station_detail.dart';
import 'package:final_project/features/train/data/models/station_object.dart';
import 'package:final_project/features/train/data/models/train_detail.dart';

import 'carrier.dart';


class TrainModel {
  int? id;
  int? carrierId;
  int? trainId;
  int? fromStationId;
  int? toStationId;
  List<SeatClass>? seatClass;
  String? departTime;
  String? arrivalTime;
  int? duration;
  int? distance;
  int? childFee;
  int? infantFee;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? extensions;
  String? timeStart;
  String? dateTimeStart;
  String? timeEnd;
  String? dateTimeEnd;
  String? dateTimeStartObj;
  String? dateTimeEndObj;
  String? departure;
  String? arrival;
  String? trainName;
  String? trainCode;
  String? provider;
  StationObject? originStationObject;
  StationObject? destinationStationObject;
  int? time;
  String? checksum;
  String? unique;
  StationDetail? fromStation;
  StationDetail? toStation;
  TrainDetail? train;
  Carrier? carrier;
  String? currency;

  TrainModel({
    this.id,
    this.carrierId,
    this.trainId,
    this.fromStationId,
    this.toStationId,
    this.seatClass,
    this.departTime,
    this.arrivalTime,
    this.duration,
    this.distance,
    this.childFee,
    this.infantFee,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.extensions,
    this.timeStart,
    this.dateTimeStart,
    this.timeEnd,
    this.dateTimeEnd,
    this.dateTimeStartObj,
    this.dateTimeEndObj,
    this.departure,
    this.arrival,
    this.trainName,
    this.trainCode,
    this.provider,
    this.originStationObject,
    this.destinationStationObject,
    this.time,
    this.checksum,
    this.unique,
    this.fromStation,
    this.toStation,
    this.train,
    this.carrier,
    this.currency
  });

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'],
      carrierId: json['carrier_id'],
      trainId: json['train_id'],
      fromStationId: json['from_station_id'],
      toStationId: json['to_station_id'],
      seatClass: json['seat_class'] != null
          ? (json['seat_class'] as List)
                .map((i) => SeatClass.fromJson(i))
                .toList()
          : null,
      departTime: json['depart_time'],
      arrivalTime: json['arrival_time'],
      duration: json['duration'],
      distance: json['distance'],
      childFee: json['child_fee'],
      infantFee: json['infant_fee'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      timeStart: json['timeStart'],
      dateTimeStart: json['dateTimeStart'],
      timeEnd: json['timeEnd'],
      dateTimeEnd: json['dateTimeEnd'],
      dateTimeStartObj: json['dateTimeStartObj'],
      dateTimeEndObj: json['dateTimeEndObj'],
      departure: json['depature'],
      arrival: json['arrival'],
      trainName: json['train_name'],
      trainCode: json['train_code'],
      provider: json['provider'],
      originStationObject: json['originStationObject'] != null
          ? StationObject.fromJson(json['originStationObject'])
          : null,
      destinationStationObject: json['destinationStationObject'] != null
          ? StationObject.fromJson(json['destinationStationObject'])
          : null,
      time: json['_time'],
      checksum: json['_checksum'],
      unique: json['_unique'],
      fromStation: json['from_station'] != null
          ? StationDetail.fromJson(json['from_station'])
          : null,
      toStation: json['to_station'] != null
          ? StationDetail.fromJson(json['to_station'])
          : null,
      train: json['train'] != null ? TrainDetail.fromJson(json['train']) : null,
      carrier: json['carrier'] != null
          ? Carrier.fromJson(json['carrier'])
          : null,
      currency: json['currency']
    );
  }
}
