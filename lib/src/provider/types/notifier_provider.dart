import 'package:meta/meta.dart';
import 'package:riverpie/src/notifier/base_notifier.dart';
import 'package:riverpie/src/observer/observer.dart';
import 'package:riverpie/src/provider/base_provider.dart';
import 'package:riverpie/src/provider/override.dart';
import 'package:riverpie/src/ref.dart';
import 'package:riverpie/src/widget/scope.dart';

/// Use a [NotifierProvider] to implement a stateful provider.
/// Changes to the state are propagated to all consumers that
/// called [watch] on the provider.
class NotifierProvider<N extends BaseSyncNotifier<T>, T>
    extends BaseProvider<N, T> implements NotifyableProvider<N, T> {
  @internal
  final N Function(Ref ref) builder;

  NotifierProvider(this.builder, {super.debugLabel});

  @internal
  @override
  N createState(
    RiverpieScope scope,
    RiverpieObserver? observer,
  ) {
    return builder(scope);
  }

  ProviderOverride<N, T> overrideWithNotifier(N Function() notifier) {
    return ProviderOverride(
      provider: this,
      state: notifier(),
    );
  }
}
