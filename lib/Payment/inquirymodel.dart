import 'package:flutter_chat_demo/Util/http.dart';
import 'package:flutter_chat_demo/global.dart';

class BillInquiryApi {
  final HttpDataSource dataSource;
  final String token;

  BillInquiryApi(this.dataSource, this.token);

  Future<BillInquiryResponse> inquireBill(String company, String consumer) async {
    print('hit');
    Map data = await dataSource
    .get('${Paths.billinquiry}'+"?CompanyName="+ company +"&ConsumerNumber="+ consumer, token: token);
        
    var dataNested = data['BillEnquiry'];
    print(dataNested);

    var dataItems = dataNested['Response'];
    print(dataItems);

    var resultData = dataItems['Result'];
    var response = dataItems['ResponseCode'];

    var duedate = resultData['PayDueDate'].toString().substring(4) + "/April/20" + resultData['PayDueDate'].toString().substring(0, 2);
    BillInquiryResponse responseFetch = new BillInquiryResponse(
        companyName: resultData['CompanyName'],
        consumerNumber: resultData['ConsumerNumber'],
        subscriberName: resultData['SubscriberName'],
        billingMonth: resultData['BillMon'],
        paymentAmount: resultData['AmountPay'],
        duedateAmount: resultData['PayAfterDueDate'],
        dueDate: duedate,
        billStatus: resultData['BillStatus'],
        billStatusDesc: resultData['BillStatusDescription'],
        message: response == '00'
            ? "Your " + resultData['CompanyName'] + " Bill with amount " + resultData['AmountPay'] + " is due by " + duedate
            : "Could not process your request");

    return responseFetch;
  }
}

class BillInquiryResponse {
  final String companyName;
  final String consumerNumber;
  final String subscriberName;
  final String billingMonth;
  final String paymentAmount;
  final String duedateAmount;
  final String dueDate;
  final String billStatus;
  final String billStatusDesc;
  String message;

  BillInquiryResponse({this.companyName, this.consumerNumber, this.subscriberName, this.billingMonth,this.paymentAmount, this.duedateAmount, this.dueDate, this.billStatus, this.billStatusDesc, this.message});
}
