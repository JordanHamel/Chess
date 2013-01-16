class Chess
  attr_reader :white_player, :black_player
  def initialize
    @board = Array.new(8) { Array.new(8) }
    populate_board
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
  end

  def populate_board
    # Populate back rows
    [[0, :black], [7, :white]].each do |(row, color)|
      @board[row] = [Rook.new(color), Knight.new(color), Bishop.new(color),
          King.new(color), Queen.new(color), Bishop.new(color),
          Knight.new(color), Rook.new(color)]
    end

    # Populate pawns
    @board[1].map! { Pawn.new(:black) }
    @board[6].map! { Pawn.new(:white) }
  end

  def print_board
    visuals = { 'King' => 'K',
                'Queen' => 'Q',
                'Knight' => 'N',
                'Bishop' => 'B',
                'Rook' => 'R',
                'Pawn' => 'P' }
    @board.each_with_index do |row, x|
      print "\n  "
      print "#{(x - 8).abs}| "
      row.each do |piece|
        mark = if piece.nil?
          "*"
        else
          if piece.color == :white
            visuals[piece.class.to_s].downcase
          else
            visuals[piece.class.to_s]
          end
        end
        print "#{mark} "
      end
    end
    puts
    puts "     " << "-"*15
    print "     "
    puts "#{('a'..'h').to_a.join(' ')}"
    puts "\n\n"
  end

  def play
    until checkmate?
      [@white_player, @black_player].each do |player|
        print_board
        from, to = get_move(player)
        move_piece(from, to)
      end
    end

    # Checkmate!
    # checkmate(white) ? Black wins! : White wins!
  end

  def move_piece(from, to)
    # Place on to
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    # Remove from from
    @board[from[0]][from[1]] = nil
  end

  def get_move(player)
    while true
      move = player.get_move
      from, to = convert_move(move)
      break if valid_move?(from, to, player)
      puts "Invalid move. Please try again."
    end

    [from, to]
  end

  def convert_move(move)
    # Converts from ['e4', 'b2'] to [[4, 4], [6, 1]]
    move.map do |pos|
      pos.split('').reverse.map do |char|
        (1..8).include?(char.to_i) ? (char.to_i - 8).abs : char.ord - 97
      end
    end
  end

  def valid_move?(from, to, player) # from/to: [x, y]
    to_piece = @board[to[0]][to[1]]
    from_piece = @board[from[0]][from[1]]
    # From cannot equal to
    return false if from == to
    # Make sure from has a piece on it
    return false if from_piece.nil?
    # Make sure positions are on the board
    return false unless on_board?(from) && on_board?(to)
    # Make sure the player is moving his/her own pieces
    return false unless from_piece.color == player.color
    # Is there a piece on to?
    unless to_piece.nil?
      return false if to_piece.color == player.color
    end

    # correct piece-type movement
    return false unless from_piece.available_moves(from).include?(to)

    # invalid if there any pieces on the path
    # invalid if move puts your king in check?

    true
  end

  # check?(player)
    # Is player's King in check?
      # Check to see if King's position is in any of
      # opposite player's pieces' available moves

      # For each of the other player's pieces
      #{valid_move?(current pos, other king pos)}

  def checkmate?
    false
  end
  # checkmate?(player)
    # Is player's king in checkmate?
    # Is king in check?
    # Can King move to safety?
    # Can any of player's moves block the check?

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
  def get_move
    print "What's your move (ex: 'e2, d4')? "
    gets.chomp.downcase.split(', ')
  end
end

class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def straight_lines(pos)
    x, y = pos
    moves = []
    (0..7).each do |i|
      moves << [x, i]
      moves << [i, y]
    end
    moves
  end

  def diagonal_lines(pos)
    x, y = pos
    moves = []
    (0..7).each do |i|
      moves << [x + i, y + i]
      moves << [x + i, y - i]
      moves << [x - i, y + i]
      moves << [x - i, y - i]
    end
    moves
  end
end

class King < Piece
  def available_moves(pos)
    x, y = pos
    neighbors = [[x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
                 [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
                 [x - 1, y], [x + 1, y]]
  end
end

class Queen < Piece
  def available_moves(pos)
    straight_lines(pos) + diagonal_lines(pos)
  end
end

class Bishop < Piece
  def available_moves(pos)
    diagonal_lines(pos)
  end
end

class Knight < Piece
  def available_moves(pos)
    x, y = pos
    [[x + 2, y + 1], [x + 2, y - 1],
     [x - 2, y + 1], [x - 2, y - 1],
     [x + 1, y + 2], [x + 1, y - 2],
     [x - 1, y + 2], [x - 1, y - 2]]
   end
end

class Rook < Piece
  def available_moves(pos)
    straight_lines(pos)
  end
end

class Pawn < Piece
  def available_moves(pos)
    # Still have to address the diagonal kill case

    x, y = pos
    if self.color == :black
      if x == 1
        [ [x + 1, y], [x + 2, y] ]
      else
        [ [x + 1, y] ]
      end
    elsif self.color == :white
      if x == 6
        [ [x - 1, y], [x - 2, y] ]
      else
        [ [x - 1, y] ]
      end
    end
  end
end

# way of moving
#direction
#how far can they move?

# path(from, to)
# returns an array of positions from from to to
# custom build for each type of piece


game = Chess.new
game.play