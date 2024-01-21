class NetworkResponse {
  final int statusCode;
  final bool isSuccess;

  Map<String, dynamic>? body;

  NetworkResponse(this.isSuccess, this.statusCode, this.body);
}
