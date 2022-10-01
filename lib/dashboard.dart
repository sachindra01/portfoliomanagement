import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({ Key? key }) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // var formKey = GlobalKey<FormState>();
  // final amountController = TextEditingController();
  // final quantityController = TextEditingController();
  // final transactionDateController = TextEditingController();
  // final transactionStatusController = TextEditingController();
  // final buySellController = TextEditingController();
  // var stocksDropDown = "Select Stock";

  // var amountController1 = TextEditingController();
  // var quantityController1 = TextEditingController();
  // var  transactionDateController1 = TextEditingController();
  // var transactionStatusController1= TextEditingController();
  // var stocksDropDown1 = "Select Stock";

  String y='';

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Table
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("stock").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {

                      return const Text(
                        'Loading...',
                      );
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreItems = snapshot.data!.docs;
                      return
                          SizedBox(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 350,
                                  childAspectRatio: 2/ 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20),
                              itemCount: firestoreItems.length,
                              itemBuilder: (BuildContext ctx, index) {
                              var x=  (int.parse(firestoreItems[index]['transaction_quantity'])*int.parse(firestoreItems[index]['selling_Price']))-int.parse(firestoreItems[index]['amount']);
                              if( int.parse(firestoreItems[index]['amount'])>(int.parse(firestoreItems[index]['transaction_quantity'])*int.parse(firestoreItems[index]['selling_Price']))){
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
                                      child: Column(children: [
                                         Row(
                                            children: [
                                            const Text('Stock Name  ::',style:TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                             const  SizedBox(
                                                width: 10,
                                          ),
                                             Text(firestoreItems[index]['stock_name'],style: const TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                            ],
                                          ),
                                         Row(
                                            children: [
                                              const Text('Total unit ::',style:TextStyle(
                                                color: Colors.white,fontSize: 15.0
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(firestoreItems[index]['transaction_quantity'],style: const TextStyle(
                                                color: Colors.white,fontSize: 15.0
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                               const Text('Sold Amount ::',style:TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                             const  SizedBox(
                                                width: 10,
                                          ),
                                             Text((int.parse(firestoreItems[index]['transaction_quantity'])*int.parse(firestoreItems[index]['selling_Price'])).toString(),style: const TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                            ],
                                          ),
                                           Row(
                                            children: [
                                               const Text('Current Amount ::',style:TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                             const  SizedBox(
                                                width: 10,
                                          ),
                                             Text(firestoreItems[index]['amount'],style: const TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                            ],
                                          ),
                                           Row(
                                            children: [
                                                Text('Overall $y ::',style:const TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                             const  SizedBox(
                                                width: 10,
                                          ),
                                             Text(x.toString(),style: const TextStyle(
                                              color: Colors.white,fontSize: 15.0
                                             )),
                                            ],
                                          )
                                      ]),
                                    ),    
                                  ),
                                );
                              }
                            ),
                          );
                        
                      
                    //   return ListView.builder(
                    //     itemCount: firestoreItems.length,
                    //     itemBuilder: ((context, index) {
                        
                        
                    //     return Card(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(10.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Row(
                    //               children: [
                    //               const Text('Stock Name ::',style:TextStyle(
                    //                 color: Colors.blueGrey,fontSize: 20.0
                    //                )),
                    //                const  SizedBox(
                    //                   width: 10,
                    //             ),
                    //                Text(firestoreItems[index]['stock_name'],style: const TextStyle(
                    //                 color: Colors.blue,fontSize: 20.0
                    //                )),
                    //               ],
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const  Text('TransactionType :: ',style:TextStyle(
                    //                 color: Colors.blueGrey,fontSize: 20.0
                    //                )),
                    //                  Text(firestoreItems[index]['transaction_status'],style: const TextStyle(
                    //                 color: Colors.blue,fontSize: 20.0
                    //                )),
                    //               ],
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const  Text('Quantity :: ',style:TextStyle(
                    //                 color: Colors.blueGrey,fontSize: 20.0
                    //                )),
                    //                 Text(firestoreItems[index]['transaction_quantity'],style: const TextStyle(
                    //                 color: Colors.blue,fontSize: 20.0
                    //                )),
                    //               ],
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const Text('Amount :: ',style:TextStyle(
                    //                 color: Colors.blueGrey,fontSize: 20.0
                    //                )),
                    //                 Text(firestoreItems[index]['amount'],style: const TextStyle(
                    //                 color: Colors.blue,fontSize: 20.0
                    //                )),
                    //               ],
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const Text('Transaction _Date :: ',style:TextStyle(
                    //                 color: Colors.blueGrey,fontSize: 20.0
                    //                )),
                    //                 Expanded(
                    //                   child: Text(firestoreItems[index]['transaction_date'],style: const TextStyle(
                    //                   color: Colors.blue,fontSize: 20.0
                    //                                                    )),
                    //                 ),
                    //               ],
                    //             ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                               
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   })
                    // );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  

 

  

 
}