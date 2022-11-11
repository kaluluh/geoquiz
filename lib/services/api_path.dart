class APIPath {
  static String users(String uid) => 'users/$uid';
  static String stats(String uid) => 'stats/$uid';
  static String cities(String uid, String cityId) => 'cities/$cityId';
}