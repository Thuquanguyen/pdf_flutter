class MessageHandler {
  factory MessageHandler() => _instance;

  MessageHandler._();

  static final _instance = MessageHandler._();

  final Map<String, List<Function>> _mCallbacks = {};
  final Map<String, Function> _mCallbackOnes = {};

  void addListener(String eventName, Function callback) {
    List<Function> callbacks = _mCallbacks[eventName] ?? [];
    callbacks.add(callback);
    _mCallbacks[eventName] = callbacks;
  }

  void removeListener(String eventName, Function callback) {
    List<Function> callbacks = _mCallbacks[eventName] ?? [];
    if (callbacks.contains(callback)) {
      callbacks.remove(callback);
    }
    _mCallbacks[eventName] = callbacks;
  }

  void register(String eventName, Function(dynamic) callback) {
    _mCallbackOnes[eventName] = callback;
  }

  void unregister(String eventName) {
    _mCallbackOnes.remove(eventName);
  }

  void notify(String eventName, {dynamic data}) {
    try {
      List<Function> callbacks = _mCallbacks[eventName] ?? [];
      for (final callback in callbacks) {
        if (callback is Function) {
          if(data != null) {
            callback.call(data);
          } else {
            callback.call();
          }
        }
      }
      if (_mCallbackOnes.containsKey(eventName)) {
        final callback = _mCallbackOnes[eventName];
        if (callback is Function) {
          callback.call(data);
        }
      }
    } catch(e) {
      print(e.toString());
    }
  }
}
