import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/core/errors/failures.dart';

abstract class AuthRemoteDataSource {
  Future<bool> validateUuid(String uuid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> validateUuid(String uuid) async {
    final url = Uri.parse('https://tradingai.academytable.ru/validate');
    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'uuid': uuid}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] == true;
      } else {
        throw ServerFailure(message: 'Failed to validate UUID: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}