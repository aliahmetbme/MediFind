// lib/core/network/resource_state.dart

sealed class ResourceState<T> {
  const ResourceState();
}

class ResourceInitial<T> extends ResourceState<T> {
  const ResourceInitial();
}

class ResourceLoading<T> extends ResourceState<T> {
  const ResourceLoading();
}

class ResourceSuccess<T> extends ResourceState<T> {
  final T data;
  const ResourceSuccess(this.data);
}

class ResourceEmpty<T> extends ResourceState<T> {
  const ResourceEmpty();
}

class ResourceError<T> extends ResourceState<T> {
  final String message;
  const ResourceError(this.message);
}
