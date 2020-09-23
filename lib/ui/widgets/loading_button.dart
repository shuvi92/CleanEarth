import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final bool isLoading;
  final String title;
  final Function onPressed;
  final bool enabled;

  const LoadingButton({
    Key key,
    this.isLoading = false,
    @required this.title,
    @required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: InkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: widget.isLoading ? 10 : 15,
              vertical: widget.isLoading ? 10 : 10),
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.blue[800] : Colors.blue[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: !widget.isLoading
              ? Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                )
              : CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
        ),
      ),
    );
  }
}
