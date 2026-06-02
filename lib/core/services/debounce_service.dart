import 'dart:async';

import 'package:medifinder/core/services/id_debounce_service.dart';

/// Concrete implementation of [IDebounceService] using a [Timer].
class DebounceService implements IDebounceService {
  Timer? _timer;

  @override
  void debounce(void Function() action, Duration duration) {
    // Cancel any existing timer to reset the debounce period.
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  @override
  void dispose() {
    _timer?.cancel();
  }
}
