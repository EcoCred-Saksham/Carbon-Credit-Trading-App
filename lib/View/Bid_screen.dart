import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:swachapp/services/back_end.dart';
import 'package:swachapp/services/constants.dart';
import 'package:swachapp/services/wallet_connect.dart';
import 'package:web3dart/web3dart.dart';

class BidScreen extends StatefulWidget {
  const BidScreen({super.key});

  @override
  State<BidScreen> createState() => _BidScreenState();
}

var httpClient = Client();

class _BidScreenState extends State<BidScreen> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  Widget build(BuildContext context) {
    late BuildContext dialogContext;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Market',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "Jost",
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Color(0xff09891E)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Image.asset("assets/token_image.png"),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SWC",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: "Jost",
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Color(0xff09891E)),
                      ),
                    ),
                    Text(
                      "Swach coin",
                      style: TextStyle(
                          fontFamily: "Jost",
                          fontWeight: FontWeight.w100,
                          fontSize: 20,
                          color: Color(0xff09891E)),
                    ),
                    Text(
                      "₹6372.54",
                      style: TextStyle(
                          fontFamily: "Jost",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xff09891E)),
                    ),
                    Text(
                      "+1.6%",
                      style: TextStyle(
                          fontFamily: "Jost",
                          fontWeight: FontWeight.w100,
                          fontSize: 15,
                          color: Color(0xff09891E)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 2,
                ),
                Image.asset(
                  "assets/crypto_chart.png",
                  width: 135,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            names.length >= 1
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: names.length,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Color(0xff09891E),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/person.png"),
                                  radius: 20,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      names[index],
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "${number_of_creds[index]} Credits",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            textStyle: MaterialStatePropertyAll(
                                                TextStyle(
                                                    color: Color(0xff09891E))),
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size(80, 40))),
                                        onPressed: () async {
                                          setState(() {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                dialogContext = context;
                                                return Dialog(
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      new CircularProgressIndicator(),
                                                      new Text(
                                                        "Tansaction Processing",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    79,
                                                                    69,
                                                                    228),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          });
                                          await sendToken(
                                              person_public_key,
                                              BigInt.from(int.parse(
                                                      number_of_creds[index]) *
                                                  100),
                                              ethClient!);

                                          names.remove(names[index]);
                                          number_of_creds
                                              .remove(number_of_creds[index]);
                                          price.remove(price[index]);

                                          print(names.length);
                                          Navigator.pop(dialogContext);
                                          setState(() {});
                                        },
                                        child: Text(
                                          "Buy",
                                          style: TextStyle(
                                              color: Color(0xff09891E),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "₹${price[index]} per Coin",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/no_transactions.webp",
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No Transactions Requests",
                          style: TextStyle(
                              color: Color(0xff09891E),
                              fontWeight: FontWeight.w600,
                              fontSize: 25),
                        )
                      ],
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
