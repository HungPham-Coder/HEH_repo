class PaymentModel {
  String? orderId;
  int? amount;
  String? email;
  PaymentModel(
      {required this.orderId, required this.amount, required this.email});
  factory PaymentModel.fromMap(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json["orderId"],
      amount: json['amount'],
      email: json["email"],
    );
  }
}
