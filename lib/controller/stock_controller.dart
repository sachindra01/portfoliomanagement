// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:portfolio_management/model/stock_model.dart';

class StockManageController extends GetxController{
  RxBool isLoading = false.obs;
  List stockList = <StockManageModel>[];
   List stockPriceList = [];
   // ignore: prefer_typing_uninitialized_variables
   var x;
   var total;

  getData() async{
    try{
      isLoading(true);
      QuerySnapshot firebaseData = await FirebaseFirestore.instance.collection('stocks').get();
      stockList.clear();
      for(var data in firebaseData.docs){
        stockList.add(
          StockManageModel(
            data['stock_name'], 
            data['current_amount'], 
            data['transaction_status'],
            data['transaction_quantity'],
            data['selling_Price'],
            data['transaction_date']
          )
        );
     stockPriceList.add(int.parse(data['selling_Price'])*int.parse(data['transaction_quantity']));
      }
      update();
      
    }catch(e){
      Get.snackbar("An Error Occured!", e.toString());
    } finally{
      isLoading(false);
    }
  }
}