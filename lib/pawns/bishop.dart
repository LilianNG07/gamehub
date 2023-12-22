import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';

class Bishop extends Pawn {
  Bishop({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.bishop);

  @override
  static bool hasDiagonalWay(Cell from, Cell target) {
    final absX = (target.position.x - from.position.x).abs();
    final absY = (target.position.y - from.position.y).abs();

    if (absY != absX) {
      return false;
    }

    final originY = from.position.y < target.position.y ? 1 : -1;
    final originX = from.position.x < target.position.x ? 1 : -1;

    for (int i = 1; i < absY; i++) {
      if (from.board
          .getCellAt(
          from.position.x + originX * i, from.position.y + originY * i)
          .occupied) {
        return false;
      }
    }
    return true;
  }
}