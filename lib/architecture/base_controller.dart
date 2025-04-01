import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseController<S, I, E> extends AutoDisposeNotifier<S> {

  final _eventNotifierProvider = NotifierProvider<EventNotifier<E>, E?>(() => EventNotifier<E>());
  NotifierProvider<EventNotifier<E>, E?> get eventProvider => _eventNotifierProvider;
  
  S buildState();
  void processIntent(I intent);

  void sendEvent(E event) {
    ref.read(eventProvider.notifier).emit(event);
  }

  @override
  S build() {
    ref.onDispose(() => ref.read(eventProvider.notifier).reset());
    return buildState();
  }
}

class EventNotifier<E> extends Notifier<E?> {
  @override
  E? build() => null;

  void emit(E event) {
    state = null;
    state = event;
  }

  void reset() {
    state = null;
  }
}
