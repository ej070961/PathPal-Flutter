import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';

class CustomDropDown extends StatefulWidget {
   final void Function(String?) onValueChanged;

    const CustomDropDown({Key? key, required this.onValueChanged}): super(key: key);

    @override
    State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final List<String> _types = ['지체장애','시각장애', '청각장애', '뇌병변장애', '뇌전증장애', '지적장애', '기타'];

  OverlayEntry? _overlayEntry; // The entry for the overlay
  bool isDropdownOpened = false;
  String? selectedValue;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isDropdownOpened = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
      isDropdownOpened = false;
    });
  }

  void _selectValue(String value) {
    setState(() {
      selectedValue = value;
      _closeDropdown();
      widget.onValueChanged(selectedValue); // 부모 위젯에 선택된 값 전달
  
    });
  }

  OverlayEntry _createOverlayEntry() {

    return OverlayEntry(
      builder: (context) {

      return Positioned(
          bottom: 0.0, // 화면 하단에 위치
          left: 0.0, 
          width: MediaQuery.of(context).size.width, // 화면 전체 너비
          child: Material(
            elevation: 4.0,
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),         
            shadowColor: gray400,   
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _types
                  .map((String value) => Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 40.0, 
                          child: ListTile(
                            title: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              _selectValue(value);
                            },
                          ),
                        ),
                      Divider(
                        color: gray200,
                        thickness: 0.5,
                      ),
                    ],
                  ))
                  .toList(),
              ),
            ),
          );
      // ),
      }
    );
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: isDropdownOpened ? _closeDropdown : _openDropdown,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: gray200),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedValue ?? '장애 유형을 선택해주세요',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Icon(
                      isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 18,
                      color: gray200
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }

}