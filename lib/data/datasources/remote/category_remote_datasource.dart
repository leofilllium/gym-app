import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> fetchCategories(String languageCode);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> fetchCategories(String languageCode) async {
    final url = Uri.parse('http://tradingai.academytable.ru/$languageCode.json');
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(decoded);
        if (data['categories'] == null) {
          throw ServerFailure(message: 'No categories found in response');
        }
        final List<dynamic> categoriesJson = data['categories'];
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerFailure(message: 'Failed to load categories (status: ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}