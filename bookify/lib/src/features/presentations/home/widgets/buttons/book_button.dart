import 'package:bookify/src/features/presentations/home/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BookButton extends StatelessWidget {
  final String bookImageUrl;
  final void Function() onTap;

  const BookButton({
    Key? key,
    required this.bookImageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO corregere il problema del click quando il widget non è visibile
    return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: BookWidget(bookImageUrl: bookImageUrl));
  }
}
