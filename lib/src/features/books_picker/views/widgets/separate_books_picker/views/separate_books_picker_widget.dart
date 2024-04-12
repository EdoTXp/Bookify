import 'package:bookify/src/features/books_picker/views/widgets/book_selector_widget/book_selector_widget.dart';
import 'package:bookify/src/features/books_picker/views/widgets/separate_books_picker/bloc/separate_books_picker_bloc.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeparateBooksPickerWidget extends StatefulWidget {
  final void Function(BookModel bookModel) onSelectBookModel;

  const SeparateBooksPickerWidget({
    super.key,
    required this.onSelectBookModel,
  });

  @override
  State<SeparateBooksPickerWidget> createState() =>
      _SeparateBooksPickerWidgetState();
}

class _SeparateBooksPickerWidgetState extends State<SeparateBooksPickerWidget> {
  late final SeparateBooksPickerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<SeparateBooksPickerBloc>()
      ..add(
        GotAllSeparatedBooksPickerEvent(),
      );
  }

  void _refreshPage() {
    _bloc.add(GotAllSeparatedBooksPickerEvent());
  }

  Widget _getWidgetOnBookcasePickerState(
      BuildContext context, SeparateBooksPickerState state) {
    return switch (state) {
      SeparateBooksPickerLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      SeparateBooksPickerEmptyState() => const Center(
          child: Text(
            'Não possui nenhum livro que possa ser adicionado. Tente adicionar algum livro primeiro.',
            textAlign: TextAlign.center,
          ),
        ),
      SeparateBooksPickerLoadedState(:final books) => BookSelectorWidget(
          books: books,
          onSelectBook: (book) => Navigator.pop(context, book),
        ),
      SeparateBooksPickerErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeparateBooksPickerBloc, SeparateBooksPickerState>(
      bloc: _bloc,
      builder: _getWidgetOnBookcasePickerState,
    );
  }
}
