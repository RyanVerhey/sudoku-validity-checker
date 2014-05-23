class Sudoku

  attr_reader :board

  def initialize
    @board = make_board
  end

  def start
    get_input
  end

  private

  def make_board
    (1..9).inject([]) { |arr,x| arr << ["-","-","-","-","-","-","-","-","-"] }
  end

  def get_input
    puts "Please type (row):(column) number"
    input = gets.chomp!
    coords = input[/\d\:\d/].split(":")
    coord_hash = { row: (coords[0].to_i - 1), col: (coords[1].to_i - 1) }
    num = input[/\d$/]
    input_hash = { coords: coord_hash, num: num.to_i }
    check_validity(input_hash)
  end

  def check_validity(input_hash)
    if col_valid?(input_hash) && row_valid?(input_hash) && cube_valid?(input_hash)
      add_to_board(input_hash)
      print_board
      get_input
    else
      puts "Invalid"
      print_board
      get_input
    end
  end

  def col_valid?(input_hash)
    col_num = input_hash[:coords][:col]
    col = get_col(col_num)
    !col.include? input_hash[:num]
  end

  def get_col(col_num)
    self.board.inject([]) { |arr, row| arr << row[col_num] }
  end

  def row_valid?(input_hash)
    row = get_row(input_hash[:coords][:row])
    !row.include? input_hash[:num]
  end

  def get_row(row_num)
    row = self.board[row_num]
  end

  def cube_valid?(input_hash)
    cube = get_cube(input_hash[:coords])
    !cube.include? input_hash[:num]
  end

  def get_cube(coords)
    row = coords[:row]
    col = coords[:col]
    cube_num = ((row / 3) + (col / 3)) + (row / 3)*(2) # Assigns each 3 x 3 cube a number, 0..8
    cube_start = cube_num + (cube_num * 2) # Finds the element number
    ranges = [(0..2), (3..5), (6..8)]
    cube = []
    # Goes through the ranges. If one of them includes the cube number, goes through again.
    ranges.each do |range1|
      if range1.include? cube_num
        ranges.each do |range2|
          # If a range includes the column number, it goes through the range that inludes the cube number.
          if range2.include? col
            # It goes through the rows that are in the cube, and makes populates the cube with the
            # numbers that are in the columns that are in the cube
            range1.each do |row|
              cube << @board[row][range2]
            end
          end
        end
      end
    end
    cube.flatten
  end

  def add_to_board(input_hash)
    coords = input_hash[:coords]
    @board[coords[:row]][coords[:col]] = input_hash[:num]
  end

  def print_board
    @board.each do |row|
      row_string = row.join(" ")
      puts row_string
    end
  end
end

game = Sudoku.new

game.start
