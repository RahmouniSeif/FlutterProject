import '../../GeneratedServices/api.dart';

Future<ApiClient> primeHeaders() async {
  final HttpBearerAuth authentication = new HttpBearerAuth();
  final apiClient = ApiClient(basePath: "http://localhost:8081", authentication: authentication);
  // final apiClient = ApiClient(basePath: "http://192.168.1.47:8081", authentication: authentication);

  //final apiClient = ApiClient(basePath: "http://10.0.2.2:8081", authentication: authentication);
  return apiClient;
}
