import 'dart:convert';

import 'package:flutter/material.dart';
import 'ChessPiece.dart'; // Assurez-vous que cette classe est correctement définie

class ChessBoardPage extends StatefulWidget {
  @override
  _ChessBoardPageState createState() => _ChessBoardPageState();
}

class _ChessBoardPageState extends State<ChessBoardPage> {
  late List<List<ChessPiece?>> board; // Matrice représentant l'échiquier
  ChessPiece? selectedPiece;  // Pièce sélectionnée
  List<ChessPiece> blackDeadPieces = []; // Pièces noires capturées
  List<ChessPiece> whiteDeadPieces = []; // Pièces blanches capturées
  String colorTurn = 'white'; //couleur premier tour

  @override
  void initState() {
    super.initState();
    board = initializeChessBoard();
  }
  // Méthode pour initialiser l'échiquier avec les pièces
  List<List<ChessPiece?>> initializeChessBoard() {
    List<List<ChessPiece?>> board = List.generate(
        8, (_) => List.filled(8, null));
    String black = 'black';
    String white = 'white';
    List<String> pieceTypes = [
      'rook',
      'knight',
      'bishop',
      'queen',
      'king',
      'bishop',
      'knight',
      'rook'
    ];
    // Placement des pièces sur l'échiquier
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

        // Détermine si la case est un mouvement valide pour la pièce sélectionnée
        // et s'assure que la case cible ne contient pas une pièce de la même couleur
        bool isMoveValid = selectedPiece != null &&
            selectedPiece!.availableForMove(board, row, col, piece) &&
            (piece == null || piece.color != selectedPiece!.color);

        return GestureDetector(
          onTap: () => onTileTapped(piece, row, col),
          child: Container(
            decoration: BoxDecoration(
              color: (row + col) % 2 == 0 ? Colors.brown[700] : Colors.brown[300],
              // Appliquer une bordure verte pour les mouvements valides,
              // mais pas si la case cible contient une pièce de la même couleur
              border: isMoveValid ? Border.all(color: Colors.green, width: 2)
                  : (selectedPiece != null && piece == selectedPiece ? Border.all(color: Colors.red, width: 2) : null),
            ),
            child: piece != null
                ? Image.asset('assets/img/theme_defaut/${piece.color.toString()}/${piece.type.toString()}.png')
                : null,
          ),
        );
      },
    );
  }

  // Méthode pour imprimer l'état de l'échiquier en format JSON
  // Convertit la matrice d'objets ChessPiece en une structure JSON
  // Imprime la chaîne JSON résultante
  void printBoardAsJson(List<List<ChessPiece?>> board) {
    List<List<Map<String, dynamic>>> boardJson = [];

    for (var row in board) {
      List<Map<String, dynamic>> rowJson = [];
      for (var piece in row) {
        if (piece != null) {
          rowJson.add({
            'type': piece.type,
            'color': piece.color,
            'x': piece.x,
            'y': piece.y,
            'selected': piece.selected,
            'canMove': piece.canMove,
          });
        } else {
          rowJson.add({});
        }
      }
      boardJson.add(rowJson);
    }

    String jsonBoard = jsonEncode(boardJson);
    print(jsonBoard);
  }
  // Méthode pour mettre à jour l'échiquier à partir d'une chaîne JSON
  // Convertit la chaîne JSON en une matrice d'objets ChessPiece
  // Met à jour l'état de l'échiquier avec la nouvelle matrice
  void updateBoardFromJson(String jsonBoard) {
    List<dynamic> boardData = jsonDecode(jsonBoard);
    List<List<ChessPiece?>> newBoard = [];

    for (int i = 0; i < boardData.length; i++) {
      List<ChessPiece?> newRow = [];
      for (int j = 0; j < boardData[i].length; j++) {
        var pieceData = boardData[i][j];
        if (pieceData != null) {
          newRow.add(ChessPiece(
            pieceData['type'],
            pieceData['color'],
            pieceData['x'],
            pieceData['y'],
            selected: pieceData['selected'] ?? false,
            canMove: pieceData['canMove'] ?? false,
          ));
        } else {
          newRow.add(null);
        }
      }
      newBoard.add(newRow);
    }

    setState(() {
      board = newBoard;
    });
  }

  // Méthode appelée lorsqu'une case est tapée
  void onTileTapped(ChessPiece? piece, int row, int col) {
    setState(() {
      if (selectedPiece == null  && piece != null) {
        // Sélectionner la pièce si aucune n'est actuellement sélectionnée
        selectedPiece = piece;
        //Vérifie qu'on a bien sélectionner une pièce de la bonne couleur
        if(selectedPiece!.color != colorTurn){
          selectedPiece = null;
        }
      }
      else if (selectedPiece != null) {
        if (piece != null && piece.color == selectedPiece!.color) {
          // Si la pièce cliquée est de la même couleur, la sélectionner
          selectedPiece = piece;
        } else {
          // Vérifier si le mouvement est valide
          selectedPiece!.canMove = selectedPiece!.availableForMove(board, row, col, piece);

          if (selectedPiece!.canMove) {
            // Mouvement valide ou capture
            if (piece == null || piece.color != selectedPiece!.color) {
              // Capture d'une pièce adverse ou déplacement
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
              //change la prochaine couleur de pièce à jouer
              if(selectedPiece!.color == 'white') {
                colorTurn = 'black';
              }
              else {
                colorTurn = 'white';

              }
              selectedPiece = null;
            }
          } else {
            // Mouvement invalide, désélectionner la pièce
            selectedPiece = null;
          }
        }
      }
    });
  }

  // Méthode pour construire l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu d\'Échecs'),
      ),
      body: Column(
        children: [
          _buildCapturedPiecesRow(blackDeadPieces),
          // Affiche les pièces noires capturées
          Expanded(child: buildChessBoard()),
          // L'échiquier
          _buildCapturedPiecesRow(whiteDeadPieces),
          // Affiche les pièces blanches capturées
        ],
      ),
    );
  }

  // Méthode pour construire la ligne de pièces capturées
  Widget _buildCapturedPiecesRow(List<ChessPiece> capturedPieces) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.20, // 22% de la hauteur de l'écran
      padding: EdgeInsets.zero, // Padding à 0
      color: Colors.grey[200], // Couleur de fond pour la distinction
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: capturedPieces.map((piece) {
          return Padding(
            padding: EdgeInsets.zero, // Padding à 0 pour chaque élément
            child: Image.asset(
                'assets/img/theme_defaut/${piece.color.toString()}/${piece.type.toString()}.png',
                width: 30, height: 30),
          );
        }).toList(),
      ),
    );
  }

}




