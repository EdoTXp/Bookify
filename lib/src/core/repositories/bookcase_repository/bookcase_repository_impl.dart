import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/repositories/bookcase_repository/bookcase_repository.dart';

class BookcaseRepositoryImpl implements BookcaseRepository {
  final LocalDatabase _database;
  final _bookcaseTableName = DatabaseScripts().bookcaseTableName;

  BookcaseRepositoryImpl(this._database);

  @override
  Future<List<BookcaseModel>> getAll() async {
    try {
      final bookcasesMap = await _database.getAll(table: _bookcaseTableName);
      final bookcases = bookcasesMap.map(BookcaseModel.fromMap).toList();

      return bookcases;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar as estantes no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<BookcaseModel>> getBookcasesByName({required String name}) async {
    try {
      final bookcasesMap = await _database.researchBy(
        table: _bookcaseTableName,
        column: 'name',
        columnValues: name,
      );
      final bookcases = bookcasesMap.map(BookcaseModel.fromMap).toList();

      return bookcases;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar as estantes no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<BookcaseModel> getById({required int bookcaseId}) async {
    try {
      final bookcaseMap = await _database.getItemById(
        table: _bookcaseTableName,
        idColumn: 'id',
        id: bookcaseId,
      );
      final bookcase = BookcaseModel.fromMap(bookcaseMap);

      return bookcase;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar a estante no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countBookcases() async {
    try {
      final bookcasesCount = await _database.countItems(
        table: _bookcaseTableName,
      );

      return bookcasesCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required BookcaseModel bookcaseModel}) async {
    try {
      final bookcaseId = await _database.insert(
        table: _bookcaseTableName,
        values: bookcaseModel.toMap(),
      );

      return bookcaseId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> update({required BookcaseModel bookcaseModel}) async {
    try {
      final rowUpdated = _database.update(
        table: _bookcaseTableName,
        values: bookcaseModel.toMap(),
        idColumn: 'id',
        id: bookcaseModel.id,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int bookcaseId}) async {
    try {
      final deleteRow = await _database.delete(
        table: _bookcaseTableName,
        idColumn: 'id',
        id: bookcaseId,
      );

      return deleteRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
