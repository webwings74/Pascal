program Loops;

var
  i, total, counter: integer;

begin
  total := 0;

  // For Loop demonstration
  WriteLn('--[For-Loop: Addition]--');
  for i := 1 to 10 do
  begin
    total := total + i;
    WriteLn('Adding ', i, ' -> total = ', total);
  end;
  WriteLn('Sum 1 to 10 = ', total);

  WriteLn();

  counter := 20;

  // While Loop demonstration
  WriteLn('--[While-Loop: Subtraction]--');
  while counter > 0 do
  begin
    counter := counter - 2;
    WriteLn('Subtracting 2 -> counter = ', counter);
  end;
  WriteLn('Final counter value = ', counter);

end.
