import 'package:flutter/material.dart';

class ChessBoardPage extends StatelessWidget {
  String? getChessPieceImage(int index) {
    int row = index ~/ 8; // Déterminer la rangée
    int col = index % 8; // Déterminer la colonne

    // Chemins d'image pour les pièces noires et blanches
    String basePath = 'assets/img/theme_defaut/';
    Map<String, String> blackPieces = {
      'pawn': '${basePath}black/pawn.png',
      'rook': '${basePath}black/rook.png',
      'knight': '${basePath}black/knight.png',
      'bishop': '${basePath}black/bishop.png',
      'queen': '${basePath}black/queen.png',
      'king': '${basePath}black/king.png',
    };
    Map<String, String> whitePieces = {
      'pawn': '${basePath}white/pawn.png',
      'rook': '${basePath}white/rook.png',
      'knight': '${basePath}white/knight.png',
      'bishop': '${basePath}white/bishop.png',
      'queen': '${basePath}white/queen.png',
      'king': '${basePath}white/king.png',
    };

    if (row == 0) {
      switch (col) {
        case 0:
        case 7:
          return blackPieces['rook'];
        case 1:
        case 6:
          return blackPieces['knight'];
        case 2:
        case 5:
          return blackPieces['bishop'];
        case 3:
          return blackPieces['queen'];
        case 4:
          return blackPieces['king'];
      }
    } else if (row == 1) {
      return blackPieces['pawn'];
    }

    if (row == 7) {
      switch (col) {
        case 0:
        case 7:
          return whitePieces['rook'];
        case 1:
        case 6:
          return whitePieces['knight'];
        case 2:
        case 5:
          return whitePieces['bishop'];
        case 3:
          return whitePieces['queen'];
        case 4:
          return whitePieces['king'];
      }
    } else if (row == 6) {
      return whitePieces['pawn'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu d\'Échecs'),
      ),
      body: Column(
        children: [
          _buildChessPieceRow('black'), // Rangée de pièces noires en haut
          Expanded(
            child: _buildChessBoard(),
          ),
          _buildChessPieceRow('white'), // Rangée de pièces blanches en bas
        ],
      ),
    );
  }

  Widget _buildChessBoard() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemCount: 64,
      itemBuilder: (context, index) {
        bool isDarkSquare = (index ~/ 8 % 2 == 0 && index % 2 == 0) ||
            (index ~/ 8 % 2 == 1 && index % 2 == 1);

        return Container(
          color: isDarkSquare ? Colors.brown[700] : Colors.brown[300],
          child: getChessPieceImage(index) != null
              ? Image.asset(
            getChessPieceImage(index)!,
            width: 150,
            height: 150,
          )
              : null,
        );
      },
    );
  }

  Widget _buildChessPieceRow(String color) {
    List<String> pieces = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pieces.map((piece) => Image.asset('assets/img/theme_defaut/$color/$piece.png', width: 50, height: 50)).toList(),
    );
  }
}
