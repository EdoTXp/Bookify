import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookcase_insertion_event.dart';
part 'bookcase_insertion_state.dart';

class BookcaseInsertionBloc
    extends Bloc<BookcaseInsertionEvent, BookcaseInsertionState> {
  final BookcaseService _bookcaseService;

  BookcaseInsertionBloc(
    this._bookcaseService,
  ) : super(BookcaseInsertionLoadingState()) {
    on<InsertedBookcaseEvent>(_insertedBookcaseEvent);
    on<UpdatedBookcaseEvent>(_updatedBookcaseEvent);
  }

  Future<void> _insertedBookcaseEvent(
    InsertedBookcaseEvent event,
    Emitter<BookcaseInsertionState> emit,
  ) async {
    try {
      emit(BookcaseInsertionLoadingState());

      final bookcaseModel = BookcaseModel(
        name: event.name,
        description: event.description,
        color: event.color,
      );

      final newBookcaseId =
          await _bookcaseService.insertBookcase(bookcaseModel: bookcaseModel);

      if (newBookcaseId == 0) {
        emit(BookcaseInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao inserir a estante'));
        return;
      }

      emit(BookcaseInsertionLoadedState(
          bookcaseInsertionMessage: 'Estante inserida com sucesso'));
    } on LocalDatabaseException catch (e) {
      emit(BookcaseInsertionErrorState(
          errorMessage: 'Ocorreu um erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcaseInsertionErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e'));
    }
  }

  Future<void> _updatedBookcaseEvent(
    UpdatedBookcaseEvent event,
    Emitter<BookcaseInsertionState> emit,
  ) async {
    try {
      emit(BookcaseInsertionLoadingState());

      final bookcaseModel = BookcaseModel(
        id: event.id,
        name: event.name,
        description: event.description,
        color: event.color,
      );

      final bookcaseRowUpdated =
          await _bookcaseService.updateBookcase(bookcaseModel: bookcaseModel);

      if (bookcaseRowUpdated != 1) {
        emit(
          BookcaseInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao atualizar a estante',
          ),
        );
        return;
      }

      emit(BookcaseInsertionLoadedState(
          bookcaseInsertionMessage: 'Estante atualizada com sucesso'));
    } on LocalDatabaseException catch (e) {
      emit(BookcaseInsertionErrorState(
          errorMessage: 'Ocorreu um erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcaseInsertionErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e'));
    }
  }
}
