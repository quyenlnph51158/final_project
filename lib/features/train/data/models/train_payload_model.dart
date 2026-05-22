class TrainPayloadModel {
  String? payload;
  TrainPayloadModel({
    this.payload
});
  factory TrainPayloadModel.fromJson(Map<String,dynamic> json){
    return TrainPayloadModel(
      payload: json['payload']
    );
  }
}