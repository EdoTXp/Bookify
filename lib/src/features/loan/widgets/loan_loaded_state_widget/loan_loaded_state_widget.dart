import 'package:bookify/src/features/loan/widgets/loan_widget/loan_widget.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/widgets/buttons/add_new_item_text_button.dart';
import 'package:flutter/material.dart';

class LoanLoadedStateWidget extends StatelessWidget {
  final List<LoanDto> loansDto;
  final VoidCallback refreshPage;

  const LoanLoadedStateWidget({
    super.key,
    required this.loansDto,
    required this.refreshPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: AddNewItemTextButton(
            label: 'Adicionar um novo empréstimo',
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                LoanInsertionPage.routeName,
              );
              refreshPage();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: loansDto.length,
            itemBuilder: (_, index) {
              return LoanWidget(
                loan: loansDto[index],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}