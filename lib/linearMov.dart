
import 'ChessPiece.dart';

abstract class linearMov {
  static bool hasVerticalWay(int x,int y,int xTarget,int yTarget) {
    if (y == yTarget && x != xTarget) {
      return true;
    }
    return false;
  }

  static bool hasHorizontalWay(int x,int y,int xTarget,int yTarget) {
    if (y != yTarget && x == xTarget) {
      return true;
    }
    return false;
  }

  static bool hasDiagonalWay(int x,int y,int xTarget,int yTarget) {
    if ((y - yTarget).abs() == (x - xTarget).abs()) {
      return true;
    }
    return false;
  }

  static bool isPathClear(List<List<ChessPiece?>> board, int x, int y, int xTarget, int yTarget) {
    int deltaX = xTarget - x;
    int deltaY = yTarget - y;
    int stepX = deltaX != 0 ? deltaX ~/ deltaX.abs() : 0;
    int stepY = deltaY != 0 ? deltaY ~/ deltaY.abs() : 0;

    int currentX = x + stepX;
    int currentY = y + stepY;

    while (currentX != xTarget || currentY != yTarget) {
      if (currentX < 0 || currentX > 7 || currentY < 0 || currentY > 7) {
        return false; // Hors des limites de l'échiquier
      }
      if (board[currentX][currentY] != null) {
        return false; // Blocage par une autre pièce
      }

      currentX += stepX;
      currentY += stepY;
    }

    return true; // Le chemin est libre
  }

}