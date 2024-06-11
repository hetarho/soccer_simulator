abstract class UseCase<T, K> {
  T call(K k);
}

abstract class NoParamUseCase<T> {
  T call();
}


