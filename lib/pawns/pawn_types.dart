enum PawnTypes {
  king,
  knight,
  pawn,
  queen,
  rook,
  bishop,
}

extension ParseToString on PawnTypes {
  String toName() {
    return toString().split('.').last;
  }
}