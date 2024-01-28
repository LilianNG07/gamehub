
import 'ChessPiece.dart';

abstract class linearMov {
  // Méthode pour vérifier si le déplacement est vertical
  static bool hasVerticalWay(int x,int y,int xTarget,int yTarget) {
    if (y == yTarget && x != xTarget) {
      return true;
    }
    return false;
  }
  // Méthode pour vérifier si le déplacement est horizontal
  static bool hasHorizontalWay(int x,int y,int xTarget,int yTarget) {
    if (y != yTarget && x == xTarget) {
      return true;
    }
    return false;
  }
  // Méthode pour vérifier si le déplacement est diagonal
  static bool hasDiagonalWay(int x,int y,int xTarget,int yTarget) {
    if ((y - yTarget).abs() == (x - xTarget).abs()) {
      return true;
    }
    return false;
  }
  // Méthode pour vérifier si le chemin est libre entre deux positions sur l'échiquier
  static bool isPathClear(List<List<ChessPiece?>> board, int x, int y, int xTarget, int yTarget) {
    // Calcul des deltas pour déterminer la direction du déplacement
    int deltaX = xTarget - x;
    int deltaY = yTarget - y;
    // Calcul des pas pour se déplacer d'une case à l'autre
    int stepX = deltaX != 0 ? deltaX ~/ deltaX.abs() : 0;
    int stepY = deltaY != 0 ? deltaY ~/ deltaY.abs() : 0;
    // Initialisation des coordonnées actuelles à la position de départ
    int currentX = x + stepX;
    int currentY = y + stepY;

    // Boucle pour vérifier chaque case entre la position actuelle et la position cible
    while (currentX != xTarget || currentY != yTarget) {
      if (currentX < 0 || currentX > 7 || currentY < 0 || currentY > 7) {
        return false; // Hors des limites de l'échiquier
      }
      // Vérifier si la case est occupée par une autre pièce
      if (board[currentX][currentY] != null) {
        return false; // Blocage par une autre pièce
      }
      // Passer à la case suivante dans la direction du déplacement
      currentX += stepX;
      currentY += stepY;
    }

    return true; // Le chemin est libre
  }

}