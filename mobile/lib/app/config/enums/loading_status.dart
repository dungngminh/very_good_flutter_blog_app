enum LoadingStatus {
  loading,
  done,
  error;

  bool get isLoading => this == LoadingStatus.loading;

  bool get isDone => this == LoadingStatus.done;

  bool get isError => this == LoadingStatus.error;
}
