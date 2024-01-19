import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';
import 'package:gamehub/pawns/linearMov.dart';

class Bishop extends Pawn {
  Bishop({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.bishop);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;
    if (linearMov.hasDiagonalWay(cell, to)) return true;
    return false;
  }
}