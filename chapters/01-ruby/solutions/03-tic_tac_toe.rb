class Board
  attr_reader :board

  def initialize
    @board = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def free_field(num)
    x, y = number_to_coordinates(num)
    @board[y][x].nil?
  end

  def get_field(num)
    x, y = number_to_coordinates(num)
    @board[y][x]
  end

  def set_field(num, symbol)
    x, y = number_to_coordinates(num)
    @board[y][x] = symbol
  end

  def number_to_coordinates(num)
    x = num % 3
    y = num / 3

    [x, y]
  end

  def size
    @board.size * @board.first.size
  end

  def render
    i = 0

    @board.each do |row|
      row.each do |cell|
        print "[ #{cell || i} ] "
        i += 1
      end
      print "\n"
    end
  end
end

def get_user_move
  print 'Where do you want to put a circle [0 - 8]? '
  gets.chomp.to_i || 0
end

board = Board.new
player = 'O'

loop do
  puts
  board.render

  puts "Player '#{player}' move."
  move = get_user_move

  if board.free_field(move)
    puts "Set '#{player}' to field #{move}"
    board.set_field(move, player)
  else
    puts 'That field is already occupied! Try again.'
    next
  end

  if player == 'O'
    player = 'X'
  else
    player = 'O'
  end
end
