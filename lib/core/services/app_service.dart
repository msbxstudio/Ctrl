import 'package:flutter/foundation.dart';

/// Base class for application services.
abstract class AppService<T> {
  /// The service instance.
  @protected
  late final T service;

  bool _initialized = false;

  /// Indicates whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Creates an instance of [AppService] with the provided service instance.
  AppService(this.service);

  /// Creates an instance of [AppService] without initializing the service.
  AppService.later();

  /// Sets the initialized state of the service.
  @protected
  void setInitialized(bool value) {
    _initialized = value;
  }

  /// Initialize the service
  void initialize();

  /// Dispose resources
  void dispose();
}
