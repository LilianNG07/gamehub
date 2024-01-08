import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';

class SimplePawn extends Pawn {
  bool _canDoubleMove = true;

  SimplePawn({required GameColors color, required Cell cell}) : super(color: color, cell: cell, type: PawnTypes.pawn);

  @override
  onMoved(Cell to) {
    super.onMoved(to);
    _canDoubleMove = false;
  }

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;

    final step = (cell.occupied && cell.getPawn()!.color == GameColors.black) ? 1 : -1;
    final isStepCorrect = to.position.y == cell.position.y + step;
    final isTargetOccupied = cell.board.getCellAt(to.position.x, to.position.y).occupied;

    // for empty cell
    if (isStepCorrect && to.position.x == cell.position.x && !isTargetOccupied) {
      return true;
    }

    if (_canDoubleMove) {
      final doubleStep = (cell.occupied && cell.getPawn()!.color == GameColors.black) ? 2 : -2;
      final isDoubleStepCorrect = to.position.y == cell.position.y + doubleStep;

      // for empty cell
      if (isDoubleStepCorrect && to.position.x == cell.position.x && !isTargetOccupied) {
        return true;
      }
    }

    // for occupied cell
    if (isStepCorrect && (to.position.x == cell.position.x + 1 || to.position.x == cell.position.x - 1) && cell.occupiedByEnemy(to)) {
      return true;
    }

    return false;
  }
}