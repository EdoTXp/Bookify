import 'package:bookify/src/core/models/book_model.dart';

abstract interface class GoogleBooksRepository {
  Future<List<BookModel>> getAllBooks();

  Future<List<BookModel>> findBooksByAuthor({required String author});

  Future<List<BookModel>> findBooksByPublisher({required String publisher});

  Future<List<BookModel>> findBooksByCategory({required String category});

  Future<List<BookModel>> findBooksByTitle({required String title});

  Future<List<BookModel>> findBooksByIsbn({required String isbn});
}
