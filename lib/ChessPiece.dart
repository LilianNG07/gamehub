import 'package:gamehub/linearMov.dart';
class ChessPiece {
  String type;
  String color;
  bool selected;
  bool canMove;
  int x, y; // Position sur l'échiquier

  ChessPiece(this.type, this.color, this.x, this.y,
      {this.selected = false, this.canMove = false});

  bool availableForMove(int xTarget, int yTarget, ChessPiece? piece) {
    if(type=='rook'){
      if (linearMov.hasHorizontalWay(x, y, xTarget, yTarget)) return true;
      if (linearMov.hasVerticalWay(x, y, xTarget, yTarget)) return true;
    }

    if(type=='knight'){
      final dx = (x - xTarget).abs();
      final dy = (y - yTarget).abs();

      if ((dx == 1 && dy == 2) || (dx == 2 && dy == 1)) return true;
    }

    if(type=='bishop'){
      if (linearMov.hasDiagonalWay(x, y, xTarget, yTarget)) return true;
    }

    if(type=='queen'){
      if (linearMov.hasHorizontalWay(x, y, xTarget, yTarget)) return true;
      if (linearMov.hasVerticalWay(x, y, xTarget, yTarget)) return true;
      if (linearMov.hasDiagonalWay(x, y, xTarget, yTarget)) return true;
    }

    if(type=='king'){
      if ((x-xTarget).abs()==1 && y==yTarget || (y-yTarget).abs()==1 && x==xTarget || (x-xTarget).abs()==1 && (y-yTarget).abs()==1) {
        return true;
      }
    }

    if(type=='pawn'){
      final step = (color == 'black') ? 1 : -1;
      final isStepCorrect = xTarget == x + step;
      // for empty cell
      if (isStepCorrect && y == yTarget && piece == null) {
        return true;
      }
      // for first movement
      if ((color =='white' && x==6) || (color =='black' && x==1)) {
        final doubleStep = (color == 'black') ? 2 : -2;
        final isDoubleStepCorrect = xTarget == x + doubleStep;
        // for empty cell
        if (isDoubleStepCorrect && y == yTarget && piece == null) {
          return true;
        }
      }
      // for occupied cell
      if (isStepCorrect && (yTarget == y + 1 || yTarget == y - 1) && piece!=null && piece.color!=color) {
        return true;
      }
    }
    return false;
  }
}