import 'package:chess_app/models/board.dart';
import 'package:chess_app/models/cell_position.dart';
import 'package:gamehub/pawns/pawn.dart';
import 'package:gamehub/pawns/color.dart';

class Cell {
  final GameColors color;
  final Board board;
  final CellPosition position;

  Pawn? _pawn;

  bool get occupied => _pawn != null;

  bool get isBlack => color == GameColors.black;
  bool get isWhite => color == GameColors.white;

  String get positionHash => '${position.x}-${position.y}';

  Cell({required this.color, required this.board, required this.position});

  Cell.white({required this.board, required this.position}) : color = GameColors.white;

  Cell.black({required this.board, required this.position}) : color = GameColors.black;

  void setPawn(Pawn pawn) {
    _pawn = pawn;
    //figure.onMoved(this);
  }

  Pawn? getPawn() {
    return _pawn;
  }

  bool occupiedByEnemy(Cell target) {
    if (target.occupied) {
      assert(occupied);
      return _pawn!.color != target.getPawn()!.color;
    }

    return false;
  }

  void movePawn(Cell target) {
    if (!occupied) {
      return;
    }

    final pawn = _pawn!;

    if (pawn.availableForMove(target)) {
      if (target.occupied) {
        assert(target.getPawn() != null);
        board.pushFigureLoLost(target.getPawn()!);
      }

      target.setPawn(pawn);
      pawn.onMoved(target);

      _pawn = null;
    }
  }
}