import 'package:gamehub/Board/cell.dart';
import 'package:gamehub/Board/cell_pos.dart';
import 'package:gamehub/pawns/lostPawn.dart';
import 'package:gamehub/pawns/pawn.dart';

const boardSize = 8;

class Board {
  final List<List<Cell>> cells;

  final LostPawns blackLost;
  final LostPawns whiteLost;

  Board({required this.cells, required this.blackLost, required this.whiteLost});

  void createCells() {
    for (int y = 0; y < boardSize; y++) {
      final List<Cell> row = [];

      for (int x = 0; x < boardSize; x++) {
        if ((x + y) % 2 != 0) {
          row.add(Cell.white(board: this, position: CellPosition(x, y)));
        } else {
          row.add(Cell.black(board: this, position: CellPosition(x, y)));
        }
      }

      cells.add(row);
    }
  }

  void pushPawnLoLost(Pawn lostPawn) {
    if (lostPawn.isBlack) {
      blackLost.push(lostPawn);
    }

    if (lostPawn.isWhite) {
      whiteLost.push(lostPawn);
    }
  }

  Set<String> getAvailablePositionsHash(Cell? selectedCell) {
    final Set<String> availableCells = {};

    if (selectedCell == null || !selectedCell.occupied) return availableCells;

    for (int y = 0; y < boardSize; y++) {
      for (int x = 0; x < boardSize; x++) {
        final target = getCellAt(x, y);
        if (selectedCell.getPawn()!.availableForMove(target)) {
          availableCells.add(target.positionHash);
        }
      }
    }
    return availableCells;
  }

  Board copyThis() {
    return Board(cells: cells, blackLost: blackLost, whiteLost: whiteLost);
  }

  Cell getCellAt(int x, int y) {
    return cells[y][x];
  }

}