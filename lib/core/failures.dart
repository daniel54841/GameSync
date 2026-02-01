class AppFailure {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const AppFailure(this.message, {this.error, this.stackTrace});
}
