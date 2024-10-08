import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swachapp/services/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'SwachToken'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          // gasPrice: EtherAmount.fromInt(EtherUnit.gwei, 5000),
          contract: contract,
          function: ethFunction,
          parameters: args),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<String> sendToken(String to, BigInt amount, Web3Client ethClient) async {
  EthereumAddress reciever = EthereumAddress.fromHex(to);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? privateKeys = prefs.getString('privateKey');
  print(privateKeys);
  var response = await callFunction(
      'transfer', [reciever, amount], ethClient, privateKeys!);
  print('Transaction Successfull');
  print(response);
  return response;
}
