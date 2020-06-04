import 'package:flutter/material.dart';

class ScrollExpandContainer extends StatelessWidget {
  final List<Widget> children;

  const ScrollExpandContainer({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraint.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
