import 'package:flutter/cupertino.dart';

class Filter {
  double _sigX, _sigY, _opacity;
  Color _color;

  double get sigX => _sigX;
  double get sigY => _sigY;
  double get opacity => _opacity;
  Color get color => _color;

  Filter(this._sigX, this._sigY, this._opacity, this._color);
}