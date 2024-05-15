import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';

class Ilustration3Page extends StatelessWidget {
  const Ilustration3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Column(
      children: [
        Image.asset(
          height: mediaQuerySizeOf.height * .4,
          width: mediaQuerySizeOf.width,
          BookifyImages.ilustration_3,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Gerencie os seus livros emprestados ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 32,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Empreste seus livros com segurança criando o contato, data para devolução e receba lembretes sobre o empréstimo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}