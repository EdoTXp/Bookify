import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/repositories/book_authors_repository/book_authors_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final bookAuthorsRepository = BookAuthorsRepositoryImpl(localDatabase);

  group('Test normal CRUD book/authors without error ||', () {
    test('insert book/authors relationship', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final bookAuthorsRelationship = await bookAuthorsRepository.insert(
        bookId: '1',
        authorId: 1,
      );

      expect(bookAuthorsRelationship, equals(1));
    });

    test('get book/authors relationship', () async {
      when(() =>
              localDatabase.getItemsByColumn(
                  table: any(named: 'table'),
                  column: any(named: 'column'),
                  columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [
                {'bookId': '1', 'authorId': 1},
              ]);

      final bookAuthorsRelationshipMap =
          await bookAuthorsRepository.getRelationshipsById(bookId: '1');

      expect(bookAuthorsRelationshipMap.last['bookId'], equals('1'));
      expect(bookAuthorsRelationshipMap.last['authorId'], equals(1));
    });

    test('delete book/authors relationship', () async {
      when(() => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => 1);

      final deletedRelationshipRow =
          await bookAuthorsRepository.delete(bookId: '1');

      expect(deletedRelationshipRow, equals(1));
    });
  });

  group('Test normal CRUD book/authors with error ||', () {
    test('insert book/authors relationship', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookAuthorsRepository.insert(
          bookId: '1',
          authorId: 1,
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book/authors relationship', () async {
      when(() => localDatabase.getItemsByColumn(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [{}]);

      expect(
        () async =>
            await bookAuthorsRepository.getRelationshipsById(bookId: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível buscar os dados'),
      );
    });

    test('delete book/authors relationship', () async {
      when(() => localDatabase.delete(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookAuthorsRepository.delete(bookId: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
