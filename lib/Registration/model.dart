import 'package:flutter_chat_demo/Util/http.dart';
import 'package:flutter_chat_demo/global.dart';

class RegistrationApi {
  final HttpDataSource dataSource;
  final String token;

  RegistrationApi(this.dataSource, this.token);

  Future<TitleFetchResponse> doRegister(String walletId) async {
    print('hit');
    Map data = await dataSource
        .get('${Paths.walletsTitleFetch}'+"?WalletID=" + walletId, token: token);

    var dataNested = data['data'];
    print(dataNested);

    var dataItems = dataNested['item'];
    print(dataItems);
    String response = data['code'];

    TitleFetchResponse responseFetch = new TitleFetchResponse(
        title: dataItems['accountTitle'],
        code: data['code'],
        message: response == '00'
            ? "User " + dataItems['accountTitle'] + " registered successfully"
            : "Could not process your request");

    return responseFetch;
  }
}

class TitleFetchResponse {
  final String title;
  final String code;
  String message;

  TitleFetchResponse({this.title, this.code, this.message});
}
