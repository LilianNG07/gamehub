import 'package:gamehub/pawns/pawn.dart';

class LostPawns {
  final List<Pawn> _pawns = [];

  List<Pawn> get figures => _pawns;

  push(Pawn pawn) {
    _pawns.add(pawn);
  }
}