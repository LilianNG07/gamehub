import 'dart:convert';

import 'package:http/http.dart' as http;
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
  String? _gameId;  // Variable to store the game ID

  @override
  void initState() {
    super.initState();
    board = initializeChessBoard();
    startGame(); // Appel à une nouvelle fonction pour démarrer le jeu
  }

  void startGame() async {
    try {
      _gameId = await challengeLichessAI(); // Stocker l'ID de la partie retourné
      print("Partie démarrée avec succès, ID de la partie: $_gameId");
      // Vous pouvez ajouter d'autres actions ici si nécessaire
    } catch (e) {
      print("Erreur lors du démarrage de la partie: $e");
      // Gérer l'erreur ici, par exemple, afficher un message à l'utilisateur
    }
  }

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

  String convertBoardToFen() {
    String fen = "";

    for (int y = 0; y < 8; y++) {
      int emptyCount = 0;

      for (int x = 0; x < 8; x++) {
        ChessPiece? piece = board[y][x];

        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount != 0) {
            fen += emptyCount.toString();
            emptyCount = 0;
          }
          String pieceCode = piece.type.substring(0, 1);
          fen += piece.color == 'white' ? pieceCode.toUpperCase() : pieceCode.toLowerCase();
        }
      }

      if (emptyCount != 0) {
        fen += emptyCount.toString();
      }

      if (y != 7) fen += '/';
    }

    // Ajouter les informations supplémentaires, par défaut pour cet exemple
    fen += ' w KQkq - 0 1';

    return fen;
  }

  Future<String> challengeLichessAI() async {
    var url = Uri.parse('https://lichess.org/api/challenge/stockfish');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer lip_1oZiuzjoHcNkEWqquXmW'
    }, body: {
      'level': '1', // Niveau de l'IA
      'clock.limit': '600', // Temps initial en secondes
      'clock.increment': '10', // Incrément en secondes
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Réponse complète de l'API: $data");
      String gameId = data['challenge']['id']; // Modification ici
      if (gameId != null && gameId.isNotEmpty) {
        print('Jeu créé avec succès. ID de la partie: $gameId');
        return gameId;
      } else {
        throw Exception('ID de jeu non trouvé dans la réponse de l\'API');
      }
    } else {
      print('Erreur lors de la création du jeu: ${response.body}');
      throw Exception('Failed to create game');
    }
  }

  void onTileTapped(ChessPiece? piece, int row, int col) async {
    if (selectedPiece == null && piece != null) {
      setState(() {
        selectedPiece = piece;
      });
    } else if (selectedPiece != null) {
      if (selectedPiece!.availableForMove(board, row, col, piece)) {
        // Gérer le mouvement et la capture
        handleMoveAndCapture(piece, row, col);

        String fen = convertBoardToFen();
        String move = convertMoveToUCI(selectedPiece!.x, selectedPiece!.y, row, col);

        try {
          // Assurez-vous que _gameId est initialisé
          String nextMove = await getNextMoveFromLichess(move);

          setState(() {
            applyMoveToBoard(nextMove);
          });
        } catch (e) {
          print('Erreur lors de la récupération du coup suivant: $e');
        }
      } else {
        setState(() {
          selectedPiece = null;
        });
      }
    }
  }

  String convertMoveToUCI(int startX, int startY, int endX, int endY) {
    const columns = 'abcdefgh';

    // Convertit les coordonnées de la grille en notations UCI
    String startCol = columns[startX];
    String startRow = (8 - startY).toString();
    String endCol = columns[endX];
    String endRow = (8 - endY).toString();

    return startCol + startRow + endCol + endRow;
  }


  void applyMoveToBoard(String move) {
    if (move.length < 4) return; // Vérifie la longueur du mouvement

    // Convertit les positions UCI en indices de tableau (0-7)
    int startX = 'abcdefgh'.indexOf(move[0]);
    int startY = 8 - int.parse(move[1]);
    int endX = 'abcdefgh'.indexOf(move[2]);
    int endY = 8 - int.parse(move[3]);

    // Vérifie la validité des indices
    if (startX < 0 || startY < 0 || endX < 0 || endY < 0 ||
        startX > 7 || startY > 7 || endX > 7 || endY > 7) {
      return; // Mouvement invalide
    }

    // Obtient et déplace la pièce
    ChessPiece? movingPiece = board[startY][startX];
    if (movingPiece != null) {
      board[startY][startX] = null;
      board[endY][endX] = movingPiece;

      // Mise à jour des coordonnées de la pièce
      movingPiece.x = endX;
      movingPiece.y = endY;

      setState(() {}); // Met à jour l'état du widget
    }
  }


  void handleMoveAndCapture(ChessPiece? piece, int row, int col) {
    if (piece != null) {
      // Gérer la capture
      if (piece.color != selectedPiece!.color) {
        if (piece.color == 'black') {
          blackDeadPieces.add(piece);
        } else {
          whiteDeadPieces.add(piece);
        }
      }
    }

    // Mise à jour de la position de la pièce
    board[selectedPiece!.x][selectedPiece!.y] = null;
    board[row][col] = selectedPiece;
    selectedPiece!.x = row;
    selectedPiece!.y = col;
    selectedPiece = null;
  }


  Future<String> getNextMoveFromLichess(String move) async {
    if (_gameId == null) {
      throw Exception('Game ID is not set');
    }

    // URL pour envoyer votre mouvement
    var moveUrl = Uri.parse('https://lichess.org/api/board/game/$_gameId/move/$move');
    var moveResponse = await http.post(moveUrl, headers: {
      'Authorization': 'Bearer lip_1oZiuzjoHcNkEWqquXmW'
    });

    if (moveResponse.statusCode == 200) {
      print('Mouvement envoyé avec succès');

      // URL pour obtenir l'état actuel de la partie
      var stateUrl = Uri.parse('https://lichess.org/api/board/game/stream/$_gameId');
      var stateResponse = await http.get(stateUrl, headers: {
        'Authorization': 'Bearer lip_1oZiuzjoHcNkEWqquXmW'
      });

      if (stateResponse.statusCode == 200) {
        var data = jsonDecode(stateResponse.body);
        // Extraire le dernier mouvement de l'IA à partir des données reçues
        String lastMove = data['moves'].split(' ').last;
        return lastMove;
      } else {
        print('Erreur lors de la récupération de l\'état de la partie: ${stateResponse.body}');
        throw Exception('Failed to get game state');
      }
    } else {
      print('Erreur lors de l\'envoi du mouvement: ${moveResponse.body}');
      throw Exception('Failed to send move');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partie normale'),
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

