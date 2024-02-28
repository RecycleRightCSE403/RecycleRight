String getServerBaseUrl() {
  // return "http://10.0.2.2:8000:";
  // return "http://192.168.0.102:8000";
  return const String.fromEnvironment("SERVER_BASE_URL");
}