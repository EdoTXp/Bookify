import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final bookCategoriesRepository = BookCategoriesRepositoryImpl(localDatabase);
  group('Test normal CRUD of book/categories without error ||', () {
    test('insert book/categories relationship', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final bookAuthorsRelationship = await bookCategoriesRepository.insert(
        bookId: '1',
        categoryId: 1,
      );

      expect(bookAuthorsRelationship, equals(1));
    });

    test('get book/categories relationship', () async {
      when(() =>
              localDatabase.getByColumn(
                  table: any(named: 'table'),
                  column: any(named: 'column'),
                  columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [
                {'bookId': '1', 'categoryId': 1},
              ]);

      final bookAuthorsRelationshipMap =
          await bookCategoriesRepository.getRelationshipsById(bookId: '1');

      expect(bookAuthorsRelationshipMap.last['bookId'], equals('1'));
      expect(bookAuthorsRelationshipMap.last['categoryId'], equals(1));
    });

    test('delete book/categories relationship', () async {
      when(() => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => 1);

      final deletedRelationshipRow =
          await bookCategoriesRepository.delete(bookId: '1');

      expect(deletedRelationshipRow, equals(1));
    });
  });
}
