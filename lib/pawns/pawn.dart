import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/pawns/pawn_types.dart';
import 'package:gamehub/pawns/color.dart';

class PawnsAssetPresenter {
  final PawnTypes type;
  final GameColors color;

  PawnsAssetPresenter(this.type, this.color);

  getAsset() {
    return 'pawns/' + color.toName() + '/' + type.toName() + '.png';
  }
}

abstract class Pawn {
  final GameColors color;
  final PawnTypes type;

  Cell cell;

  String get imageAsset => PawnsAssetPresenter(type, color).getAsset();

  bool get isBlack => color == GameColors.black;
  bool get isWhite => color == GameColors.white;

  Pawn({required this.color, required this.cell, required this.type}) {
    cell.setPawn(this);
  }

  bool availableForMove(Cell to) {
    if (!to.occupied) {
      return true;
    }

    Pawn occupiedPawn = to.getPawn()!;

    if (occupiedPawn.color == color) {
      return false;
    }

    if (occupiedPawn.type == PawnTypes.king) {
      return false;
    }

    return true;
  }

  void onMoved(Cell to) {
    cell = to;
  }
}