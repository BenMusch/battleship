# This script simulates a game, used as a really shitty manual test
alias Battleship.Game.Ship
alias Battleship.Game.Posn
alias Battleship.Game.Board
board = Board.new

{:ok, a} = Posn.new(1, 2)
{:ok, b} = Posn.new(1, 5)
{:ok, board} = Board.place(board, a, b)

{:ok, a} = Posn.new(0, 7)
{:ok, b} = Posn.new(4, 7)
{:ok, board} = Board.place(board, a, b)

{:ok, a} = Posn.new(7, 9)
{:ok, b} = Posn.new(9, 9)
{:ok, board} = Board.place(board, a, b)

{:ok, a} = Posn.new(5, 5)
{:ok, b} = Posn.new(5, 7)
{:ok, board} = Board.place(board, a, b)

{:ok, a} = Posn.new(0, 0)
{:ok, b} = Posn.new(0, 1)
{:ok, board} = Board.place(board, a, b)

{:ok, guess} = Posn.new(0, 0)
{:hit, board} = Board.guess(board, guess)

{:ok, guess} = Posn.new(0, 1)
{:hit, board} = Board.guess(board, guess)

{:ok, guess} = Posn.new(0, 1)
{:no_hit, board} = Board.guess(board, guess)

{:ok, guess} = Posn.new(0, 3)
{:no_hit, board} = Board.guess(board, guess)
