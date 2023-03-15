import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticatedHttpClient {
  final GetStorage storage = GetStorage();

  Future<http.Response> get(String url) async {
    final token = storage.read('token');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> post(String url, {Map<String, String>? body}) async {
    final token = storage.read('token');
    final response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );
    return response;
  }

  Future<http.Response> postWithMultipart(String url,
      {Map<String, String>? fields, List<http.MultipartFile>? files}) async {
    final token = storage.read('token');
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $token';

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      request.files.addAll(files);
    }

    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<http.Response> put(String url, {Map<String, String>? body}) async {
    final token = storage.read('token');
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );
    return response;
  }

  Future<http.Response> patch(String url, {Map<String, String>? body}) async {
    final token = storage.read('token');
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );
    return response;
  }

  Future<http.Response> delete(String url) async {
    final token = storage.read('token');
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response;
  }
}
