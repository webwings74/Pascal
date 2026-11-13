program HelloWorld;

var
  name: string;
  i: integer;

begin
  WriteLn();
  Write('What is your name? ');
  ReadLn(name);
  WriteLn('Hello, ', name, '!');

  WriteLn();
  WriteLn('--[For-Next Demo]--');
  for i := 1 to 10 do
    WriteLn('Number: ', i);

end.
