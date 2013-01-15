class Chess
  def initialize
    @board = Array.new(8) { Array.new(8) }
    populate_board
    @white_player, @black_player = HumanPlayer.new, HumanPlayer.new
  end

  def populate_board
    # Populate back rows
    [[0, :white], [7, :black]].each do |(row, color)|
      @board[row] = [Rook.new(color), Knight.new(color), Bishop.new(color),
        King.new(color), Queen.new(color), Bishop.new(color),
        Knight.new(color), Rook.new(color)]
    end

    # Populate pawns
    @board[1].map { Pawn.new(:white) }
    @board[6].map { Pawn.new(:black) }
  end

  play
  # Until checkmate
    # for each player
      # move = get_move(player)
      # move_piece(move)
      # print board

  # Checkmate!
  # checkmate(white) ? Black wins! : White wins!

  def move_piece(from, to)
    # Place on to
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    # Remove from from
    @board[from[0]][from[1]] = nil
  end

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

  def valid_move?(from, to, player) # from/to: [x, y]
    to_piece = @board[to[0]][to[1]]
    from_piece = @board[from[0]][from[1]]
    return false unless on_board?(from) && on_board?(to)
    # make sure the player is moving his/her own pieces
    return false unless from_piece.color == player.color
    # correct piece-type movement (piece.available_moves(from).include?(to))
    # Is there a piece on to?
    unless to_piece.nil?
      return false if to_piece.color == player.color
    end
    # invalid if there any pieces on the path
    # invalid if move puts your king in check?
  end

  def on_board?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end
end

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class HumanPlayer < Player
  get_move
    # input: e4, a2
    # returns: [from, to]
end

class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class King < Piece
end

class Queen < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Rook < Piece
end

class Pawn < Piece

      #if landing on another color, move must be diagonal
      #else move must be straigt
end

way of moving
#direction
#how far can they move?

available_moves(pos)
# returns an array of possible next positions (not taking into account
# the state of the board)

path(from, to)
# returns an array of positions from from to to
# custom build for each type of piece
























