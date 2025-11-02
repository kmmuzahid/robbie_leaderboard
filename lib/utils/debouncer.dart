import 'dart:async';

class CommonDebouncer {
  CommonDebouncer({required this.delay});

  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel(); // cancel any previous action
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;

  void dispose() {
    _timer?.cancel();
  }
}
