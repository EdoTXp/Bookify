import 'package:bookify/src/core/dtos/contact_dto.dart';
import 'package:bookify/src/core/models/loan_model.dart';

class LoanDto {
  final LoanModel loanModel;
  final ContactDto? contactDto;
  final String bookImagePreview;
  final String bookTitlePreview;

  const LoanDto({
    required this.loanModel,
    this.contactDto,
    required this.bookImagePreview,
    required this.bookTitlePreview,
  });

  bool get loanIsLate => _isLateDevolutionDate();

  LoanDto copyWith({
    LoanModel? loanModel,
    ContactDto? contactDto,
    String? bookImagePreview,
    String? bookTitlePreview,
  }) {
    return LoanDto(
      loanModel: loanModel ?? this.loanModel,
      contactDto: contactDto ?? this.contactDto,
      bookImagePreview: bookImagePreview ?? this.bookImagePreview,
      bookTitlePreview: bookTitlePreview ?? this.bookTitlePreview,
    );
  }

  @override
  String toString() {
    return 'LoanDto(loanModel: $loanModel, bookImagePreview: $bookImagePreview, bookTitlePreview: $bookTitlePreview, contactDto: $contactDto)';
  }

  @override
  bool operator ==(covariant LoanDto other) {
    if (identical(this, other)) return true;

    return other.loanModel == loanModel &&
        other.bookImagePreview == bookImagePreview &&
        other.bookTitlePreview == bookTitlePreview &&
        other.contactDto == contactDto;
  }

  @override
  int get hashCode {
    return loanModel.hashCode ^
        bookImagePreview.hashCode ^
        bookTitlePreview.hashCode ^
        contactDto.hashCode;
  }

  bool _isLateDevolutionDate() {
    final loanDateLate = loanModel.devolutionDate.add(
      const Duration(
        days: 1,
      ),
    );

    return DateTime.now().isAfter(loanDateLate);
  }
}
