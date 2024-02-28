String getServerBaseUrl() {
  return const String.fromEnvironment("SERVER_BASE_URL",
      defaultValue: "http://10.0.2.2:8000");
}