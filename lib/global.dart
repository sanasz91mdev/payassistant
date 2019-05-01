import 'Util/error_handler.dart';
import 'Util/http.dart';

abstract class Routes {
  static const String home = '/home';
  static const String forgot_credentials = '/forgot_credentials';
  static const String qrImage = '/qr_code_image';
  static const String root = '/';
  static const String transactionSearch = '/transaction_search';
  static const String transactionSearchWithRefund =
      '/transaction_search_refund';
  static const String walletHome = '/wallet_home';
  static const String pullPayment = '/payment_screens';
  static const String complaintListing = '/complaint_listing';
  static const String addComplaint = '/add_complaint';
  static const String pullPaymentScreen = '/pull_payment_screen';
}

abstract class AuthConstants {
  static const String baseUrl = 'https://apigateway.bankalfalah.com/bankalfalah/sb';
  static const String clientTokenUrl = '$baseUrl/v1/oauth2/token';
  static const String userTokenUrl = '$baseUrl/v1/tokens';
  static const String key = 'TW9uZXlNQjp0cHN0cHM=';
  static const String portalId = '2';
}

abstract class Paths {
  static const String root = 'https://apigateway.bankalfalah.com/bankalfalah/sb';
  static const String walletsTitleFetch = 'wallet-title-fetch/WalletTitleFetch';
  static const String billpayment = 'bill-payment/BillPaymentAccount';
  static const String fundTransfer = 'wallettransfer2/WalletTransfer2';
}

abstract class UserIds {
  static const String taha = 'rivyU2AWJPIx1LvODrZD';
  static const String sana = 'y7Bujzh8hcUg8Tgj0q2I';
  static const String currentUser = sana;
}




final Authenticator authenticator = new Authenticator(
    AuthConstants.clientTokenUrl,
    AuthConstants.userTokenUrl,
    AuthConstants.key);
const bool _allowSelfSignedCertificates = true;

ErrorHandler errorHandler = new CustomErrorHandler(new HttpDataSource(
    Paths.root, _allowSelfSignedCertificates, new DefaultErrorHandler()));

DataSource get httpDataSource =>
    new HttpDataSource(Paths.root, _allowSelfSignedCertificates, errorHandler);


const List<String> successResponseCodes = ['00', '000'];

