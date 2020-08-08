import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class ServerException extends Failure {}

class CacheException extends Failure {}
