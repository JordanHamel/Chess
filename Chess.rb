Chess
# Initialize with full set of pieces
@white_pieces = new_chess_set
@black_pieces = new_chess_set
@board = Array.new(8) { Array.new(8) }
# Array of arrays of piece objects (8 x 8)

populate_board
  # @board[pawn_row_1].each { put a pawn in }
  # @board[pawn_row_2]
  # Hard code initial positions

@white_player, @black_player = HumanPlayer.new, HumanPlayer.new

new_chess_set
  # pieces = []
  # 8.times { pieces << Pawn.new }
  # 2.times do
    # pieces << Rook.new
    # pieces << Bishop.new
    # pieces << Knight.new
  # end
  # pieces << King.new << Queen.new

play
# Until checkmate
  # for each player
    # move = get_move(player)
    # move_piece(move)
    # print board

# Checkmate!
# checkmate(white) ? Black wins! : White wins!

get_move(player)
  # until valid_move?
    # player.get_move

check?(player)
  # Is player's King in check?
    # Check to see if King's position is in any of
    # opposite player's pieces' available moves

    # For each of the other player's pieces
    #{valid_move?(current pos, other king pos)}

checkmate?(player)
  # Is player's king in checkmate?
  # Is king in check?
  # Can King move to safety?
  # Can any of player's moves block the check?

valid_move?(from, to)
  # moves on the board?
  # make sure the player is moving his/her own pieces

  # correct piece-type movement (piece.available_moves(from).include?(to))
  # Is there a piece on to?
    # If yes, check color
      # If same color, invalid
      # If opposite color, valid
    # If no, valid
  # invalid if there any pieces on the path
  # invalid if move puts your king in check?

move_piece(from, to)
  # Remove from from
  # Place on to
  # Remove any piece that was on to


HumanPlayer
get_move
  # input: e4, a2
  # returns: [from, to]


TypeofPiece

way of moving
#direction
#how far can they move?

availabe_moves(pos)
# returns an array of valid positions

path(from, to)
# returns an array of positions from from to to
# custom build for each type of piece
























