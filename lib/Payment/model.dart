import 'package:flutter_chat_demo/Util/http.dart';
import 'package:flutter_chat_demo/global.dart';

class BillPaymentApi {
  final HttpDataSource dataSource;
  final String token;

  BillPaymentApi(this.dataSource, this.token);

  Future<BillPaymentResponse> payBill(String company, String consumer, String wallet, String amount, String refNo) async {
    print('hit');
    Map data = await dataSource
    .get('${Paths.billpayment}'+"CompanyName="+ company +"&ConsumerNumber="+ consumer +"&AccountNumber="+ wallet +"&Amount="+ amount +"&ReferenceNumber=122334", token: token);
        //.get('${Paths.billpayment}'+"CompanyName=LESCO&ConsumerNumber=00311005977522&AccountNumber=03242510861&Amount=10&ReferenceNumber=122334", token: token);

    var dataNested = data['Response'];
    print(dataNested);

    var dataItems = dataNested['data'];
    print(dataItems);

    var response = dataNested['ResponseCode'];

    BillPaymentResponse responseFetch = new BillPaymentResponse(
        companyName: dataItems['CompanyName'],
        consumerNumber: dataItems['ConsumerNumber'],
        paidAmount: dataItems['AmountPaid'],
        message: response == '00'
            ? "Bill Payment Successful for "+ dataItems['CompanyName']
            : "Could not process your request");

    return responseFetch;
  }
}

class BillPaymentResponse {
  final String companyName;
  final String consumerNumber;
  final String paidAmount;
  String message;

  BillPaymentResponse({this.companyName, this.consumerNumber, this.paidAmount, this.message});
}
