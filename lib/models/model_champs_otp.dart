import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModelChampsOtp extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? fieldWidth;
  final double? fieldHeight;
  final Color? fieldBackgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final bool obscureText;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final bool showCursor;
  final bool autofocus;
  final bool enabled;
  final bool? hasError;
  final String? errorMessage;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const ModelChampsOtp({
    Key? key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.width,
    this.fieldWidth = 50.0,
    this.fieldHeight = 50.0,
    this.fieldBackgroundColor,
    this.borderColor = Colors.grey,
    this.focusedBorderColor,
    this.errorBorderColor = Colors.red,
    this.textColor,
    this.obscureText = false,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.showCursor = true,
    this.autofocus = false,
    this.enabled = true,
    this.hasError,
    this.errorMessage,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<ModelChampsOtp> createState() => _ModelChampsOtpState();
}

class _ModelChampsOtpState extends State<ModelChampsOtp> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late String _pin;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _pin = '';

    // Ajouter les listeners pour chaque controller
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        _updatePin();
      });
    }
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updatePin() {
    _pin = _controllers.map((controller) => controller.text).join();
    widget.onChanged?.call(_pin);
    
    if (_pin.length == widget.length) {
      widget.onCompleted(_pin);
    }
  }

  void _onFocus(int index) {
    if (_controllers[index].text.isEmpty) {
      _controllers[index].selection = const TextSelection.collapsed(offset: 0);
    }
  }

  void _onChanged(String value, int index) {
    if (value.isEmpty) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length > 1) {
      _controllers[index].text = value[0];
      if (index < widget.length - 1) {
        if (value.length == 2) {
          _controllers[index + 1].text = value[1];
        }
        _focusNodes[index + 1].requestFocus();
      }
    } else if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.width,
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: List.generate(
              widget.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  curve: widget.animationCurve,
                  width: widget.fieldWidth,
                  height: widget.fieldHeight,
                  decoration: BoxDecoration(
                    color: widget.fieldBackgroundColor ?? 
                           Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                    border: Border.all(
                      color: _focusNodes[index].hasFocus
                          ? widget.focusedBorderColor ?? Theme.of(context).primaryColor
                          : widget.hasError == true
                              ? widget.errorBorderColor!
                              : widget.borderColor!,
                      width: _focusNodes[index].hasFocus ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: widget.textStyle ??
                          TextStyle(
                            color: widget.textColor ?? 
                                   Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      obscureText: widget.obscureText,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) => _onChanged(value, index),
                      onTap: () => _onFocus(index),
                      showCursor: widget.showCursor,
                      autofocus: widget.autofocus && index == 0,
                      enabled: widget.enabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.hasError == true && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                color: widget.errorBorderColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}