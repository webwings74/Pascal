# Start Nix Shell with Free Pascal compiler and Lazarus GUI
echo -e "\nStart Free Pascal and Lazarus: \n * fpc <file.pas> \n * startlazarus (for GUI)"
nix-shell -p fpc lazarus gdb

