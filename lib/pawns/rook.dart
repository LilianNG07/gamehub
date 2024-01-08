import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';
import 'package:gamehub/pawns/linearMov.dart';

class Rook extends Pawn {
  Rook({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.rook);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;
    if (linearMov.hasHorizontalWay(cell, to)) return true;
    if (linearMov.hasVerticalWay(cell, to)) return true;

    return false;
  }
}