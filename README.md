# Puzzle Node #13 Solution

This is a solution for the [puzzle node question 13](http://www.puzzlenode.com/puzzles/13-chess-validator).

## Usage

### To run the script

```shell
    ./driver.rb [board_filename] [move_filename]
```

As an example, see the run.sh.


### To run the tests

```shell
    rake test
```

## File Structure

```
.
+-- inputs
|   +-- complex_board.txt
|   +-- complex_moves.txt
|   +-- simple_board.txt
|   +-- simple_moves.txt
+-- lib
|   +-- chess_validator.rb
|   +-- piece_util.rb
+-- spec
|   +-- fixture
|       +-- complex_board.txt
|       +-- complex_moves.txt
|       +-- simple_board.txt
|       +-- simple_moves.txt
|       +-- chess_validator_spec.rb
+-- driver.rb
+-- Rakefile
+-- README.md
+-- run.sh
```

1.  inputs    - sample input files
2.  lib       - contains the validators that has all the logic
3.  spec      - simple spec tests
4.  driver.rb - the main ruby script that calls the validator
5.  run.sh    - example of how to call the driver
6.  Rakefile  - configures minitest
7.  README.md - this file
