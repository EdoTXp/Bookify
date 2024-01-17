abstract interface class BookOnCaseRepository {
  Future<List<Map<String, dynamic>>> getBooksOnCaseRelationship(
      {required int bookcaseId});
  Future<int> insert({
    required int bookcaseId,
    required String bookId,
  });
  Future<String?> getBookIdForImagePreview({required int bookcaseId});
  Future<int> delete({required int bookcaseId});
}
