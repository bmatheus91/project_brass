import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {}
