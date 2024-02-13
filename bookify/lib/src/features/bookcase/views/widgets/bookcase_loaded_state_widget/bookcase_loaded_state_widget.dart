import 'package:bookify/src/features/bookcase/views/widgets/widgets.dart';
import 'package:bookify/src/features/bookcase_detail/views/bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:bookify/src/shared/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:flutter/material.dart';

class BookcaseLoadedStateWidget extends StatefulWidget {
  final List<BookcaseDto> bookcasesDto;
  final VoidCallback onRefresh;
  final void Function(List<BookcaseDto> selectedBookcase) onPressedDeleteButton;

  const BookcaseLoadedStateWidget({
    super.key,
    required this.bookcasesDto,
    required this.onRefresh,
    required this.onPressedDeleteButton,
  });

  @override
  State<BookcaseLoadedStateWidget> createState() =>
      _BookcaseLoadedStateWidgetState();
}

class _BookcaseLoadedStateWidgetState extends State<BookcaseLoadedStateWidget> {
  bool _isSelectionMode = false;
  late final List<BookcaseDto> _selectedList;

  @override
  void initState() {
    super.initState();
    _selectedList = [];
  }

  Future<void> _normalOnTap(BuildContext context, bookcase) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookcaseDetailPage(
          bookcaseModel: bookcase,
        ),
      ),
    );
    widget.onRefresh();
  }

  void _onTap({required BuildContext context, required BookcaseDto element}) {
    if (_isSelectionMode) {
      setState(() {
        if (!_selectedList.contains(element)) {
          _selectedList.add(element);
        } else {
          _selectedList.remove(element);
        }

        _setIsSelectedMode();
      });
    } else {
      _normalOnTap(context, element.bookcase);
    }
  }

  void _onLongPress({required BookcaseDto element}) {
    setState(() {
      if (!_selectedList.contains(element)) {
        _selectedList.add(element);
      } else {
        _selectedList.remove(element);
      }

      _setIsSelectedMode();
    });
  }

  void _setIsSelectedMode() {
    _isSelectionMode = _selectedList.isNotEmpty;
  }

  void _selectAllItems(List<BookcaseDto> bookcasesDto) {
    setState(() {
      _selectedList.replaceRange(
        0,
        _selectedList.length,
        bookcasesDto,
      );
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedList.clear();
      _setIsSelectedMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookcasesDto = widget.bookcasesDto;

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      color: colorScheme.secondary,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: (_isSelectionMode)
                ? SelectedBookcaseRow(
                    bookcaseQuantity: _selectedList.length,
                    onSelectedAll: (isSelected) => (isSelected)
                        ? _selectAllItems(bookcasesDto)
                        : _clearSelection(),
                    onPressedDeleteButton: () {
                      ShowDialogService.show(
                        context: context,
                        title: 'Deletar estantes',
                        content:
                            'Clicando em "CONFIRMAR" você removerá as estantes.\nTem Certeza?',
                        cancelButtonFunction: () => Navigator.of(context).pop(),
                        confirmButtonFunction: () {
                          Navigator.of(context).pop();
                          widget.onPressedDeleteButton(_selectedList);
                        },
                      );
                    },
                  )
                : TextButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const BookcaseInsertionPage()),
                      );
                      widget.onRefresh();
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: colorScheme.secondary,
                    ),
                    label: const Text(
                      'Adicionar uma nova estante',
                    ),
                  ),
          ),
          Expanded(
            child: GestureDetector(
              // Verify that the list is selected before deselecting it if click outside the BookcaseWidget.
              onTap: () => _selectedList.isNotEmpty ? _clearSelection() : null,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 5.0,
                ),
                itemCount: bookcasesDto.length,
                itemBuilder: (_, index) {
                  return (_selectedList.contains(bookcasesDto[index]))
                      ? Container(
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withOpacity(.2),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BookcaseWidget(
                            bookcaseDto: bookcasesDto[index],
                            onTap: () => _onTap(
                              context: context,
                              element: bookcasesDto[index],
                            ),
                            onLongPress: () => _onLongPress(
                              element: bookcasesDto[index],
                            ),
                          ),
                        )
                      : BookcaseWidget(
                          bookcaseDto: bookcasesDto[index],
                          onTap: () => _onTap(
                            context: context,
                            element: bookcasesDto[index],
                          ),
                          onLongPress: () => _onLongPress(
                            element: bookcasesDto[index],
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}