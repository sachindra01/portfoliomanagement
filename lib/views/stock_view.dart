// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_management/controller/stock_controller.dart';


class StockManage extends StatefulWidget {
  const StockManage({ Key? key }) : super(key: key);

  @override
  State<StockManage> createState() => _StockManageState();
}

class _StockManageState extends State<StockManage> {
  final StockManageController stockManageController = Get.put(StockManageController());

  //Text Field Control
  var formKey = GlobalKey<FormState>();
  final buyingPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final quantityController = TextEditingController();
  final transactionDateController = TextEditingController();
  final amountController = TextEditingController();
  final transactionTypeController = TextEditingController();
  var stocksDropDown = "Select Stock";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData(){
    setState(() {
    stockManageController.getData();
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PortFolio Management'),
        backgroundColor: Colors.blueGrey,
        actions: [
          TextButton(
            onPressed: (){
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              value: stocksDropDown,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  stocksDropDown = newValue!;
                                });
                              },
                              items: <String>[
                                "Select Stock",
                                'BARUN',
                                'HIDCL',
                                'NABIL',
                                'API',
                                'UNI',
                                'SCB'
                              ].map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: amountController,
                              decoration:const InputDecoration(hintText: "Enter the Amount"),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Amount cannot be empty."
                                  : null,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: sellingPriceController,
                              decoration:const InputDecoration(hintText: "Selling Price"),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Selling Price cannot be empty."
                                  : null,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              decoration:const InputDecoration(hintText: "Quantity"),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Quantity cannot be empty."
                                  : null,
                            ),
                            TextFormField(
                              controller: transactionDateController,
                              decoration: InputDecoration(
                                hintText: "Transaction Date",
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    dateTimePicker();
                                  },
                                  child: const Icon(Icons.timer),
                                ),
                              ),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Date cannot be empty."
                                  : null,
                            ),
                            TextFormField(
                              controller: transactionTypeController,
                              decoration:const InputDecoration(hintText: "Transaction Type"),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Transaction Type cannot be empty."
                                  : null,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      content: ElevatedButton(
                        onPressed: uploadStock,
                        child: const Text(
                          "Add Stock",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            onPrimary: const Color.fromARGB(255, 184, 183, 183),
                            primary: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 12, top: 20),
                    );
                  },
                ),
              );
            },
            child: const Text("ADD", style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Column(
        children: [
          //Header
          Card(
            color: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      child: Text('Stock Name', style: TextStyle(color: Colors.white),)),
                    SizedBox(
                      width: 2,
                    ),
                    Text('Type', style: TextStyle(color: Colors.white),),
                     SizedBox(
                      width: 2,
                    ),
                    Text('Quantity', style: TextStyle(color: Colors.white),),
                     SizedBox(
                      width: 2,
                    ),
                    Text('Amount', style: TextStyle(color: Colors.white),),
                     SizedBox(
                      width: 2,
                    ),
                    Text('TransactionDate', style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
          ),
          //Stock List that has been added
          Expanded(child: stockLists()),

          //Totals section
          // Card(
          //   color: Colors.teal,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: const [
          //         Text(
          //           'Total Buying Price:', style: TextStyle(color: Colors.white),
          //         ),
          //         Text(
          //           'Total Selling Price:', style: TextStyle(color: Colors.white),
          //         ),

          //         // Text(
          //         //   'Total Buying Price:${stockManageController.stockList.reduce((value, element) => value + element.buyingPrice)}', 
          //         //   style: TextStyle(color: Colors.white),
          //         // ),
          //         // Text(
          //         //   'Total Selling Price:${stockManageController.stockList.reduce((value, element) => value + element.sellingPrice)}',
          //         //   style: TextStyle(color: Colors.white),
          //         // ),

          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget stockLists(){
    return GetBuilder(
      init: StockManageController(),
      builder: (_){
        return Obx(
          ()=> stockManageController.isLoading.value
          ? SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: const Center(child: CircularProgressIndicator( color: Colors.black,),),
          )
          : ListView.builder(
            itemCount: stockManageController.stockList.length,
            itemBuilder: (BuildContext context, index){
              return SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 25,
                          child: Text(stockManageController.stockList[index].stockName)),
                        
                        SizedBox(
                          width: 25,
                          child: Text(stockManageController.stockList[index].transactionStatus)),
                        SizedBox(
                          width: 25,
                          child: Text(stockManageController.stockList[index].transactionQuantity)),
                        SizedBox(
                          child: Text(stockManageController.stockList[index].amount)),
                        Text(stockManageController.stockList[index].transactionDate),
                      ],
                    ),
                  ),
                ),
              );
            }
          )
        );
      }
    );
  }

  //Add New Stocks to firebase
  // uploadStock() async{
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) return;
  //   if (stocksDropDown == "Select Stock") {
  //     return ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Select a Stock"),
  //         backgroundColor: Colors.redAccent,
  //       )
  //     );
  //   }
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );

  //   DocumentReference documentReferencer = FirebaseFirestore.instance.collection("stocks").doc(stocksDropDown.trim());
  //   Map<String, dynamic> data = {
  //     'stock_name':stocksDropDown.trim(),
  //     'selling_price':buyingPriceController.text.trim().toString(),
  //     'transaction_date':transactionDateController.text.trim().toString(),
  //     'quantity':quantityController.text.trim().toString(),
  //     'transaction_type':transactionTypeController.text.trim().toString(),

  //   };
  //   await documentReferencer.set(data).then((value) => Navigator.pop(context)).then((value) => Navigator.pop(context));
  //   stockManageController.getData();
  // }
  // upload() async{
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) return;
  //   if (stocksDropDown == "Select Stock") {
  //     return ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Select a Stock"),
  //         backgroundColor: Colors.redAccent,
  //       )
  //     );
  //   }
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //     DocumentReference documentReferencer = FirebaseFirestore.instance.collection("stocks").doc(stocksDropDown.trim());
  //     Map<String, dynamic> data = {
  //       'stock_name':stocksDropDown.trim(),
  //       'amount':amountController.text.trim().toString(),
  //       'transaction_date':transactionDateController.text.trim().toString(),
  //       'transaction_quantity':quantityController.text.trim().toString(),
  //       'transaction_status':transactionTypeController.text.trim().toString(),
  //       'selling_Price':sellingPriceController.text.trim().toString(),
  //     };
  //     await documentReferencer.set(data).then((value) => Navigator.pop(context))
  //     .then((value) => Navigator.pop(context))
  //     .then((value) => 
  //       MotionToast(
  //         icon: Icons.check_circle_outline,
  //         iconSize: 0.0,
  //         primaryColor: Colors.transparent,
  //         secondaryColor: Colors.transparent,
  //         animationCurve: Curves.bounceOut,
  //         backgroundType: BackgroundType.transparent,
  //         layoutOrientation: ToastOrientation.rtl,
  //         animationType: AnimationType.fromTop,
  //         position: MotionToastPosition.top,
  //         animationDuration: const Duration(milliseconds: 1000),
  //         borderRadius: 4.0,
  //         padding: const EdgeInsets.only(top : 12.0, left: 8.0, right: 8.0),
  //         height: MediaQuery.of(context).size.height * 0.095,
  //         width: MediaQuery.of(context).size.width - 40,
  //         title: Row(
  //           children: [
  //             const SizedBox(width: 20.0,),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: const [
  //                 Text(
  //                   'Success!',
  //                   style:
  //                       TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text(
  //                   'Data uploaded successfully',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const Spacer(),
  //             const Icon(
  //               Icons.check_circle,
  //               color: Colors.green,
  //             ),
  //           ],
  //         ),
  //         description: const SizedBox(),
  //       ).show(context),
  //     );
  // }
  uploadStock() async{
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (stocksDropDown == "Select Stock") {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select a Stock"),
          backgroundColor: Colors.redAccent,
        )
      );
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

    DocumentReference documentReferencer = FirebaseFirestore.instance.collection("stocks").doc(stocksDropDown.trim());
    Map<String, dynamic> data = {
    'stock_name':stocksDropDown.trim(),
    'amount':amountController.text.trim().toString(),
    'transaction_date':transactionDateController.text.trim().toString(),
    'transaction_quantity':quantityController.text.trim().toString(),
    'transaction_status':transactionTypeController.text.trim().toString(),
    'selling_Price':sellingPriceController.text.trim().toString(),

    };
    await documentReferencer.set(data).then((value) => Navigator.pop(context)).then((value) => Navigator.pop(context));
    stockManageController.getData();
  }

  //Date And Time Picker
  //  void dateTimePicker() {
  //   DatePicker.showDatePicker(
  //     context,
  //     showTitleActions: true,
  //     onChanged: (date) {
  //     }, 
  //     onConfirm: (date) {
  //       //Set the picked value to the Text controller
  //       setState(() {
  //         transactionDateController.text=date.toString();
  //       });
  //     }, 
  //     currentTime: DateTime.now(), locale: LocaleType.en
  //   );
  // }
   void dateTimePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true, 
      onChanged: (date) {

      }, 
      onConfirm: (date) {
        setState(() {
          transactionDateController.text=DateFormat('yyyy-MM-dd').format(date);
        });
      }, 
      currentTime: DateTime.now(), locale: LocaleType.en);
  }
}