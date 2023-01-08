class RequestWithdrawalList {
  String? pendingWithdrawal;
  List<Data>? data;

  RequestWithdrawalList({this.pendingWithdrawal, this.data});

  RequestWithdrawalList.fromJson(Map<String, dynamic> json) {
    pendingWithdrawal = json['pending_withdrawal'].toString();
    if (json['data'] != null) {
      data = new List<Data>.empty(growable: true);
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_withdrawal'] = this.pendingWithdrawal;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? commissionId;
  String? orderId;
  String? earnings;
  String? adminCharges;
  String? earningsFinal;
  String? createdAtFormatted;
  String? createdAt;

  Data(
      {this.commissionId,
      this.orderId,
      this.earnings,
      this.adminCharges,
      this.earningsFinal,
      this.createdAtFormatted,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    commissionId = json['commission_id'];
    orderId = json['order_id'];
    earnings = json['earnings'];
    adminCharges = json['admin_charges'];
    earningsFinal = json['earnings_final'].toString();
    createdAtFormatted = json['created_at_formatted'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission_id'] = this.commissionId;
    data['order_id'] = this.orderId;
    data['earnings'] = this.earnings;
    data['admin_charges'] = this.adminCharges;
    data['earnings_final'] = this.earningsFinal;
    data['created_at_formatted'] = this.createdAtFormatted;
    data['created_at'] = this.createdAt;
    return data;
  }
}
