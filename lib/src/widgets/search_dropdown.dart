import 'package:flutter/material.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final String Function(T) getDisplayText;
  final String Function(T) getValue;
  final double? width;
  final double? menuHeight;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final String? labelText;

  const CustomSearchDropdown({
    super.key,
    required this.items,
    required this.getDisplayText,
    required this.getValue,
    this.selectedItem,
    this.onChanged,
    this.hintText = 'Select an item',
    this.width,
    this.menuHeight,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.labelStyle,
    this.labelText,
  });

  @override
  _SearchableDropdownState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<CustomSearchDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(CustomSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // อัปเดต filtered items เมื่อ items list เปลี่ยน
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
    }
    
    // ปิด dropdown เมื่อมีการเปลี่ยนแปลง selectedItem จากภายนอก
    if (oldWidget.selectedItem != widget.selectedItem && _isOpen) {
      _closeDropdown();
    }
    
    // Force rebuild เมื่อ selectedItem เปลี่ยน
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
    _searchController.clear();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.getDisplayText(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 55),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: widget.width ?? (MediaQuery.of(context).size.width - 32),
                constraints: BoxConstraints(
                  maxHeight: widget.menuHeight ?? 200,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: widget.textColor ?? Colors.black),
                        decoration: InputDecoration(
                          hintText: 'ค้นหา...',
                          hintStyle: TextStyle(color: widget.textColor?.withValues(alpha: 0.6) ?? Colors.grey),
                          prefixIcon: Icon(Icons.search, color: widget.textColor ?? Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.textColor?.withValues(alpha: 0.3) ?? Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.textColor?.withValues(alpha: 0.3) ?? Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.textColor ?? Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: _filterItems,
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final isSelected = widget.selectedItem != null && widget.getValue(item) == widget.getValue(widget.selectedItem!);
                          
                          return ListTile(
                            title: Text(
                              widget.getDisplayText(item),
                              style: TextStyle(
                                color: widget.textColor ?? Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedTileColor: widget.textColor?.withValues(alpha: 0.1),
                            onTap: () {
                              widget.onChanged?.call(item);
                              _closeDropdown();
                            },
                            dense: true,
                            hoverColor: widget.textColor?.withValues(alpha: 0.1),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(widget.labelText!, style: widget.labelStyle),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(color: widget.backgroundColor, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.selectedItem != null? widget.getDisplayText(widget.selectedItem!) : widget.hintText, style: widget.textStyle ?? TextStyle(color: widget.selectedItem != null? (widget.textColor ?? Colors.black) : (widget.textColor?.withValues(alpha: 0.6) ?? Colors.grey[600])), overflow: TextOverflow.ellipsis)
                  ),
                  Icon(_isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: widget.textColor ?? Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}