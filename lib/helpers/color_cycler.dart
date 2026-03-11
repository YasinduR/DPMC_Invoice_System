import 'dart:ui';

class ColorCycler {
  int _colorIndex = 0;
  final List<Color> tileColors;
  
  ColorCycler(this.tileColors);
  
  Color get getColor {
    final color = tileColors[_colorIndex % tileColors.length];
    _colorIndex++;
    return color;
  }
  
  void reset() => _colorIndex = 0;
}