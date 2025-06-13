class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({this.message = 'Server Error', this.statusCode});

  @override
  String toString() {
    return 'ServerException: $message' + (statusCode != null ? ' (Status: $statusCode)' : '');
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache Error'});

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No Internet Connection'});

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}