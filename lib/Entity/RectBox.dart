import 'package:flame/components.dart';

class RectBox extends ShapeComponent {
  // late double top, bottom, left, right;

  double get top => position.y;
  double get bottom => position.y + size.y;
  double get left => position.x;
  double get right => position.x + size.x;

  RectBox({super.position, super.size});

  bool isCollide(RectBox rect) {
    return (top < rect.bottom &&
        bottom > rect.top &&
        left < rect.right &&
        right > rect.left
    );
  }
}