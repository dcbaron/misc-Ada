-- hanoi.adb
-- A program to output the number of moves necessary to solve
-- the Towers of Hanoi puzzle for a range of numbers of discs.
--
-- The program will optionally also output the full puzzle solution.
--
-- Author: Daniel Baron
-- Date: April 20, 2013

WITH Ada.Text_Io, Ada.Integer_Text_IO, Ada.Command_Line;
USE  Ada.Text_Io, Ada.Integer_Text_IO, Ada.Command_Line;

PROCEDURE Hanoi IS

   min_size : Positive  := 3;	--The lower bound on the puzzle size
   									--with a default value.
   max_size : Positive; --The upper bound.
   verbose  : Boolean;  --'True' if user wants verbose mode.
   Src, Dest, Aux  : Character;	--Names for the Source, Destination
   										--and Auxiliary pegs.
   last : positive;	-- A required parameter string-to-integer conversion;
   						-- not actually used.

   -- procedure Move
   -- purpose:	display the disc movements in solving the Towers of Hanoi
   -- parameters:
   --		NumDiscs			: the number of discs to be moved
   --		Source			: the peg from which the discs are to be moved
   --		Destination		      : the final destination of the discs
   --          Auxiliary		      : the peg to be used for intermediate storage
   PROCEDURE Move (
         NumDiscs    : IN     Positive;
         Source,
         Destination,
         Auxiliary   : IN     Character) IS
   BEGIN
      -- the base case, only one disc to be moved
      IF NumDiscs = 1 THEN
         Put_Line("Move disk from peg " & Source &
            " to peg " & Destination);

         -- the general case
      ELSE
         Move(NumDiscs-1, Source, Auxiliary, Destination);
         Move(1, Source, Destination, Auxiliary);
         Move(NumDiscs-1, Auxiliary, Destination, Source);

      END IF;
   END Move;

-- Function CountMoves
   -- purpose:	Solve the puzzle quietly and return the number of moves.
   -- parameters:
   --		NumDiscs			: the number of discs to be moved
   --		Source			: the peg from which the discs are to be moved
   --		Destination		      : the final destination of the discs
   --          Auxiliary		      : the peg to be used for intermediate storage
   FUNCTION CountMoves (
         NumDiscs    : IN     Positive;
         Source,
         Destination,
         Auxiliary   : IN     Character) Return positive IS
   	Counter : positive :=1; --Counts the number of moves
   BEGIN
      -- the base case, only one disc to be moved
      IF NumDiscs = 1 THEN
         Return Counter;

         -- the general case
      ELSE
         --Sum up the moves recursively
         Counter := CountMoves(NumDiscs-1, Source, Auxiliary, Destination) +
								CountMoves(1, Source, Destination, Auxiliary) +
								CountMoves(NumDiscs-1, Auxiliary, Destination, Source);
			Return counter;
      END IF;
   END CountMoves;

BEGIN  -- hanoi

   begin
		--Get the minimum number of discs from the first command line argument
		If Argument_Count > 0 Then
			Get(from => Argument(1), item => min_size, last => last);
		end if;

		--Or ignore the argument if it isn't an integer
		exception
			when Data_Error =>
				null;
	end;

	begin
		-- Get the upper bound from the second command line argument
		If Argument_Count > 1 Then
			Get(from => Argument(2), item => max_size, last => last);

		--Or just set it equal to min_size
		Else
			max_size:=min_size;
		end if;

		--And ignore bad arguments
		exception
			when Data_Error =>
				max_size := min_size;
	end;

	--If the third argument is 'v' or 'V', use verbose mode.
	If Argument_Count > 2 then
		If Argument(3)(1) = 'v' or Argument(3)(1) = 'V' then
			verbose := True;
		end if;
	end if;

	--Name the pegs
	Src := 'S';
   Dest := 'D';
   Aux := 'A';

	--For each number of discs in the user's desired range
	For size in min_size..max_size loop
		if verbose then
			put("To solve the Towers of Hanoi with ");
   		put(size,width=>1);
   		put_line(" discs:");

   		-- solve the puzzle, print the instructions of disc movements
   		Move(Size, Src, Dest, Aux);

   		new_line(2);
		else
			-- solve the puzzle and print only the number of moves.
			put("Solved the puzzle with ");
			put(size, width =>1);
			put(" discs in ");
			put( CountMoves(Size, Src, Dest, Aux), width =>1 );
			put_line(" moves.");
		end if;
	end loop;
end hanoi;
