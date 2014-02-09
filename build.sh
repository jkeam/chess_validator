#!/bin/bash

tar -cvf jkeam_chess_validator.tar spec Rakefile inputs driver.rb lib run.sh README.md 
gzip jkeam_chess_validator.tar
mv jkeam_chess_validator.tar.gz dist
echo "Done!"
