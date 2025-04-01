import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseController<S, I, E> extends AutoDisposeNotifier<S> {
  final StateProvider<E?> eventProvider;

  BaseController(this.eventProvider);

  S buildState();
  void processIntent(I intent);

  void sendEvent(E event) {
    ref.read(eventProvider.notifier).state = event;
  }

  @override
  S build() {
    ref.onDispose(() => ref.read(eventProvider.notifier).state = null);
    return buildState();
  }
}

extension ProviderListenableExt<T> on ProviderListenable<T> {
  void observe(WidgetRef ref, void Function(T) onEvent) {
    ref.listen(this, (_, event) => onEvent(event));
  }
}
