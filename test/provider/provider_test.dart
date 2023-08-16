import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpie/riverpie.dart';
import 'package:riverpie/src/notifier/types/immutable_notifier.dart';

void main() {
  group(Provider, () {
    test('Should read the value', () {
      final provider = Provider((ref) => 123);
      final observer = RiverpieHistoryObserver();
      final scope = RiverpieScope(
        observer: observer,
        child: Container(),
      );

      expect(scope.read(provider), 123);

      // Check events
      final notifier = scope.anyNotifier<ImmutableNotifier<int>, int>(provider);
      expect(observer.history, [
        ProviderInitEvent(
          provider: provider,
          notifier: notifier,
          cause: ProviderInitCause.access,
          value: 123,
        ),
      ]);
    });

    test('Should read the nested value', () {
      final providerA = Provider((ref) => 'AAA');
      final providerB = Provider((ref) => 'BBB');
      final providerC = Provider((ref) {
        final a = ref.read(providerA);
        final b = ref.read(providerB);
        return '$a $b CCC';
      });
      final observer = RiverpieHistoryObserver();
      final scope = RiverpieScope(
        observer: observer,
        child: Container(),
      );

      expect(scope.read(providerC), 'AAA BBB CCC');

      // Check events
      final notifierA = scope.anyNotifier<ImmutableNotifier<String>, String>(
        providerA,
      );
      final notifierB = scope.anyNotifier<ImmutableNotifier<String>, String>(
        providerB,
      );
      final notifierC = scope.anyNotifier<ImmutableNotifier<String>, String>(
        providerC,
      );

      expect(observer.history, [
        ProviderInitEvent(
          provider: providerA,
          notifier: notifierA,
          cause: ProviderInitCause.access,
          value: 'AAA',
        ),
        ProviderInitEvent(
          provider: providerB,
          notifier: notifierB,
          cause: ProviderInitCause.access,
          value: 'BBB',
        ),
        ProviderInitEvent(
          provider: providerC,
          notifier: notifierC,
          cause: ProviderInitCause.access,
          value: 'AAA BBB CCC',
        ),
      ]);
    });
  });
}
