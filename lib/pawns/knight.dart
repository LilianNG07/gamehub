import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';

class Knight extends Pawn {
  Knight({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.knight);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;
    final dx = (cell.position.x - to.position.x).abs();
    final dy = (cell.position.y - to.position.y).abs();

    return (dx == 1 && dy == 2) || (dx == 2 && dy == 1);
  }
}