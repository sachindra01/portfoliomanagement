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
    String y='';

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
                              decoration:const InputDecoration(hintText: "Current price of stock"),
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Current price of stock"
                                  : null,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: sellingPriceController,
                              decoration:const InputDecoration(hintText: "Selling/buying Price"),
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
          Expanded(child: stockLists()),
           Card(
            color: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetBuilder(
                    init: StockManageController(),
                    builder: (_){
                      return Obx(
                        ()=> stockManageController.isLoading.value
                        ? stockManageController.stockList.isEmpty?const SizedBox():
                        const Center(child: Text('Loading...', style: TextStyle(color: Colors.white),))
                        : //Totals section
                        Text(
                          'Total  Investment: ${stockManageController.stockPriceList.reduce((value, element) =>  value + element)}', style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),

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
          :stockManageController.stockList.isEmpty?const SizedBox():
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2/ 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
              itemCount: stockManageController.stockList.length,
              itemBuilder: (BuildContext ctx, index) {
               
                  var total=    stockManageController.stockPriceList.reduce((value, element) =>  value + element);

                var x= (int.parse(stockManageController.stockList[index].transactionQuantity)*int.parse(stockManageController.stockList[index].sellingPrice))-int.parse(stockManageController.stockList[index].currentAmount);
                if( int.parse(stockManageController.stockList[index].currentAmount)>(int.parse(stockManageController.stockList[index].transactionQuantity)*int.parse(stockManageController.stockList[index].sellingPrice))){
                  y='loss';
                }else{
                y ='profit';
                }
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:y=='loss'?Colors.red: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                    ), 
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [  
                          Row(
                            children: [
                                const Text('Stock Name  ::',style:TextStyle(
                                  color: Colors.white,fontSize: 15.0
                                  )
                                ),
                                const  SizedBox(
                                      width: 10,
                                ),
                                Text(stockManageController.stockList[index].stockName,style: const TextStyle(
                                color: Colors.white,fontSize: 15.0
                                )),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                              const Text('Total unit ::',style:TextStyle(
                                color: Colors.white,fontSize: 15.0
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(stockManageController.stockList[index].transactionQuantity,style: const TextStyle(
                                color: Colors.white,fontSize: 15.0
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                                const Text('Sold Amount ::',style:TextStyle(
                                color: Colors.white,fontSize: 15.0
                                )
                              ),
                              const  SizedBox(
                                    width: 10,
                              ),
                              Text((int.parse(stockManageController.stockList[index].transactionQuantity)*int.parse(stockManageController.stockList[index].sellingPrice)).toString(),style: const TextStyle(
                              color: Colors.white,fontSize: 15.0
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                              const Text('Current Amount ::',style:TextStyle(
                                color: Colors.white,fontSize: 15.0
                                )
                              ),
                              const  SizedBox(
                                    width: 10,
                              ),
                              Text(stockManageController.stockList[index].currentAmount,style: const TextStyle(
                              color: Colors.white,fontSize: 15.0
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                                  const  Text('Total Investment  ::',style:TextStyle(
                                color: Colors.white,fontSize: 15.0
                                )),
                                const  SizedBox(
                                      width: 10,
                                ),
                                Text(total.toString(),style: const TextStyle(
                                color: Colors.white,fontSize: 15.0
                               )),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                            Row(
                              children: [
                                Text('Overall $y ::',style:const TextStyle(
                                  color: Colors.white,fontSize: 15.0
                                  )
                                ),
                                const  SizedBox(
                                width: 10,
                                ),
                                Text(x.toString(),style: const TextStyle(
                                color: Colors.white,fontSize: 15.0
                                )),
                              ],
                          ),
                      ]),
                    ),    
                  ),
                );
              }
            ),
          //  ListView.builder(
          //   itemCount: stockManageController.stockList.length,
          //   itemBuilder: (BuildContext context, index){
          //     return SizedBox(
          //       height: 100,
          //       width: MediaQuery.of(context).size.width,
          //       child: Card(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               SizedBox(
          //                 width: 25,
          //                 child: Text(stockManageController.stockList[index].stockName)),
                        
          //               SizedBox(
          //                 width: 25,
          //                 child: Text(stockManageController.stockList[index].transactionStatus)),
          //               SizedBox(
          //                 width: 25,
          //                 child: Text(stockManageController.stockList[index].transactionQuantity)),
          //               SizedBox(
          //                 child: Text(stockManageController.stockList[index].sellingPrice)),
          //               Text(stockManageController.stockList[index].transactionDate),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   }
          // )
        );
      }
    );
  }

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
    'current_amount':amountController.text.trim(),
    'stock_name':stocksDropDown.trim(),
    'transaction_date':transactionDateController.text.trim().toString(),
    'transaction_quantity':quantityController.text.trim().toString(),
    'transaction_status':transactionTypeController.text.trim().toString(),
    'selling_Price':sellingPriceController.text.trim().toString(),

    };
    await documentReferencer.set(data).then((value) => Navigator.pop(context)).then((value) => Navigator.pop(context));
    stockManageController.getData();
  }

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