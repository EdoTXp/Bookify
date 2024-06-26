import 'package:bookify/src/core/models/book_model.dart';

abstract interface class BookService {
  Future<List<BookModel>> getAllBook();
  Future<BookModel> getBookById({required String id});
  Future<List<BookModel>> getBooksByTitle({required String title});
  Future<bool> verifyBookIsAlreadyInserted({required String id});
  Future<int> insertCompleteBook({required BookModel bookModel});
  Future<String> getBookImage({required String id});
  Future<BookStatus> getBookStatus({required String id});
  Future<int> countBooks();
  Future<int> updateStatus({required String id, required BookStatus status});
  Future<int> updatePageCount({required String id, required int pageCount});
  Future<int> deleteBook({required String id});
}
