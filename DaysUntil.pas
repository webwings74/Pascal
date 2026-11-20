program DaysUntil;
// Calculates the number of days and nights from today to a given date.
// The date can be typed in the format of the computer's locale (e.g. 25-12-2026
// for nl_NL, 25.12.2026 for de_DE) or in ISO format (2026-12-25).
// Usage: ./DaysUntil 25-12-2026   (or run without argument and type the date)

{$mode objfpc}

uses
  {$IFDEF UNIX}
  clocale,   // must be first: loads date format and names from the system locale
  {$ENDIF}
  SysUtils, DateUtils;

var
  input: string;
  target, today: TDateTime;
  diff: integer;

// Parse a date in ISO format YYYY-MM-DD, returns False if invalid
function ParseIsoDate(const s: string; out d: TDateTime): boolean;
var
  y, m, dd: integer;
begin
  Result := False;
  if (Length(s) <> 10) or (s[5] <> '-') or (s[8] <> '-') then
    Exit;
  if not TryStrToInt(Copy(s, 1, 4), y) then Exit;
  if not TryStrToInt(Copy(s, 6, 2), m) then Exit;
  if not TryStrToInt(Copy(s, 9, 2), dd) then Exit;
  Result := TryEncodeDate(y, m, dd, d);
end;

// Parse a date: first try ISO, then the locale's short date format
function ParseDate(const s: string; out d: TDateTime): boolean;
begin
  Result := ParseIsoDate(s, d) or TryStrToDate(s, d, DefaultFormatSettings);
end;

// Main Program
begin
  if ParamCount >= 1 then
    input := ParamStr(1)
  else
  begin
    Write('Enter a date (', DefaultFormatSettings.ShortDateFormat, ' or YYYY-MM-DD): ');
    ReadLn(input);
  end;

  if not ParseDate(Trim(input), target) then
  begin
    WriteLn('Invalid date: "', input, '". Use the format ',
            DefaultFormatSettings.ShortDateFormat, ' or YYYY-MM-DD.');
    Halt(1);
  end;

  today := Date;   // today's date, without the time part
  diff := Trunc(target) - Trunc(today);

  // 'ddddd' = short date in locale format, day and month names come from the locale
  WriteLn('Today       : ', FormatDateTime('ddddd (dddd d mmmm yyyy)', today));
  WriteLn('Target date : ', FormatDateTime('ddddd (dddd d mmmm yyyy)', target));
  WriteLn();

  if diff = 0 then
    WriteLn('That is today!')
  else if diff > 0 then
  begin
    WriteLn('Days to go          : ', diff);
    WriteLn('Nights to sleep     : ', diff);
    WriteLn('Days incl. both ends: ', diff + 1);
    WriteLn('Weeks (approx.)     : ', diff div 7, ' weeks and ', diff mod 7, ' days');
  end
  else
  begin
    WriteLn('That date was ', -diff, ' days (', -diff, ' nights) ago.');
  end;
end.
