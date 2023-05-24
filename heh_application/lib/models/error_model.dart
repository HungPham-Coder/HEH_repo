class ErrorModel {
  String error;
  ErrorModel({required this.error});
  factory ErrorModel.fromMap(Map<String, dynamic> json) {
    return ErrorModel(
      error: json['error'],
    );
  }
}
