import 'package:chess_app/models/cell.dart';
import 'package:gamehub/Board/

const boardSize = 8;

class Board {
  final List<List<Cell>> cells;

  final LostFigures blackLost;
  final LostFigures whiteLost;

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

  void pushFigureLoLost(Figure lostFigure) {
    if (lostFigure.isBlack) {
      blackLost.push(lostFigure);
    }

    if (lostFigure.isWhite) {
      whiteLost.push(lostFigure);
    }
  }

  Set<String> getAvailablePositionsHash(Cell? selectedCell) {
    return CellCalculator.getAvailablePositionsHash(this, selectedCell);
  }

  Board copyThis() {
    return Board(cells: cells, blackLost: blackLost, whiteLost: whiteLost);
  }

  Cell getCellAt(int x, int y) {
    return cells[y][x];
  }

}