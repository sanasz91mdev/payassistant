import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'error_handler.dart';
const bool _allowSelfSignedCertificates = true;

class HttpClientFactory {
  static HttpClient createClient(
      [bool allowSelfSignedCertificates = _allowSelfSignedCertificates]) {
    var client = new HttpClient();
    if (allowSelfSignedCertificates) {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    }
    return client;
  }
}

class Authenticator {
  String _token;
  String _sessionToken;
  String _userId;

  final HttpClient _client;
  final String key;
  final String clientTokenUrl;
  final String userTokenUrl;

  String get sessionToken => _sessionToken;
  String get userId => _userId;
  String get token => _token;

  Authenticator(this.clientTokenUrl, this.userTokenUrl, this.key,
      [bool allowSelfSignedCertificates = _allowSelfSignedCertificates])
      : assert(clientTokenUrl != null),
        assert(key != null),
        _client = HttpClientFactory.createClient(allowSelfSignedCertificates);

  Future<String> getToken({bool useCached: true}) async {
    if (_token != null && useCached) return _token;

    _token = await _getToken('grant_type=client_credentials', clientTokenUrl);

    return _token;
  }

  Future<String> getSessionToken({
    String userId,
    String password,
    String portalId,
    bool useCached: true,
  }) async {
    assert(userId != null);
    assert(password != null);

    if (_sessionToken != null && useCached) return _sessionToken;

    _sessionToken = await _getToken(
        'grant_type=password&'
        'username=$userId&'
        'password=$password&'
        'portalId=$portalId',
        userTokenUrl);

    _userId = userId;

    return _sessionToken;
  }

  Future<String> _getToken(String formData, String url) async {
    var req = await _client.postUrl(Uri.parse(url));
    req
      ..headers.contentType = new ContentType(
          'application', 'x-www-form-urlencoded',
          charset: 'utf-8')
      ..headers.add(HttpHeaders.AUTHORIZATION, 'Basic $key')
      ..write(formData);

    var resp = await req.close();

    await _checkAndThrowError(resp);

    Map data = await _parseData(resp);
    return data["access_token"];
  }

  Future _checkAndThrowError(HttpClientResponse response) async {
    if (response.statusCode == HttpStatus.NOT_FOUND ||
        response.statusCode >= 400) {
      Map data = await _parseData(response);
      String error = '';
      if (data.containsKey('message')) {
        error = data['message'];
      }
      throw new HttpException(
          error.length > 0 ? error : 'Unable to process request.');
    }
  }

  Future<Object> _parseData(HttpClientResponse resp) async =>
      await resp.transform(utf8.decoder).transform(json.decoder).first;
}

class HttpDataSource implements DataSource {
  final String baseUrl;
  final HttpClient client;
  final ErrorHandler errorHandler;

  HttpDataSource(this.baseUrl,
      [bool allowSelfSignedCertificates = _allowSelfSignedCertificates,
      errorHandler = null])
      : client = HttpClientFactory.createClient(allowSelfSignedCertificates),
        errorHandler = errorHandler ?? DefaultErrorHandler();
  @override
  Future<Map> get(String entity,
      {String id, String token, Map<String, String> queryParameters}) async {
    String uriWithId = '$baseUrl/$entity${id == null ? '' : '/$id'}';
    String query = _buildQuery(queryParameters);
    Uri uri = Uri.parse('$uriWithId${query.length > 0 ? '?$query' : ''}');

    var request = await client.getUrl(uri);

    if (token != null) {
      request.headers.add(HttpHeaders.AUTHORIZATION, 'Bearer $token');
    }

    var response = await request.close();

    Map responseMap = await _extractJson(response).first;
    errorHandler.checkAndThrowError(response.statusCode, responseMap, token);
    return responseMap;
  }

  @override
  Future<Stream<Object>> getList(String entity,
      {String token, Map<String, String> queryParameters}) async {
    String query = _buildQuery(queryParameters);
    Uri uri = Uri.parse('$baseUrl/$entity${query.length > 0 ? '?$query' : ''}');
    var request = await client.getUrl(uri);
    if (token != null) {
      request.headers.add(HttpHeaders.AUTHORIZATION, 'Bearer $token');
    }

    var response = await request.close();

    _checkAndThrowError(response);

    return _extractJson(response).expand((jsonBody) => jsonBody as List);
  }

  Future<Map> postForm(
    String path, {
    String token,
    Map<String, dynamic> data,
    bool parseResponse: false,
  }) {
    return post(
      path,
      token: token,
      body: _buildQuery(data),
      parseResponse: parseResponse,
      isFormData: true,
    );
  }

  String _buildQuery(Map<String, dynamic> queryParameters) {
    String query = '';
    queryParameters?.forEach((key, value) => query += '$key=$value&');

    return query.length > 0 ? query.substring(0, query.length - 1) : query;
  }

  @override
  Future<Map> post(
    String path, {
    String token,
    dynamic body,
    bool parseResponse: false,
    isFormData: false,
    isUseBaseURL: true,
  }) async {
    Uri uri;
    uri = isUseBaseURL ? Uri.parse('$baseUrl/$path') : Uri.parse('$path');
    var request =
        await client.postUrl(uri).timeout(const Duration(seconds: 30));

    if (token != null) {
      request.headers.add(HttpHeaders.AUTHORIZATION, 'Bearer $token');
    }

    if (body != null) {
      if (isFormData) {
        request
          ..headers.contentType = new ContentType(
              'application', 'x-www-form-urlencoded',
              charset: 'utf-8')
          ..write(body);
      } else {
        request
          ..headers.contentType = ContentType.JSON
          ..write(json.encode(body));
      }
    }

    var response = await request.close();

    Map responseMap = await _extractJson(response).first;
    await errorHandler.checkAndThrowError(
        response.statusCode, responseMap, token);
    return responseMap;
  }

  void _checkAndThrowError(HttpClientResponse response) {
    if (response.statusCode == HttpStatus.NOT_FOUND) {
      throw new ResourceNotFoundException(message: 'Data not found');
    } else if (response.statusCode >= 400) {
      if (response.statusCode == 401) throw new UnauthorizedAccessException();

      throw new HttpException('Unable to process request');
    }
  }

  Stream<Object> _extractJson(HttpClientResponse response) {
    return response.transform(utf8.decoder).transform(json.decoder);
  }

  Future<Map> put(String path,
      {Map body, String token, parseResponse: false}) async {
    Uri uri = Uri.parse('$baseUrl/$path');
    var request = await client.putUrl(uri).timeout(const Duration(seconds: 30));

    if (token != null) {
      request.headers.add(HttpHeaders.AUTHORIZATION, 'Bearer $token');
    }

    if (body != null) {
      request
        ..headers.contentType = ContentType.JSON
        ..write(json.encode(body));
    }

    var response = await request.close();

    Map responseMap = await _extractJson(response).first;
    errorHandler.checkAndThrowError(response.statusCode, responseMap, token);
    return responseMap;
  }
}

abstract class DataSource {
  Future<Map> get(
    String entity, {
    String id,
    String token,
    Map<String, String> queryParameters,
  });
  Future<Stream<Object>> getList(
    String entity, {
    String token,
    Map<String, String> queryParameters,
  });
  Future<Map> post(String path,
      {String token,
      dynamic body,
      bool parseResponse: false,
      isFormData: false});
  Future<Map> postForm(
    String path, {
    String token,
    Map<String, dynamic> data,
    bool parseResponse: false,
  });
  Future<Map> put(
    String path, {
    Map body,
    String token,
    parseResponse: false,
  });
}

class UnauthorizedAccessException extends HttpException {
  UnauthorizedAccessException(
      {String message = 'User not allowed to perform this operation'})
      : super(message);

  @override
  String toString() {
    var b = new StringBuffer()
      ..write('UnauthorizedAccessException: ')
      ..write(message);
    return b.toString();
  }
}

class ResourceNotFoundException extends HttpException {
  ResourceNotFoundException({String message = 'Resource not available'})
      : super(message);

  @override
  String toString() {
    var b = new StringBuffer()
      ..write('ResourceNotFoundException: ')
      ..write(message);
    return b.toString();
  }
}

class DefaultErrorHandler implements ErrorHandler {
  DefaultErrorHandler();
  Future<void> checkAndThrowError(
      int statusCode, Map responseMap, String token) async {
    if (statusCode == HttpStatus.NOT_FOUND) {
      throw new ResourceNotFoundException(message: 'Data not found');
    } else if (statusCode >= 400) {
      if (statusCode == 401) throw new UnauthorizedAccessException();

      throw new HttpException('Unable to process request');
    }
    return;
  }
}
