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
  static const String baseUrl = '${Paths.root}/${Paths.suiteBase}';
  static const String clientTokenUrl = '$baseUrl/v1/oauth2/token';
  static const String userTokenUrl = '$baseUrl/v1/tokens';
  static const String key = 'TW9uZXlNQjp0cHN0cHM=';
  static const String portalId = '2';
}

abstract class Paths {
  static const String root = 'http://192.168.18.239:4010';
  static const String suiteBase = 'api';
  static const String coreBase = 'api';
  static const String transactions = '$suiteBase/v2/Transactions';
  static const String users = '$suiteBase/v1/Users';
  static const String qrImage = '$suiteBase/v1/qrcodes/entities/merchants';
  static const String forgotUserId = '$suiteBase/v1/recover/userId';
  static const String forgotPassword = '$suiteBase/v1/recover/password';
  static const String refundTransaction = '$coreBase/Transaction/Refund';
  static const String miniStatement = '$coreBase/Transaction/MiniStatement';
  static const String handlerDetails =
      '$suiteBase/v1/handlers/users'; // for handler ID to get handler information
  static const String handlerInformation =
      '$suiteBase/v1/handlers'; // get associated handler ID from above to get isAdmin key
  static const String wallets = '$suiteBase/v1/wallets';
  static const String walletInstruments = 'Instruments';
  static const String sendOTP = '$suiteBase/v1/otps';
  static const String pullPayment = '$coreBase/Transaction/PullPayment';
  static const String errorMessage = '$suiteBase/v1/Transactions/errorCodes';
  static const String complaints = '$suiteBase/v1/Tickets';
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

