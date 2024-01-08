import 'package:flutter/material.dart';
import 'ChessPiece.dart'; // Assurez-vous que cette classe est correctement définie

class ChessBoardPage extends StatefulWidget {
  @override
  _ChessBoardPageState createState() => _ChessBoardPageState();
}

class _ChessBoardPageState extends State<ChessBoardPage> {
  late List<List<ChessPiece?>> board;
  ChessPiece? selectedPiece;
  List<ChessPiece> blackDeadPieces = []; // Pièces noires capturées
  List<ChessPiece> whiteDeadPieces = []; // Pièces blanches capturées

  @override
  void initState() {
    super.initState();
    board = initializeChessBoard();
  }

  List<List<ChessPiece?>> initializeChessBoard() {
    List<List<ChessPiece?>> board = List.generate(8, (_) => List.filled(8, null));
    String black = 'black';
    String white = 'white';
    List<String> pieceTypes = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'];

    for (int i = 0; i < 8; i++) {
      board[0][i] = ChessPiece(pieceTypes[i], black, 0, i);
      board[1][i] = ChessPiece('pawn', black, 1, i);
      board[6][i] = ChessPiece('pawn', white, 6, i);
      board[7][i] = ChessPiece(pieceTypes[i], white, 7, i);
    }

    return board;
  }

  Widget buildChessBoard() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
      itemCount: 64,
      itemBuilder: (context, index) {
        int row = index ~/ 8;
        int col = index % 8;
        ChessPiece? piece = board[row][col];

        return GestureDetector(
          onTap: () => onTileTapped(piece, row, col),
          child: Container(
            decoration: BoxDecoration(
              color: (row + col) % 2 == 0 ? Colors.brown[700] : Colors.brown[300],
              border: piece == selectedPiece ? Border.all(color: Colors.red, width: 2) : null,
            ),
            child: piece != null ? Image.asset('assets/img/theme_defaut/${piece.color}/${piece.type}.png') : null,
          ),
        );
      },
    );
  }

  void onTileTapped(ChessPiece? piece, int row, int col) {
    setState(() {
      if (selectedPiece == null && piece != null) {
        // Sélectionner la pièce
        selectedPiece = piece;
      } else if (selectedPiece != null) {
        // Déplacer la pièce si le mouvement est valide (logique à implémenter)
        if (piece == null || piece.color != selectedPiece!.color) {
          // Capture d'une pièce adverse
          if (piece != null) {
            if (piece.color == 'black') {
              blackDeadPieces.add(piece);
            } else {
              whiteDeadPieces.add(piece);
            }
          }
          // Mise à jour de la position de la pièce
          board[selectedPiece!.x][selectedPiece!.y] = null;
          board[row][col] = selectedPiece;
          selectedPiece!.x = row;
          selectedPiece!.y = col;
          selectedPiece = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu d\'Échecs'),
      ),
      body: Column(
        children: [
          _buildCapturedPiecesRow(blackDeadPieces), // Affiche les pièces noires capturées
          Expanded(child: buildChessBoard()), // L'échiquier
          _buildCapturedPiecesRow(whiteDeadPieces), // Affiche les pièces blanches capturées
        ],
      ),
    );
  }
  Widget _buildCapturedPiecesRow(List<ChessPiece> capturedPieces) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200], // Couleur de fond pour la distinction
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: capturedPieces.map((piece) {
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: Image.asset('assets/img/theme_defaut/${piece.color}/${piece.type}.png', width: 30, height: 30),
          );
        }).toList(),
      ),
    );
  }

}
