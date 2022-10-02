class StockManageModel{
  String? stockName;
  String ?currentAmount;
  String? transactionStatus;
  String? transactionQuantity;
  String? sellingPrice;
  String? transactionDate;

  StockManageModel(
    this.stockName, 
    this.currentAmount,
    this.transactionStatus, 
    this.transactionQuantity, 
    this.sellingPrice,
    this.transactionDate,
  );
}
