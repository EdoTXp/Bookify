import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/repositories/book_authors_repository/book_authors_repository.dart';

class BookAuthorsRepositoryImpl implements BookAuthorsRepository {
  final LocalDatabase _database;
  final _bookAuthorsTableName = DatabaseScripts().bookAuthorsTableName;

  BookAuthorsRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getRelationshipsById({
    required String bookId,
  }) async {
    try {
      final bookAuthorsRelationships = await _database.getItemsByColumn(
        table: _bookAuthorsTableName,
        column: 'bookId',
        columnValues: bookId,
      );

      if (bookAuthorsRelationships.last.isEmpty) {
        throw const LocalDatabaseException('Impossível buscar os dados');
      }

      return bookAuthorsRelationships;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required String bookId, required int authorId}) async {
    try {
      final rowInserted =
          await _database.insert(table: _bookAuthorsTableName, values: {
        'bookId': bookId,
        'authorId': authorId,
      });

      return rowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required String bookId}) async {
    try {
      final rowDeleted = await _database.delete(
        table: _bookAuthorsTableName,
        idColumn: 'bookId',
        id: bookId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
