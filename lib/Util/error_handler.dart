import 'dart:async';
import 'dart:io';

import '../global.dart';
import 'http.dart';

abstract class ErrorHandler {
  Future<void> checkAndThrowError(int response, Map responseMap, String token);
}

class CustomErrorHandler implements ErrorHandler {
  final HttpDataSource dataSource;

  CustomErrorHandler(this.dataSource);

  Future<void> checkAndThrowError(
      int statusCode, Map responseMap, String token) async {
    try {
      if (statusCode == 401) throw new UnauthorizedAccessException();

      if (statusCode == HttpStatus.CREATED) {
        return;
      }
      if (statusCode != HttpStatus.OK) {
        throw new HttpException(responseMap["message"]);
      } else {
        if (responseMap.containsKey("responseCode")) {
          String responseCode = responseMap["responseCode"];
          if (!successResponseCodes.contains(responseCode)) {
            //Invoke Error API and return response
            // var errorResponse = await dataSource.get(
            //   Paths.errorMessage,
            //   queryParameters: {"code": responseCode},
            //   token: token,
            // );

            // List list = errorResponse["values"];
            // Map responseError = list[0];
            throw new HttpException('Your request counld not be processd');
          }
        }
      }
    } catch (e) {
      e.message != null
          ? throw new HttpException('${e.message}')
          : throw new HttpException('Unable to process request');
    }
    return;
  }
}
