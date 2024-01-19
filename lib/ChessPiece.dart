class ChessPiece {
  String type;
  String color;
  bool selected;
  bool canMove;
  int x, y; // Position sur l'échiquier

  ChessPiece(this.type, this.color, this.x, this.y, {this.selected = false, this.canMove = false});
}