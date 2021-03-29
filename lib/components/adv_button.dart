import 'package:basic_components/helper/theme_helper.dart';
import 'package:flutter/material.dart';

import '../basic_components.dart';

enum ButtonSize { small, large }

class AdvButton extends StatelessWidget {
  final Widget child;
  final bool enable;
  final VoidCallback onPressed;
  final double circular;
  final ButtonSize buttonSize;
  final bool onlyBorder;
  final bool reverse;
  final Color primaryColor;
  final Color accentColor;
  final double width;
  final EdgeInsets padding;

  AdvButton._(
      {this.child,
      double circular = 5.0,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      this.onPressed,
      ButtonSize buttonSize,
      Color primaryColor,
      Color accentColor,
      this.width,
      EdgeInsets padding})
      : this.buttonSize = buttonSize ?? ButtonSize.large,
        this.enable = enable ?? true,
        this.circular = circular ?? 5.0,
        this.onlyBorder = onlyBorder ?? false,
        this.reverse = reverse ?? false,
        this.primaryColor = !reverse
            ? primaryColor ?? BasicComponents.button.backgroundColor
            : accentColor ?? BasicComponents.button.textColor,
        this.accentColor = !reverse
            ? accentColor ?? BasicComponents.button.textColor
            : primaryColor ?? BasicComponents.button.backgroundColor,
        this.padding = padding;

  factory AdvButton.text(String text,
      {double circular = 5.0,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      bool bold = false,
      VoidCallback onPressed,
      ButtonSize buttonSize,
      Color backgroundColor,
      Color textColor,
      double width,
      EdgeInsets padding}) {
    Color primaryColor = !reverse
        ? backgroundColor ?? BasicComponents.button.backgroundColor
        : textColor ?? BasicComponents.button.textColor;
    Color accentColor = !reverse
        ? textColor ?? BasicComponents.button.textColor
        : backgroundColor ?? BasicComponents.button.backgroundColor;
    double fontSize = buttonSize == ButtonSize.large ? 16.0 : 12.0;
    FontWeight fontWeight = buttonSize == ButtonSize.large
        ? bold
            ? FontWeight.w700
            : FontWeight.w600
        : FontWeight.normal;
    Color disableTextColor =
        Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color _textColor = !onlyBorder ? accentColor : primaryColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;
    TextStyle textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: enable ? _textColor : _disableTextColor);

    return AdvButton._(
      child: Text(text, style: textStyle),
      circular: circular,
      enable: enable,
      onlyBorder: onlyBorder,
      reverse: reverse,
      onPressed: onPressed,
      buttonSize: buttonSize,
      primaryColor: primaryColor,
      accentColor: accentColor,
      width: width,
      padding: padding,
    );
  }

  factory AdvButton.custom(
      {@required Widget child,
      double circular = 5.0,
      bool enable = true,
      bool onlyBorder = false,
      bool reverse = false,
      bool bold = false,
      VoidCallback onPressed,
      ButtonSize buttonSize,
      Color primaryColor,
      Color accentColor,
      double width,
      EdgeInsets padding}) {
    return AdvButton._(
      child: child,
      circular: circular,
      enable: enable,
      onlyBorder: onlyBorder,
      reverse: reverse,
      onPressed: onPressed,
      buttonSize: buttonSize,
      primaryColor: primaryColor,
      accentColor: accentColor,
      width: width,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildButton(context);
  }

  _defaultCallback() {}

  Widget _buildButton(BuildContext context) {
    double borderWidth = onlyBorder ? 1.0 : 0.0;
    Color disableBackgroundColor =
        Color.lerp(reverse ? Colors.white : Colors.black54, lerpColor, 0.6);
    Color disableTextColor =
        Color.lerp(!reverse ? Colors.white : Colors.black54, lerpColor, 0.6);

    ShapeBorder border = RoundedRectangleBorder(
        side: BorderSide(
            color: enable ? primaryColor : disableBackgroundColor,
            width: borderWidth),
        borderRadius: new BorderRadius.circular(this.circular));

    Color _color = onlyBorder ? accentColor : primaryColor;
    Color _disableColor =
        onlyBorder ? disableTextColor : disableBackgroundColor;
    Color _disableTextColor =
        !onlyBorder ? disableTextColor : disableBackgroundColor;

    EdgeInsets finalPadding = this.padding ??
        (this.buttonSize == ButtonSize.large
            ? EdgeInsets.all(14.0)
            : EdgeInsets.all(8.0));

    return ButtonTheme(
        minWidth: 0.0,
        height: 0.0,
        child: Container(
            width: width,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(finalPadding),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed))
                    return Theme.of(context).dividerColor;
                  return null;
                }),
                foregroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled))
                    return _disableTextColor;
                  return null;
                }),
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled))
                    return _disableColor;
                  return _color;
                }),
                shape: MaterialStateProperty.all(border)
              ),
              child: this.child,
              onPressed: enable
                  ? () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (this.onPressed != null) this.onPressed();
                    }
                  : null,
            )));
  }
}
