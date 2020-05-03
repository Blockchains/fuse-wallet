import 'package:flutter/material.dart';
import 'package:seedbed/models/app_state.dart';
import 'package:seedbed/models/community.dart';
import 'package:seedbed/models/pro/token.dart' as erc20Token;
import 'package:seedbed/models/token.dart';
import 'package:seedbed/redux/actions/cash_wallet_actions.dart';
import 'package:seedbed/redux/actions/pro_mode_wallet_actions.dart';
import 'package:redux/redux.dart';

class SendAmountViewModel {
  final Token token;
  final bool isProMode;
  final String myCountryCode;
  final Community community;
  final Function(String name, String phoneNumber, num, String receiverName, String transferNote, VoidCallback, VoidCallback, {Token token}) sendToContact;
  final Function(String, num, String receiverName, String transferNote, VoidCallback, VoidCallback, {Token token}) sendToAccountAddress;
  final Function(String eventName, {Map<String, dynamic> properties}) trackTransferCall;
  final Function(Map<String, dynamic> traits) idenyifyCall;
  final Function(num tokensAmount, VoidCallback sendSuccessCallback, VoidCallback sendFailureCallback) sendToCashMode;
  final Function(erc20Token.Token token, String recieverAddress, num amount, VoidCallback, VoidCallback, {String receiverName, String transferNote, }) sendToErc20Token;

  SendAmountViewModel(
      {this.token,
      this.myCountryCode,
      this.sendToContact,
      this.sendToAccountAddress,
      this.trackTransferCall,
      this.idenyifyCall,
      this.isProMode,
      this.community,
      this.sendToCashMode,
      this.sendToErc20Token,});

  static SendAmountViewModel fromStore(Store<AppState> store) {
    String communityAddres = store.state.cashWalletState.communityAddress;
    Community community = store.state.cashWalletState.communities[communityAddres] ?? new Community.initial();
    return SendAmountViewModel(
        isProMode: store.state.userState.isProMode ?? false,
        token: community.token,
        community: community,
        myCountryCode: store.state.userState.countryCode,
        sendToContact: (
            String name,
            String phoneNumber,
            num amount,
            String receiverName,
            String transferNote,
            VoidCallback sendSuccessCallback,
            VoidCallback sendFailureCallback,
            {Token token}
        ) {
          store.dispatch(sendTokenToContactCall(
            name,
            phoneNumber,
            amount,
            sendSuccessCallback,
            sendFailureCallback,
            receiverName: receiverName,
            token: token
          ));
        },
        sendToAccountAddress: (
            String recieverAddress,
            num amount,
            String receiverName,
            String transferNote,
            VoidCallback sendSuccessCallback,
            VoidCallback sendFailureCallback,
            {Token token}
          ) {
          store.dispatch(sendTokenCall(
            recieverAddress,
            amount,
            sendSuccessCallback,
            sendFailureCallback,
            receiverName: receiverName,
            token: token
          ));
        },
        sendToCashMode: (
            num tokensAmount, 
            VoidCallback sendSuccessCallback,
            VoidCallback sendFailureCallback,
          ) {
          store.dispatch(sendDaiToDaiPointsCall(
            tokensAmount,
            sendSuccessCallback,
            sendFailureCallback
          ));
        },
        sendToErc20Token: (
            erc20Token.Token token,
            String recieverAddress,
            num amount,
            VoidCallback sendSuccessCallback,
            VoidCallback sendFailureCallback,
          {String receiverName,
            String transferNote,}) {
          store.dispatch(sendErc20TokenCall(
            token,
            recieverAddress,
            amount,
            sendSuccessCallback,
            sendFailureCallback,
            receiverName: receiverName,
          ));
        },
        trackTransferCall: (String eventName, {Map<String, dynamic> properties}) {
          store.dispatch(segmentTrackCall(eventName, properties: properties));
        },
        idenyifyCall: (Map<String, dynamic> traits) {
          store.dispatch(segmentIdentifyCall(traits));
        });
  }
}
