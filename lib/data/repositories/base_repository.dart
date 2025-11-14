// lib/data/repositories/base_repo.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:oc_academy_app/core/constants/api_params.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';

// The generic type T is used here to allow the return type to be dynamic, 
// often a Map<String, dynamic> representing the JSON response.
class BaseRepo<T> {
  
  // --- GET Request ---
  Future<T> get({
    required String apiURL,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // 1. Check Internet Connectivity
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return {
        paramStatusCode: codeNoInternet,
        paramMessage: apiUtils.getNetworkError(),
      } as T;
    }

    // 2. Perform API Call
    try {
      final response = await apiUtils.get(
        url: apiURL,
        queryParameters: queryParameters,
        options: options,
      );
      // Assuming 'response.data' is the actual JSON body (Map<String, dynamic>)
      return response.data;
    } catch (e) {
      // 3. Handle Errors
      return {
        paramStatusCode: codeError,
        paramMessage: apiUtils.handleError(e),
      } as T;
    }
  }

  // --- POST Request ---
  Future<T> post({
    required String apiURL,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // 1. Check Internet Connectivity
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return {
        paramStatusCode: codeNoInternet,
        paramMessage: apiUtils.getNetworkError(),
      } as T;
    }

    // 2. Perform API Call
    try {
      final response = await apiUtils.post(
        url: apiURL,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      // Assuming 'response.data' is the actual JSON body (Map<String, dynamic>)
      return response.data;
    } catch (e) {
      // 3. Handle Errors
      return {
        paramStatusCode: codeError,
        paramMessage: apiUtils.handleError(e),
      } as T;
    }
  }
}