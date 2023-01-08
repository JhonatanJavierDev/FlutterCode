class WidrawalHistoryListModel {
  String? id;
  String? requestId;
  String? status;
  String? orderId;
  String? commissionIds;
  int? withdrawAmount;
  int? withdrawCharges;
  int? finalAmount;
  String? withdrawNote;
  String? paymentMethod;
  String? billingDetails;
  String? withdrawalMode;
  String? paidDate;
  String? paidDateFormatted;
  String? createdAt;
  String? createdAtFormatted;

  WidrawalHistoryListModel(
      {this.id,
      this.requestId,
      this.status,
      this.orderId,
      this.commissionIds,
      this.withdrawAmount,
      this.withdrawCharges,
      this.finalAmount,
      this.withdrawNote,
      this.paymentMethod,
      this.billingDetails,
      this.withdrawalMode,
      this.paidDate,
      this.paidDateFormatted,
      this.createdAt,
      this.createdAtFormatted});

  WidrawalHistoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestId = json['request_id'];
    status = json['status'];
    orderId = json['order_id'];
    commissionIds = json['commission_ids'];
    withdrawAmount = json['withdraw_amount'];
    withdrawCharges = json['withdraw_charges'];
    finalAmount = json['final_amount'];
    withdrawNote = json['withdraw_note'];
    paymentMethod = json['payment_method'];
    billingDetails = json['billing_details'];
    withdrawalMode = json['withdrawal_mode'];
    paidDate = json['paid_date'];
    paidDateFormatted = json['paid_date_formatted'];
    createdAt = json['created_at'];
    createdAtFormatted = json['created_at_formatted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_id'] = this.requestId;
    data['status'] = this.status;
    data['order_id'] = this.orderId;
    data['commission_ids'] = this.commissionIds;
    data['withdraw_amount'] = this.withdrawAmount;
    data['withdraw_charges'] = this.withdrawCharges;
    data['final_amount'] = this.finalAmount;
    data['withdraw_note'] = this.withdrawNote;
    data['payment_method'] = this.paymentMethod;
    data['billing_details'] = this.billingDetails;
    data['withdrawal_mode'] = this.withdrawalMode;
    data['paid_date'] = this.paidDate;
    data['paid_date_formatted'] = this.paidDateFormatted;
    data['created_at'] = this.createdAt;
    data['created_at_formatted'] = this.createdAtFormatted;
    return data;
  }
}
