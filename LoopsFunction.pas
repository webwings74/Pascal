program LoopsFunction;
// Small demonstration on how to use functions

var
  total, counter: integer;

// Function with a For Loop
function SumWithForLoop(n: integer): integer;
var
  i, sum: integer;
begin
  sum := 0;
  WriteLn('--[For-Loop: Addition]--');
  for i := 1 to n do
  begin
    sum := sum + i;
    WriteLn('Adding ', i, ' -> total = ', sum);
  end;
  SumWithForLoop := sum;
end;

// Function with a While Loop 
function CountDownWithWhileLoop(start, step: integer): integer;
var
  value: integer;
begin
  value := start;
  WriteLn('--[While-Loop: Subtraction]--');
  while value > 0 do
  begin
    value := value - step;
    WriteLn('Subtracting ', step, ' -> counter = ', value);
  end;
  CountDownWithWhileLoop := value;
end;

// Main Program
begin
  total := SumWithForLoop(10);
  WriteLn('Sum 1 to 10 = ', total);

  WriteLn();

  counter := CountDownWithWhileLoop(20, 2);
  WriteLn('Final counter value = ', counter);

end.
