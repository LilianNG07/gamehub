import 'dart:math';
import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';
import 'package:gamehub/pawns/linearMov.dart';

class Queen extends Pawn {
  Queen({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.queen);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;
    if (linearMov.hasHorizontalWay(cell, to)) return true;
    if (linearMov.hasVerticalWay(cell, to)) return true;
    if (linearMov.hasDiagonalWay(cell, to)) return true;

    return false;
  }

}