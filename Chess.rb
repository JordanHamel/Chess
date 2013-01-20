#Jordan Hamel

class Chess

  attr_reader :white_player, :black_player

  def initialize
    @board = Array.new(8) { Array.new(8) }
    populate_board
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
  end

  #board setup
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

  #play the game!
  def play
    while true
      [@white_player, @black_player].each do |player|
        print_board
        from, to = get_move(player)
        move_piece(from, to)
        break if checkmate?(player)
      end
    end

    puts "Game over!"
    checkmate?(@white_player) ? puts("Black wins!") : puts("White wins!")
  end

  #print the board before each move
  def print_board
    # Uses chess unicode characters
    black_visuals = { King => "\u265A",
                Queen => "\u265B",
                Knight => "\u265E",
                Bishop => "\u265D",
                Rook => "\u265C",
                Pawn => "\u265F" }

    white_visuals = { King => "\u2654",
                Queen => "\u2655",
                Knight => "\u2658",
                Bishop => "\u2657",
                Rook => "\u2656",
                Pawn => "\u2659" }

    puts
    print "  "
    puts "CHESS".center(18, '-')

    @board.each_with_index do |row, x|
      print "\n  "
      print "#{(x - 8).abs}| "
      row.each do |piece|
        mark = if piece.nil?
          "*"
        else
          if piece.color == :white
            white_visuals[piece.class]
          elsif piece.color == :black
            black_visuals[piece.class]
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

  ### MOVE FUNCTIONS ###
  def get_move(player)
    while true
      print "#{player.color.to_s.capitalize}'s move (ex: 'e2, d4'): "
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

  def move_piece(from, to)
    # Place on to
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    # Remove from from
    @board[from[0]][from[1]] = nil
  end

  ### FUNCTIONS THAT CHECK FOR VALIDITY OF MOVE ###
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

    # Can you land there?
    if from_piece.class == Pawn
      if from_piece.is_straight?(from, to)
        #can't land on anything
        return false unless to_piece.nil?
      else
        #must land on the other color
        return false if to_piece == player.color || to_piece.nil?
      end
    else
      #'to' check for non-pawns
      unless to_piece.nil?
        return false if to_piece.color == player.color
      end
    end

    # correct piece-type movement
    return false unless from_piece.available_moves(from).include?(to)

    # invalid if there any pieces on the path, except for knights
    unless from_piece.class == Knight
      # returns an array. make sure that everyboard space in the array is nil
      from_piece.path(from, to).each do |pair|
        p pair
        p pair[0]
        return false unless @board[pair[0].to_i][pair[1].to_i].nil?
      end
    end
    # invalid if move puts player's own king in check?
      # How to 'fake' a move? (i.e. if the move is made, is it a check?)
    true
  end

  def on_board?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  ### FUNCTIONS FOR CHECK & CHECKMATE ###
  def check?(player)
    total_valid_possible_moves = []
    player_king_position = []

    # Go through each space on the board
    @board.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        next if piece.nil?
        # Set position of player's King piece
        if piece.class == King && piece.color == player.color
          player_king_position = [x, y]
        end
        if piece.color == player.opponent_color
          # get opponents possible moves
          avail = piece.available_moves
          # convert moves
          avail.map! { |pos| [[x, y], pos] }
          # choose the valid moves
          valids = avail.select { |move| valid_move?(move) }
          # add them to total_valid_possible_moves
          total_valid_possible_moves += valids
        end
      end
    end

    total_valid_possible_moves.include?(player_king_position)
  end

  def checkmate?(player)
    #If players king is in check
    if check?(player)
      #return false if king can move to safety
      return false if can_move_to_safety?(player)
      return false if attack_can_be_blocked?(player)
    end
    true
  end

  def can_move_to_safety?(player)
    #find player's king
    king_pos = nil
    @board.each_with_index do |row, x|
      @baord.each_with_index do |piece, y|
        next if piece.nil?
        if piece.class == King && piece.color == player.color
          king_pos = [x, y]
        end
      end
    end
    #check all neighboring spaces
    piece.available_moves(king_pos).each do |space|
       #return false if any of those spaces are in check
    end
  end

  def attack_can_be_blocked?(player)
    #return true if any piece on the board can 
    #move in the path between the attacker and the king
  end

end

### PLAYER CLASS ###
class Player

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def opponent_color
    self.color == :white ? :black : :white
  end
end

### HUMAN PLAYER ###
class HumanPlayer < Player
  def get_move
    gets.chomp.downcase.split(', ')
  end
end

### PIECE CLASS ###
class Piece

  attr_reader :color

  def initialize(color)
    @color = color
  end

  #defines moving in a straight line
  def straight_lines(pos)
    # Returns an array of all positions on the vertical and
    # horizontal of 'pos'
    x, y = pos
    moves = []

    (0..7).each do |i|
      moves << [x, i]
      moves << [i, y]
    end

    moves
  end

  #defines moving in a diagonal line
  def diagonal_lines(pos)
    # Returns an array of all positions on both diagonals of 'pos'
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

  #returns an array of positions in a straight move
  def straight_path(from, to)
    path = []
    # p "from[0]:"
    # p from[0]
    # p "from[1]: #{from[1]}"
    # p "to[0]: #{to[0]}"
    # p "to[1]: #{to[1]}"

    i = 1

    if to[1] > from[1]
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] + i),from[0]]
        i += 1
      end
    end

    if to[1] < from[1]
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] - i), from[0]]
        i += 1
      end
    end

    if to[0] > from[0]
      (from[0]-to[0]).abs.-(1).times do
        path << [(from[0] + i), to[1]]
        i += 1
      end
    end

    if to[0] < from[0]
      (from[0]-to[0]).abs.-(1).times do
        path << [(from[0] - i), to[1]]
        i += 1
      end
    end
    path 
  end

  #returns an array of positions in a diagonal path
  def diagonal_path(from, to)
    path = []

    i = 1

    if to[0] > from[0] && to[1] > from[1]
      puts "1"
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] - i),from[1 + i]]
        i += 1
      end
    end

    if to[0] < from[0] && to[1] > from[1]
      puts "2"
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] + i),from[1 - i]]
        i += 1
      end
    end

    if to[0] > from[0] && to[1] > from[1]
      puts "3"
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] + i),from[1 + i]]
        i += 1
      end
    end

    if to[0] < from[0] && to[1] < from[1]
      puts "4"
      (from[1]-to[1]).abs.-(1).times do
        path << [(from[1] - i),from[1 - i]]
        i += 1
      end
    end
    path
  end

  #checks to see if a move is a straight line
  def is_straight?(from, to)
    if from[0] == to[0] || from[1] == to[1]
      true
    else
      false
    end
  end

end

class King < Piece
  def available_moves(pos)
    x, y = pos
    neighbors = [[x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
                 [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
                 [x - 1, y], [x + 1, y]]
  end

  def path(from, to)
    nil
  end
end

class Queen < Piece
  def available_moves(pos)
    straight_lines(pos) + diagonal_lines(pos)
  end

  def path(from, to)
    is_straight?(from, to) ? straight_path(from, to) : diagonal_path(from, to)
  end
end

class Bishop < Piece
  def available_moves(pos)
    diagonal_lines(pos)
  end

  def path(from, to)
    diagonal_path(from, to)
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

  def path(from, to)
    straight_path(from, to)
  end

end

class Pawn < Piece
  def available_moves(pos)
    x, y = pos
    if self.color == :black
      moves = [ [x + 1, y], [x + 1, y + 1], [x + 1, y - 1] ]
      moves << [x + 2, y] if x == 1
    elsif self.color == :white
      moves = [ [x - 1, y], [x - 1, y + 1], [x - 1, y - 1]  ]
      moves << [x - 2, y] if x == 6
    end
    moves
  end

  def path(from, to)
    straight_path(from, to)
  end

end

#scripth to start a new game
game = Chess.new
game.play
