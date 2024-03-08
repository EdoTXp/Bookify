import 'package:bookify/src/shared/providers/repositories/repositories_providers.dart';
import 'package:bookify/src/shared/providers/services/services_providers.dart';
import 'package:bookify/src/shared/providers/views/views_providers.dart';
import 'package:provider/single_child_widget.dart';

final providers = <SingleChildStatelessWidget>[
  ...repositoriesProviders,
  ...servicesProviders,
  ...homePageProviders,
  ...bookDetailPageProviders,
  ...bookcasePageProviders,
  ...bookcaseInsertionPageProviders,
  ...bookcaseDetailPageProviders,
  ...bookcaseBooksInsertionProviders,
  ...loanPageProviders,
  ...myBooksProviders,
];
