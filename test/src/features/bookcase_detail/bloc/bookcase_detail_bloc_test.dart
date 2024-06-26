import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/bookcase_detail/bloc/bookcase_detail_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class BookcaseServiceMock extends Mock implements BookcaseService {}

void main() {
  final bookService = BookServiceMock();
  final bookcaseService = BookcaseServiceMock();
  late BookcaseDetailBloc bloc;

  final bookModel = BookModel(
    id: 'id',
    title: 'title',
    authors: [AuthorModel.withEmptyName()],
    publisher: 'publisher',
    description: 'description',
    categories: [CategoryModel.withEmptyName()],
    pageCount: 320,
    imageUrl: 'imageUrl',
    buyLink: 'buyLink',
    averageRating: 4.5,
    ratingsCount: 720,
  );

  setUp(() {
    bloc = BookcaseDetailBloc(
      bookService,
      bookcaseService,
    );
  });

  group('Test bookcaseDetail bloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'test if GotAllBookcaseBooksEvent work',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenAnswer((_) async => bookModel);

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotBookcaseBooksEvent(bookcaseId: 1)),
      verify: (bloc) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookcaseDetailLoadingState>(),
        isA<BookcaseDetailBooksLoadedState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseBooksEvent work with empty relationship',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenAnswer((_) async => bookModel);

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [],
        );
      },
      act: (bloc) => bloc.add(GotBookcaseBooksEvent(bookcaseId: 1)),
      verify: (_) {
        verifyNever(() => bookService.getBookById(id: 'id'));
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookcaseDetailLoadingState>(),
        isA<BookcaseDetailBooksEmptyState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseBooksEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenThrow(const LocalDatabaseException('Error on database'));

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotBookcaseBooksEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookcaseDetailLoadingState>(),
        isA<BookcaseDetailErrorState>(),
      ],
    );

    blocTest(
      'test if GotAllBookcaseBooksEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenThrow(Exception('Generic Error'));

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotBookcaseBooksEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookcaseDetailLoadingState>(),
        isA<BookcaseDetailErrorState>(),
      ],
    );
  });

  blocTest(
    'test if DeletedBookcaseEvent work',
    build: () => bloc,
    setUp: () => when(() => bookcaseService.deleteBookcase(
        bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => 1),
    act: (bloc) => bloc.add(DeletedBookcaseEvent(bookcaseId: 1)),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcase(bookcaseId: 1)).called(1);
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailDeletedState>(),
    ],
  );

  blocTest(
    'test if DeletedBookcaseEvent work with deleted is -1',
    build: () => bloc,
    setUp: () => when(() => bookcaseService.deleteBookcase(
        bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => -1),
    act: (bloc) => bloc.add(DeletedBookcaseEvent(bookcaseId: 1)),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcase(bookcaseId: 1)).called(1);
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );

  blocTest(
    'test if DeletedBookcaseEvent work when throw LocalDatabaseException',
    build: () => bloc,
    setUp: () => when(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId')))
        .thenThrow(const LocalDatabaseException('Error on database')),
    act: (bloc) => bloc.add(DeletedBookcaseEvent(bookcaseId: 1)),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcase(bookcaseId: 1)).called(1);
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );

  blocTest(
    'test if DeletedBookcaseEvent work when throw Generic Exception',
    build: () => bloc,
    setUp: () => when(() => bookcaseService.deleteBookcase(
            bookcaseId: any(named: 'bookcaseId')))
        .thenThrow(Exception('Generic Error')),
    act: (bloc) => bloc.add(DeletedBookcaseEvent(bookcaseId: 1)),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcase(bookcaseId: 1)).called(1);
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );

  blocTest(
    'test if DeletedBooksOnBookcaseEvent work',
    build: () => bloc,
    setUp: () {
      when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => 1);
      when(
        () => bookService.getBookById(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookModel);
      when(() => bookcaseService.getAllBookcaseRelationships(
          bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
        (_) async => [
          {'bookcaseId': 1, 'bookId': 'id'},
        ],
      );
    },
    act: (bloc) => bloc.add(
      DeletedBooksOnBookcaseEvent(
        bookcaseId: 1,
        books: [bookModel],
      ),
    ),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'))).called(1);
      verify(() => bookService.getBookById(id: 'id')).called(1);
      verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
          .called(1);
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailBooksLoadedState>(),
    ],
  );

  blocTest(
    'test if DeletedBooksOnBookcaseEvent work when error on delete books',
    build: () => bloc,
    setUp: () {
      when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => -1);
      when(
        () => bookService.getBookById(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookModel);
      when(() => bookcaseService.getAllBookcaseRelationships(
          bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
        (_) async => [
          {'bookcaseId': 1, 'bookId': 'id'},
        ],
      );
    },
    act: (bloc) => bloc.add(
      DeletedBooksOnBookcaseEvent(
        bookcaseId: 1,
        books: [bookModel],
      ),
    ),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'))).called(1);
      verifyNever(() => bookService.getBookById(id: 'id'));
      verifyNever(
          () => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1));
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );

  blocTest(
    'test if DeletedBooksOnBookcaseEvent work when empty relationship',
    build: () => bloc,
    setUp: () {
      when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => 1);
      when(
        () => bookService.getBookById(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookModel);
      when(() => bookcaseService.getAllBookcaseRelationships(
          bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
        (_) async => [],
      );
    },
    act: (bloc) => bloc.add(
      DeletedBooksOnBookcaseEvent(
        bookcaseId: 1,
        books: [bookModel],
      ),
    ),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'))).called(1);
      verifyNever(() => bookService.getBookById(id: 'id'));
      verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1));
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailBooksEmptyState>(),
    ],
  );

  blocTest(
    'test if DeletedBooksOnBookcaseEvent work when throw LocalDatabaseException',
    build: () => bloc,
    setUp: () {
      when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => 1);
      when(
        () => bookService.getBookById(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookModel);
      when(() => bookcaseService.getAllBookcaseRelationships(
              bookcaseId: any(named: 'bookcaseId')))
          .thenThrow(const LocalDatabaseException('Error on Database'));
    },
    act: (bloc) => bloc.add(
      DeletedBooksOnBookcaseEvent(
        bookcaseId: 1,
        books: [bookModel],
      ),
    ),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'))).called(1);
      verifyNever(() => bookService.getBookById(id: 'id'));
      verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1));
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );

  blocTest(
    'test if DeletedBooksOnBookcaseEvent work when throw Generic Exception',
    build: () => bloc,
    setUp: () {
      when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => 1);
      when(
        () => bookService.getBookById(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookModel);
      when(() => bookcaseService.getAllBookcaseRelationships(
              bookcaseId: any(named: 'bookcaseId')))
          .thenThrow(Exception('Generic Exception'));
    },
    act: (bloc) => bloc.add(
      DeletedBooksOnBookcaseEvent(
        bookcaseId: 1,
        books: [bookModel],
      ),
    ),
    verify: (_) {
      verify(() => bookcaseService.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'))).called(1);
      verifyNever(() => bookService.getBookById(id: 'id'));
      verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1));
    },
    expect: () => [
      isA<BookcaseDetailLoadingState>(),
      isA<BookcaseDetailErrorState>(),
    ],
  );
}
