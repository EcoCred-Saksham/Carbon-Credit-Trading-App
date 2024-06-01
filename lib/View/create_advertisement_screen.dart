import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:swachapp/View/Bid_screen.dart';

class CreateAdvertisement extends StatefulWidget {
  CreateAdvertisement({super.key, required this.walletId, required this.name});
  String name;
  String walletId;

  @override
  State<CreateAdvertisement> createState() => _CreateAdvertisementState();
}

class _CreateAdvertisementState extends State<CreateAdvertisement> {
  static final _formKeyCreateAd = GlobalKey<FormState>();
  TextEditingController aadhar = TextEditingController();
  TextEditingController numberOfCredits = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF5F9FF),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKeyCreateAd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    "assets/token_image.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Create New Advertisement',
                  style: TextStyle(
                      fontFamily: "Jost",
                      color: Color(0xff202244),
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    style: TextStyle(color: Color(0xff505050)),
                    controller: numberOfCredits,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Total Number of Credits to be sold",
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff505050)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    // obscureText: !_passwordVisible,
                    style: TextStyle(color: Color(0xff505050)),
                    controller: amount,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the amount";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Amount of one credit",

                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff505050),
                      ),

                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff09891E))),
                    onPressed: () async {
                      if (_formKeyCreateAd.currentState!.validate()) {
                        newAd(widget.walletId, int.parse(amount.text),
                            int.parse(numberOfCredits.text), widget.name);
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BidScreen(
                              name: widget.name,
                              walletId: widget.walletId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: width * 0.155,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              color: Color(0xff09891E),
                              onPressed: () async {
                                if (_formKeyCreateAd.currentState!.validate()) {
                                  newAd(
                                      widget.walletId,
                                      int.parse(amount.text),
                                      int.parse(numberOfCredits.text),
                                      widget.name);
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BidScreen(
                                        name: widget.name,
                                        walletId: widget.walletId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.arrow_forward)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputBorder InputFormfieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
  newAd(String walletId, int rate, int credits, String name) async {
    try {
      // User user=User(name: name, walletId: walletId, numberOfCreds: numberOfCreds, amount: amount)
//print((walletId+ credits+)  )
      Response response = await post(
        Uri.parse("https://welp-backend.onrender.com/wallet"),
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode(
          {
            "wallet_id": walletId,
            "rate": rate,
            "no_of_credits": credits,
            "name": name
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['message']);
        print('successfull');
      } else {
        print('failed');
      }
      print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }

    return;
  }
}
