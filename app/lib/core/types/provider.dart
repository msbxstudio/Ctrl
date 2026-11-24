import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the asynchronous state of an imperative operation.
///
/// Intended for tracking transient operations such as form submissions,
/// data mutations, or user-triggered asynchronous actions, independently
/// of the state managed by a controller.
///
/// The state is automatically disposed when no longer observed.
typedef MutationProvider<T> = AutoDisposeStateProvider<AsyncValue<T>>;

/// Exposes a repository as a dependency within the provider graph.
///
/// Decouples consumers from concrete repository implementations and supports
/// dependency substitution through provider overrides.
///
/// The provider state is automatically disposed when no longer observed.
typedef RepositoryProvider<T> = AutoDisposeProvider<T>;

/// Exposes a controller responsible for managing asynchronous feature state.
///
/// Encapsulates state initialization, transitions, and operations behind
/// a notifier-based interface, allowing consumers to observe state changes
/// without depending on the underlying implementation.
///
/// The controller and its state are automatically disposed when no longer
/// observed.
typedef ControllerProvider<C extends AutoDisposeAsyncNotifier<S>, S> =
    AutoDisposeAsyncNotifierProvider<C, S>;

/// Defines a parameterized provider for asynchronous feature controllers.
///
/// Each distinct argument of type [A] identifies an independent controller
/// instance with its own state of type [S] and lifecycle.
///
/// Arguments must provide consistent equality and hash code implementations
/// to ensure stable provider identity.
///
/// Each instance is automatically disposed when no longer observed.
typedef ControllerFamilyProvider<
  C extends AutoDisposeFamilyAsyncNotifier<S, A>,
  S,
  A
> = AutoDisposeAsyncNotifierProviderFamily<C, S, A>;
