import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/repositories/loan_repository/loan_repository.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service.dart';

class LoanServiceImpl implements LoanService {
  final LoanRepository _loanRepository;

  LoanServiceImpl(this._loanRepository);

  @override
  Future<List<LoanModel>> getAll() async {
    try {
      final loansModel = await _loanRepository.getAll();
      return loansModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<LoanModel> getById({required int loanId}) async {
    try {
      final loanModel = await _loanRepository.getById(loanId: loanId);
      return loanModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required LoanModel loanModel}) async {
    try {
      final newLoanId = _loanRepository.insert(loanModel: loanModel);
      return newLoanId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> update({required LoanModel loanModel}) async {
    try {
      final rowUpdated = await _loanRepository.update(
        loanModel: loanModel,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int loanModelId}) async {
    try {
      final rowDeleted = await _loanRepository.delete(
        loanModelId: loanModelId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
