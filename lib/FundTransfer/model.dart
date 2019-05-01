import 'package:flutter_chat_demo/Util/http.dart';
import 'package:flutter_chat_demo/global.dart';

class FundTransferApi {
  final HttpDataSource dataSource;
  final String token;

  FundTransferApi(this.dataSource, this.token);

  Future<FundTransferResponse> fundTransfer(String amount) async {
    Map data = await dataSource.get(
        '${Paths.fundTransfer}?' +
            "TransactionReference=114842489441&Amount=" +
            amount +
            "&FromAccount=03462817221&ToAccount=03322304024&Mobile=03322304024",
        token: token);
    //.get('${Paths.billpayment}'+"CompanyName=LESCO&ConsumerNumber=00311005977522&AccountNumber=03242510861&Amount=10&ReferenceNumber=122334", token: token);

    var dataNested = data['Response'];
    print(dataNested);

    var dataItems = dataNested['data'];
    print(dataItems);

    FundTransferResponse responseFetch = new FundTransferResponse(
        availableAmount: dataItems['availableAmount'],
        mobileNumber: dataItems['mobileNumber'],
        transactionReference: dataItems['transactionReference'],
        message: "Fund transfer successful. Txn Ref No. " +
            dataItems['transactionReference'] +
            ", Remaining balance: PKR " +
            dataItems['availableAmount']);

    return responseFetch;
  }
}

class FundTransferResponse {
  final String availableAmount;
  final String mobileNumber;
  final String transactionReference;
  String message;

  FundTransferResponse(
      {this.availableAmount,
      this.mobileNumber,
      this.transactionReference,
      this.message});
}
