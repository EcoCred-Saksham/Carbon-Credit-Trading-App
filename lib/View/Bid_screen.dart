import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swachapp/View/create_advertisement_screen.dart';
import 'package:swachapp/services/constants.dart';
import 'package:swachapp/services/model.dart';
import 'package:swachapp/services/wallet_connect.dart';
import 'package:web3dart/web3dart.dart';

class BidScreen extends StatefulWidget {
  BidScreen({super.key, required this.walletId, required this.name});
  String walletId;
  String name;

  @override
  State<BidScreen> createState() => _BidScreenState();
}

var httpClient = Client();

class _BidScreenState extends State<BidScreen> {
  Client? httpClient;
  Web3Client? ethClient;
  var Addata;
  late BuildContext dialogContext;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();

    setState(() {
      getAd();
    });
  }

  List<ShowAd> showAd = [];
  Widget build(BuildContext context) {
    //late BuildContext dialogContext;
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAdvertisement(
                                name: widget.name,
                                walletId: widget.walletId,
                              )));
                },
                icon: Icon(Icons.add))
          ],
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
            showAd.isEmpty
                ? CircularProgressIndicator()
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: showAd.length,
                    itemBuilder: (BuildContext context, int index) {
                      return showAd.length == 0
                          ? Container(
                              child: Text("There Are No Offers"),
                            )
                          : Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            showAd[index].name!,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${showAd[index].noOfCredits!} Credits",
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
                                                  textStyle:
                                                      MaterialStatePropertyAll(
                                                          TextStyle(
                                                              color: Color(
                                                                  0xff09891E))),
                                                  minimumSize:
                                                      MaterialStatePropertyAll(
                                                          Size(80, 40))),
                                              onPressed: () async {
                                                setState(() {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext
                                                        dialogcontext) {
                                                      dialogContext =
                                                          dialogcontext;
                                                      return Dialog(
                                                        child: new Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            new CircularProgressIndicator(),
                                                            new Text(
                                                              "Tansaction Processing",
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
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
                                                    showAd[index].walletId!,
                                                    BigInt.from(int.parse(
                                                            showAd[index]
                                                                .noOfCredits
                                                                .toString()) *
                                                        100),
                                                    ethClient!);

                                                showAd.removeAt(index);
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
                                            "₹${showAd[index].rate!} per Coin",
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
                    },
                  ),

            //         : Padding(
            //             padding: EdgeInsets.only(
            //                 top: MediaQuery.of(context).size.height / 5),
            //             child: Column(
            //               children: [
            //                 Image.asset(
            //                   "assets/no_transactions.webp",
            //                   width: 200,
            //                   height: 200,
            //                 ),
            //                 SizedBox(
            //                   height: 20,
            //                 ),
            //                 Text(
            //                   "No Transactions Requests",
            //                   style: TextStyle(
            //                       color: Color(0xff09891E),
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 25),
            //                 )
            //               ],
            //             ),
            //           )
            //   ]),
            // ),
          ]),
        )));
  }

  getAd() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? privateKeys = prefs.getString('privateKey');
      print(privateKeys!);
      Response response = await get(
        Uri.parse("https://welp-backend.onrender.com/wallet"),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body,
        ) as List;
        print(data);

        setState(() {
          for (int i = 0; i < data.length; i++) {
            showAd.add(ShowAd.fromJson(data[i]));
          }
        });
        print(showAd[0]);
        return data;

        // print('successfully');
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
    return 1;
  }
}
