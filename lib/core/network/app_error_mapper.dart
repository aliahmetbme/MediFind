// lib/core/network/app_error_mapper.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Centralises exception → user-facing message mapping so raw technical strings
// never reach the UI layer.
//
// Design:
//   • Single static method — no instantiation needed.
//   • Pattern-matched on lowercased exception message strings.
//   • Caller never sees "Exception: ..." or stack-trace fragments.
//   • Add more patterns here as new error types are introduced.
// ─────────────────────────────────────────────────────────────────────────────

/// Maps any [Exception] or arbitrary [Object] error to a safe, human-readable
/// message suitable for direct display in the UI.
abstract final class AppErrorMapper {
  /// Returns a user-friendly message for [error].
  ///
  /// Pattern matching is intentionally lenient (substring check on lowercased
  /// string) so it catches both Dart and platform-level exception messages.
  static String toUserMessage(Object error) {
    final raw = error.toString().toLowerCase();

    if (_isNetworkError(raw)) {
      return 'Please check your internet connection and try again.';
    }
    if (_isTimeoutError(raw)) {
      return 'The request timed out. Please try again.';
    }
    if (_isServerError(raw)) {
      return 'A server error occurred. Please try again later.';
    }

    // Generic fallback — never exposes the raw technical message.
    return 'Something went wrong. Please try again.';
  }

  static bool _isNetworkError(String lower) =>
      lower.contains('network') ||
      lower.contains('socket') ||
      lower.contains('connect') ||
      lower.contains('internet') ||
      lower.contains('offline') ||
      lower.contains('unreachable');

  static bool _isTimeoutError(String lower) =>
      lower.contains('timeout') || lower.contains('timed out');

  static bool _isServerError(String lower) =>
      lower.contains('500') ||
      lower.contains('server') ||
      lower.contains('internal');
}
