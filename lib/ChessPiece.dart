import 'package:gamehub/linearMov.dart';
class ChessPiece {
  String type;
  String color;
  bool selected;
  bool canMove;
  int x, y; // Position sur l'échiquier

  // Constructeur de la classe ChessPiece
  ChessPiece(this.type, this.color, this.x, this.y,
      {this.selected = false, this.canMove = false});

  // Méthode pour vérifier si une pièce est disponible pour être déplacée vers une certaine position
  bool availableForMove(List<List<ChessPiece?>> board, int xTarget, int yTarget, ChessPiece? piece) {
    // Pour la tour ('rook')
    if (type == 'rook') {
      if (linearMov.hasHorizontalWay(x, y, xTarget, yTarget) &&
          linearMov.isPathClear(board, x, y, xTarget, yTarget)) {
        return true;
      }
      if (linearMov.hasVerticalWay(x, y, xTarget, yTarget) &&
          linearMov.isPathClear(board, x, y, xTarget, yTarget)) {
        return true;
      }
    }
    // Pour le cavalier ('knight')
    if(type=='knight'){
      final dx = (x - xTarget).abs();
      final dy = (y - yTarget).abs();

      if ((dx == 1 && dy == 2) || (dx == 2 && dy == 1)) return true;
    }
    // Pour le fou ('bishop')
    if (type == 'bishop') {
      if (linearMov.hasDiagonalWay(x, y, xTarget, yTarget) &&
          linearMov.isPathClear(board, x, y, xTarget, yTarget)) {
        return true;
      }
    }
    // Pour la reine ('queen')
    if (type == 'queen') {
      if ((linearMov.hasHorizontalWay(x, y, xTarget, yTarget) ||
          linearMov.hasVerticalWay(x, y, xTarget, yTarget) ||
          linearMov.hasDiagonalWay(x, y, xTarget, yTarget)) &&
          linearMov.isPathClear(board, x, y, xTarget, yTarget)) {
        return true;
      }
    }
    // Pour le roi ('king')
    if(type=='king'){
      if ((x-xTarget).abs()==1 && y==yTarget || (y-yTarget).abs()==1 && x==xTarget || (x-xTarget).abs()==1 && (y-yTarget).abs()==1) {
        return true;
      }
    }
    // Pour le pion ('pawn')
    if(type=='pawn'){
      final step = (color == 'black') ? 1 : -1;
      final isStepCorrect = xTarget == x + step;
      // Pour une case vide
      if (isStepCorrect && y == yTarget && piece == null) {
        return true;
      }
      // Pour le premier déplacement
      if ((color =='white' && x==6) || (color =='black' && x==1)) {
        final doubleStep = (color == 'black') ? 2 : -2;
        final isDoubleStepCorrect = xTarget == x + doubleStep;
        // Pour une case vide
        if (isDoubleStepCorrect && y == yTarget && piece == null) {
          return true;
        }
      }
      // Pour une case occupée
      if (isStepCorrect && (yTarget == y + 1 || yTarget == y - 1) && piece!=null && piece.color!=color) {
        return true;
      }
    }
    return false;
  }
}