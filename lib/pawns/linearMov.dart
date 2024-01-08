import 'dart:math';
import 'package:gamehub/Board/cell.dart';

abstract class linearMov {
  static bool hasVerticalWay(Cell from, Cell target) {
    if (from.position.x != target.position.x) {
      return false;
    }

    final minY = min(from.position.y, target.position.y);
    final maxY = max(from.position.y, target.position.y);

    for (int y = minY + 1; y < maxY; y++) {
      if (from.board.getCellAt(from.position.x, y).occupied) {
        return false;
      }
    }

    return true;
  }

  static bool hasHorizontalWay(Cell from, Cell target) {
    if (from.position.y != target.position.y) {
      return false;
    }

    final minX = min(from.position.x, target.position.x);
    final maxX = max(from.position.x, target.position.x);

    for (int x = minX + 1; x < maxX; x++) {
      if (from.board.getCellAt(x, from.position.y).occupied) {
        return false;
      }
    }

    return true;
  }

  static bool hasDiagonalWay(Cell from, Cell target) {
    final absX = (target.position.x - from.position.x).abs();
    final absY = (target.position.y - from.position.y).abs();

    if (absY != absX) {
      return false;
    }

    final originY = from.position.y < target.position.y ? 1 : -1;
    final originX = from.position.x < target.position.x ? 1 : -1;

    for (int i = 1; i < absY; i++) {
      if (from.board.getCellAt(from.position.x + originX * i, from.position.y + originY * i).occupied) {
        return false;
      }
    }

    return true;
  }
}