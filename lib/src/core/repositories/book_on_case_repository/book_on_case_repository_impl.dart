import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/repositories/book_on_case_repository/book_on_case_repository.dart';

class BookOnCaseRepositoryImpl implements BookOnCaseRepository {
  final LocalDatabase _database;
  final _bookOnCaseTableName = DatabaseScripts().bookOnCaseTableName;

  BookOnCaseRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getBooksOnCaseRelationship({
    required int bookcaseId,
  }) async {
    try {
      final bookOnCaseRelationships = await _database.getItemsByColumn(
        table: _bookOnCaseTableName,
        column: 'bookcaseId',
        columnValues: bookcaseId,
      );

      return bookOnCaseRelationships;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<String?> getBookIdForImagePreview({required int bookcaseId}) async {
    try {
      final bookRelationshipMap = await _database.getColumnsById(
        table: _bookOnCaseTableName,
        columns: ['bookId'],
        idColumn: 'bookcaseId',
        id: bookcaseId,
      );

      final bookId = bookRelationshipMap['bookId'] as String?;
      return bookId;
    } on TypeError {
      throw const LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required int bookcaseId, required String bookId}) async {
    try {
      final rowInserted =
          await _database.insert(table: _bookOnCaseTableName, values: {
        'bookId': bookId,
        'bookcaseId': bookcaseId,
      });

      return rowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countBookcasesByBook({required String bookId}) async {
    try {
      final bookcasesCount = await _database.countItemsById(
        table: _bookOnCaseTableName,
        idColumn: 'bookId',
        id: bookId,
      );

      return bookcasesCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteBookcaseRelationship({
    required int bookcaseId,
    required String bookId,
  }) async {
    try {
      final rowDeleted = await _database.deleteWithAnotherColumn(
        table: _bookOnCaseTableName,
        otherColumn: 'bookId',
        value: bookId,
        idColumn: 'bookcaseId',
        id: bookcaseId,
      );
      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
