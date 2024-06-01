import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swachapp/View/Bid_screen.dart';
import 'package:swachapp/services/model.dart';

class WalletSetup extends StatefulWidget {
  const WalletSetup({super.key, required this.name});
  final String name;

  @override
  State<WalletSetup> createState() => _WalletSetupState();
}

class _WalletSetupState extends State<WalletSetup> {
  static final _formKeyWallet = GlobalKey<FormState>();
  TextEditingController privateKey = TextEditingController();
  TextEditingController publicKey = TextEditingController();

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
            key: _formKeyWallet,
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
                  'Enter Wallet Details',
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
                    controller: publicKey,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the Public Key";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Public Key",
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
                    controller: privateKey,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the Private Key";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Private Key",

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
                        if (_formKeyWallet.currentState!.validate()) {
                          saveKeys(publicKey.text.toString(),
                              privateKey.text.toString(), widget.name);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BidScreen(
                                        name: widget.name,
                                        walletId: publicKey.text,
                                      )));
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
                                  if (_formKeyWallet.currentState!.validate()) {
                                    await saveKeys(
                                        publicKey.text.toString(),
                                        privateKey.text.toString(),
                                        widget.name);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BidScreen(
                                          name: widget.name,
                                          walletId: publicKey.text,
                                        ),
                                      ),
                                    );
                                  }

                                  // if (_formKey.currentState!.validate()) {
                                  //   // print(aadhar.text);
                                  //   // print(pass.text);
                                  //   // await login(aadhar.text.toString(),
                                  //   //     pass.text.toString());
                                  //   //                             Navigator.push(
                                  //   // context, MaterialPageRoute(builder: (context) => OtpScreen(aadhar: aadhar.text,)));
                                  // }
                                },
                                icon: Icon(Icons.arrow_forward)),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveKeys(
      String publicKey, String privateKey, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('publicKey', publicKey);
    await prefs.setString('privateKey', privateKey);
    
    Map<String, dynamic> user = {
      "name": name,
      "walletId": publicKey,
    };
    User.fromMap(user);
  }

  InputBorder InputFormfieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
}
