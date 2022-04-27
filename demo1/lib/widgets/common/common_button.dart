import 'package:flutter/material.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';

class CommonButton extends StatefulWidget {
  final double? width;
  final double? height;
  final Function? onPressed;
  final String? title;
  final IconData? icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;

  const CommonButton({
    Key? key,
    this.width,
    this.height,
    @required this.onPressed,
    @required this.title,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    EdgeInsetsGeometry edgeInsects = const EdgeInsets.all(15);
    if (widget.width == null || widget.height == null) {
      edgeInsects = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
    return GestureDetector(
      onTap: () => widget.onPressed!(),
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: edgeInsects,
        decoration: Constant.gradientDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(alignment: Alignment.center, child: _buildTitle(_theme)),
              Align(
                  alignment: Alignment.centerRight, child: _buildIcon(_theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      widget.title!,
      style: Singleton.instance.setTextStyle(
        fontWeight: FontWeight.w700,
        fontSize: TextSize.text_16,
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (widget.icon != null) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 0.0,
        ),
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: Colors.white,
        ),
      );
    }
    return const SizedBox();
  }
}
