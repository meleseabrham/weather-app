import '../errors/failures.dart';

abstract class Result<T> {
  const Result();
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;
  
  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as ResultFailure<T>).failure : null;
  
  R fold<R>(R Function(T data) onSuccess, R Function(Failure failure) onFailure) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as ResultFailure<T>).failure);
    }
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure);
} 