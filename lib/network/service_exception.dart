import 'package:equatable/equatable.dart';

/// {@template exceptions_repository}
/// Repository which provides exceptions in a format to users
/// {@endtemplate}
class ServiceException extends Equatable implements Exception {
  /// {@macro exceptions_repository}
  const ServiceException({
    this.code,
    this.message,
  });

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name, for example
  /// "wrong-password" is used when a user insert the wrong password
  final String? code;

  /// The long form message of the exception.
  final String? message;

  @override
  List<Object?> get props => [code, message];
}

class RepoServiceException extends ServiceException implements Exception {
  const RepoServiceException({
    super.message,
  });
}
