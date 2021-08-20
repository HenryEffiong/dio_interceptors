import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_connectivity_retry_interceptor_tutorial/interceptor/dio_connectivity.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrial requestRetrial;

  RetryOnConnectionChangeInterceptor({this.requestRetrial});
  @override
  Future onError(DioError err) async {
    // TODO: implement onError
    if (_shouldRetry(err)) {
      try {
        return requestRetrial.scheduleRequestRetry(err.request);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
  }
}
