import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/book_service/book_service_impl.dart';
import 'package:provider/provider.dart';

/// Provider that includes all services.
final servicesProviders = [
  Provider<BookService>(
    create: (context) => BookServiceImpl(
      booksRepository: context.read(),
      authorsRepository: context.read(),
      categoriesRepository: context.read(),
      bookAuthorsRepository: context.read(),
      bookCategoriesRepository: context.read(),
    ),
  ),
];