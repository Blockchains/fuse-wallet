import 'package:flutter/material.dart';
import 'package:fusecash/models/pro/token.dart';
import 'package:fusecash/models/token.dart' as token;

enum SendType {
  CONTACT,
  BUSINESS,
  QR_ADDRESS,
  FUSE_ADDRESS,
  PASTED_ADDRESS,
  ETHEREUM_ADDRESS
}

class SendAmountArguments {
  String name;
  String phoneNumber;
  String accountAddress;
  num amount;
  ImageProvider avatar;
  SendType sendType;
  bool sendToCashMode = false;
  bool isProMode = false;
  Token erc20Token;
  token.Token tokenToSend;

  SendAmountArguments(
      {this.sendToCashMode = false,
      this.sendType,
      this.isProMode = false,
      this.name,
      this.phoneNumber,
      this.erc20Token,
      this.accountAddress,
      this.amount,
      this.avatar});
}
