program HelloWorld;

var
  naam: string;
  i: integer;

begin
  WriteLn();
  Write('Hoe heet je? ');
  ReadLn(naam);
  WriteLn('Hallo, ', naam, '!');

  WriteLn();
  WriteLn('--[For-Next Demo]--');
  for i := 1 to 10 do
    WriteLn('Getal: ', i);

end.
