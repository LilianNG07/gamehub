import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/Board/cell_pos.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';

class King extends Pawn {
  King({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.king);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;

    final v = CellPosition(cell.position.x - to.position.x, cell.position.y - to.position.y);
    if (v.magnitude == 1) {
      return true;
    }

    return false;
  }
}