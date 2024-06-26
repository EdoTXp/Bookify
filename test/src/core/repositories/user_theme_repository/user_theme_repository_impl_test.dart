import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository_impl.dart';
import 'package:bookify/src/core/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  final storage = StorageMock();
  final userThemeRepository = UserThemeRepositoryImpl(storage: storage);

  group('Test normal crud without error', () {
    test('Test get ThemeMode', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer((_) async => 1);

      final theme = await userThemeRepository.getThemeMode();

      expect(
        theme,
        equals(ThemeMode.light),
      );
    });

    test('Test set ThemeMode', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => 1);

      final themeInserted = await userThemeRepository.setThemeMode(
        themeMode: ThemeMode.light,
      );

      expect(
        themeInserted,
        equals(1),
      );
    });
  });

  group('Test normal crud with error', () {
    test('Test get ThemeMode with TypeError', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer((_) async => '1');

      expect(
        () async => await userThemeRepository.getThemeMode(),
        throwsA((Exception e) =>
            e is StorageException &&
            e.message == 'impossível converter o tema.'),
      );
    });

    test('Test get ThemeMode with Storage Exception', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await userThemeRepository.getThemeMode(),
        throwsA((Exception e) =>
            e is StorageException && e.message == 'Storage error'),
      );
    });

    test('Test set ThemeMode with Storage Exception', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await userThemeRepository.setThemeMode(
          themeMode: ThemeMode.light,
        ),
        throwsA((Exception e) =>
            e is StorageException && e.message == 'Storage error'),
      );
    });
  });
}
