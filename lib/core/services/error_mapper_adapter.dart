import 'package:medifinder/core/network/app_error_mapper.dart';
import 'package:medifinder/features/provider_search/domain/services/i_error_mapper.dart';

/// Adapter that implements the domain-level [IErrorMapper] contract by delegating
/// to the existing static [AppErrorMapper] implementation.
class ErrorMapperAdapter implements IErrorMapper {
  @override
  String map(Object error) => AppErrorMapper.toUserMessage(error);
}
