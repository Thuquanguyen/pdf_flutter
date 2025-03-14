import 'package:booklibrary/core/app_functions.dart';
import 'package:flutter/widgets.dart';

class LazyWidget extends StatefulWidget {
  const LazyWidget({Key? key, required this.child, this.delay = 0}) : super(key: key);
  final Widget child;
  final int delay;

  @override
  _LazyWidgetState createState() => _LazyWidgetState();
}

class _LazyWidgetState extends State<LazyWidget> {

  bool load = false;

  @override
  void initState() {
    super.initState();
    if (widget.delay > 0) {
      AppFunc.setTimeout(() {
        setState(() {
          load = true;
        });
      }, widget.delay);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (load == true || widget.delay == 0) ? widget.child : const SizedBox(height: 0,);
  }
}
