import 'package:flutter/material.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final String Function(T?) getDisplayText;
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
  SearchableDropdownState<T> createState() => SearchableDropdownState<T>();
}

class SearchableDropdownState<T> extends State<CustomSearchDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  List<T> _filteredItems = [];
  bool _disposed = false; // เพิ่มตัวแปรเช็คสถานะ dispose

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(CustomSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // ตรวจสอบว่า widget ยังไม่ถูก dispose
    if (_disposed) return;
    
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

  void _toggleDropdown() {
    if (_disposed) return; // เช็คก่อนดำเนินการ
    
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_disposed) return; // เช็คก่อนดำเนินการ
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    
    if (mounted) { // เช็ค mounted ก่อน setState
      setState(() {
        _isOpen = true;
      });
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    
    if (mounted && !_disposed) { // เช็ค mounted และ disposed ก่อน setState
      setState(() {
        _isOpen = false;
      });
    }
    
    _searchController.clear();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    if (_disposed || !mounted) return; // เช็คก่อนดำเนินการ
    
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.getDisplayText(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  @override
  void dispose() {
    _disposed = true; // ตั้งค่าสถานะ dispose
    _closeDropdown(); // ปิด dropdown ก่อน
    _searchController.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double screenWidth = Responsive.width;

    double dropdownWidth = widget.width ?? renderBox.size.width;
    double leftPosition = offset.dx;

    // ปรับตำแหน่ง dropdown หากเกินขอบจอ
    if (leftPosition + dropdownWidth > screenWidth) {
      leftPosition = screenWidth - dropdownWidth -16;
      if (leftPosition < 0) leftPosition = 0; // ล้นขอบไปด้านซ้าย
    }

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Layer ด้านหลัง dropdown เอาไว้ปิด dropdown List
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!_disposed) _closeDropdown();
              },
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
          ),

          Positioned(
            left: leftPosition,
            top: offset.dy + renderBox.size.height,
            width: dropdownWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: widget.width ?? (MediaQuery.of(context).size.width - 32),
                  constraints: BoxConstraints(maxHeight: widget.menuHeight ?? 200),
                  decoration: BoxDecoration(color: widget.backgroundColor ?? Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: widget.textColor ?? Colors.black),
                          decoration: InputDecoration(
                            hintText: 'ค้นหา...',
                            hintStyle: TextStyle(color: widget.textColor?.withValues(alpha: 0.6) ?? Colors.grey, fontSize: 16),
                            prefixIcon: Icon(Icons.search, color: widget.textColor ?? Colors.grey),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.textColor?.withValues(alpha: 0.3) ?? Colors.grey)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.textColor?.withValues(alpha: 0.3) ?? Colors.grey)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.textColor ?? Colors.blue)),
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
                            final isSelected = widget.selectedItem != null && widget.getValue(item) == widget.getValue(widget.selectedItem as T);
                            
                            return ListTile(
                              title: Text(widget.getDisplayText(item), style: TextStyle(color: widget.textColor ?? Colors.black, fontSize: Responsive.isTablet ? 18 : 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                              selected: isSelected,
                              selectedTileColor: widget.textColor?.withValues(alpha: 0.1),
                              onTap: () {
                                if (!_disposed) {
                                  widget.onChanged?.call(item);
                                  _closeDropdown();
                                }
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (widget.labelText != null)
          Text(widget.labelText!, style: widget.labelStyle),
        const SizedBox(height: 4),
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
                    child: Text(widget.selectedItem != null? widget.getDisplayText(widget.selectedItem) : widget.hintText, style: widget.textStyle ?? TextStyle(color: widget.selectedItem != null? (widget.textColor ?? Colors.black) : (widget.textColor?.withValues(alpha: 0.6) ?? Colors.grey[600])), overflow: TextOverflow.ellipsis)
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