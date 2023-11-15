abstract interface class LocalDatabase {
  Future<Map<String, dynamic>> getById(
      {required String table, required dynamic id});

  Future<List<Map<String, dynamic>>> getAll({required String table});

  Future<int> insert(
      {required String table, required Map<String, dynamic> values});

  Future<int> update(
      {required String table, required Map<String, dynamic> values, required dynamic id});

  Future<int> delete(
      {required String table, required dynamic id});

}