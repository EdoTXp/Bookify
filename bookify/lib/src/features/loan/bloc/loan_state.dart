part of 'loan_bloc.dart';

sealed class LoanState {}

final class LoanLoadingState extends LoanState {}

final class LoanLoadedState extends LoanState {
  final List<LoanDto> loansDto;

  LoanLoadedState({required this.loansDto});
}

final class LoanEmptyState extends LoanState {}

final class LoanErrorState extends LoanState {
  final String errorMessage;

  LoanErrorState({required this.errorMessage});
}
