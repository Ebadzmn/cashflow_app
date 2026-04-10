import 'dart:io';

import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class IncomeRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<Map<String, dynamic>> createTransaction({
    required String endpoint,
    required Map<String, String> fields,
    File? image,
  }) async {
    final response = await _apiClient.postMultipart(
      endpoint,
      fields: fields,
      files: image == null ? null : {'image': image},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return <String, dynamic>{'data': data};
  }

  Future<Map<String, dynamic>> createIncome({
    required Map<String, String> fields,
    File? image,
  }) {
    return createTransaction(
      endpoint: ApiEndpoints.income,
      fields: fields,
      image: image,
    );
  }

  Future<Map<String, dynamic>> createExpense({
    required Map<String, String> fields,
    File? image,
  }) {
    return createTransaction(
      endpoint: ApiEndpoints.expense,
      fields: fields,
      image: image,
    );
  }

  Future<Map<String, dynamic>> createBankTransaction({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.bankTransaction,
      body: body,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return <String, dynamic>{'data': data};
  }
}
