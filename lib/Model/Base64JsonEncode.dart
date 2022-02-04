class Base64EncodedModel {
  String merchantUserid,merchantOrder,TranscationId;
  int amount;


  Base64EncodedModel(this.merchantUserid, this.merchantOrder,this.TranscationId,this.amount);

  Map toJson() => {
    'merchantId': merchantUserid,
    'merchantOrderId': merchantOrder,
    'transactionId': TranscationId,
    'amount': amount,
  };
}