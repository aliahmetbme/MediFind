abstract class IDebounceService {
  /// Schedules [action] to be executed after [duration] of inactivity.
  /// Subsequent calls reset the timer.
  void debounce(void Function() action, Duration duration);

  /// Clean up any resources (e.g., cancel timers) when no longer needed.
  void dispose();
}
