-- 
-- 
-- Linked String package body
-- Provides the linked string type,
-- 'Lstring', which can be manipulated
-- more easily than Ada's fixed-length
-- strings in some cases.
--
-- Date : May 22, 2013
--
-- Author: Dan Baron
--
--
--
--

with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;

package body linked_string is
	Index_Error, LString_Length_Error: exception;	
-----------------------------------------------------	
	-- function Length
	-- purpose:	returns the number of characters in the string
	function Length (Lstr: Lstring) return natural is
    begin
    	--Base Case
    	If Lstr = null then
    		return 0;
    	
    	-- Recursive Step
    	else
    		return 1+Length( Lstr.Next );
    	end if;
    end Length;
-----------------------------------------------------
	-- function toLstring
	-- Purpose: returns an Lstring containing the same text
	-- as the input String.	
	function toLstring (Str : String) return Lstring is
		Lstr : Lstring := new Lchar;
	begin
		-- Base case, Str'Length = 1.
		Lstr.all.char := Str( Str'First );
		
		-- Recursive step
		if Str'Length > 1 then
			Lstr.all.Next := toLstring( Str(Str'First+1 .. Str'Last) );
		end if;
		
		return Lstr;
	end toLstring;
-----------------------------------------------------
	-- Function at_least_1
	-- Purpose: returns the greater of 1 and num.
	-- Useful when a variable declaration
	-- needs a positive integer.
	function at_least_1 (num : integer) return positive is
	begin
		if num >=1 then
			return num;
		else
			return 1;
		end if;
	end at_least_1;
-----------------------------------------------------	
	-- function ToString
	-- Purpose: Returns a String with the same content
	-- as Lstr.	
	function ToString (Lstr : Lstring) return String is
		-- The return string. Base case, length(Lstr) = 1.
		-- We use the at_least_1 function here in case
		-- length(Lstr) = 0.
		Str : String ( 1..at_least_1(Length( Lstr )) )
					:= (1 => Lstr.char, others => ' ');
	begin
		if Length(Lstr) = 0 then
			-- No such thing as a string of length 0!
			raise LString_Length_Error;
		else
			-- Recursion
			if Str'Length > 1 then
				Str( 2..Str'Last ) := toString( Lstr.Next );
			end if;
			return Str;
		end if;
	end toString;
-----------------------------------------------------
	-- Procedure Get [from STDIN]
	-- Purpose: Gets text from Standard Input
	-- and returns it as an Lstring.
	procedure Get (Lstr: out Lstring) is
		Str : String (1..100);
		Last : positive;
	begin
		-- Use text_io to get a string, then convert.
		get_line(item => Str, Last => Last);
		Lstr := toLstring( Str(1..Last) );
	end Get;
-----------------------------------------------------
	-- Procedure Get [from file]
	-- Purpose: Gets a line of text from InFile
	-- and returns it as an Lstring.
	procedure Get (InFile: in File_type; Lstr: out Lstring) is
		Str : String (1..100);
		Last : positive;
	begin
		-- Use text_io to get a string, then convert.
		get_line(item => Str, Last => Last, file => InFile);
		Lstr := toLstring( Str(1..Last) );
	end Get;
-----------------------------------------------------	
	-- Procedure Put [to STDOUT]
	-- Purpose: Write the text from Lstr to Standard Output
	procedure Put (Lstr : in Lstring) is
	begin
		-- Convert to String and use text_io
		put( ToString(Lstr) );
	end Put;
-----------------------------------------------------	
	-- Procedure Put [to file]
	-- Purpose: Write the text from Lstr to the file 'OutFile'.
	procedure Put (OutFile : in file_type; Lstr : in Lstring) is
	begin
		-- Convert to String and use text_io
		put( item=> ToString(Lstr), file => OutFile );
	end put;
-----------------------------------------------------	
	-- Procedure Put_line [To STDOUT]
	-- Purpose:	Write the Lstr to Standard Output
	-- and conclude with a new line.
	procedure Put_Line (Lstr : in Lstring) is
	begin
		-- Convert to String and use text_io
		put_line( ToString(Lstr) );
	end Put_line;
-----------------------------------------------------
	-- Procedure Put_line [To file]
	-- Purpose:	Write the Lstr to OutFile
	-- and conclude with a new line.
	procedure Put_Line (OutFile : in file_type; Lstr : in Lstring) is
	begin
		-- Convert to String and use text_io
		put_line( item=> ToString(Lstr), file => OutFile );
	end put_line;
-----------------------------------------------------
	-- Function "&"
	-- Purpose: Allows use of & operator to concatenate Lstrings.
	function "&" (Left, Right : Lstring) return Lstring is
		Lstr : Lstring := new Lchar;
	begin
		-- Base case, Left is null.
		if Left = null then
			return Right;
		
		-- Recursive step
		else
			Lstr.all := Left.all;
			Lstr.Next := (Left.Next & Right);
			Return Lstr;
		end if;
	end "&";
-----------------------------------------------------	
	-- Procedure Copy
	-- Purpose:	Copies Source Lstring to Target Lstring.
	procedure copy (Source : in Lstring; Target : out Lstring) is
	begin
		Target := Source;
	end copy;
-----------------------------------------------------	
	-- Function Slice
	-- Purpose: Creates and returns NewLstring,
	-- a slice from index 'start' to index 'finish'
	-- of Lstr.
	function Slice (Lstr: Lstring ; start, finish : positive) return Lstring is
		newLstr : Lstring := new Lchar;
	begin
		-- Invalid indices, just return a space.
		if finish > length( Lstr ) or start > finish then
			NewLstr.all := (' ', null);

		-- Recursion on start and on finish.
		elsif start = 1 then
			NewLstr.char := Lstr.char;
			if finish > 1 then
				NewLstr.Next := ( Slice(Lstr.Next, 1, finish-1) );
			end if;
		else
			NewLstr := Slice( Lstr.Next, start-1, finish-1 );
		end if;
		
		return NewLstr;		
	end Slice;
-----------------------------------------------------		
	-- Function "="
	-- Purpose: allows equality testing between Lstrings.
	function "=" (Left, Right : Lstring) return Boolean is
		-- These booleans will be true if left or right is 'null'.
		rightnull, leftnull: boolean := False;
		
		--Used to test whether each Lstring is null
		Char : Character;
	begin
		-- If left = null then Left.Char is empty
		begin
			Char := Left.Char;
			exception
				-- Left.Char doesn't exist!
				when Constraint_Error =>
					leftnull := True;
		end;
		-- If right = null then Right.Char is empty
		begin
			Char := Right.Char;
			exception
				-- Right.Char doesn't exist!
				when Constraint_Error =>
					rightnull := True;
		end;
				
		if leftnull and rightnull then
			-- 2 nulls are equal, base case 1.
			return True;
		elsif leftnull or rightnull then
			-- null is unequal to not-null, base case 2.
			return False;
		else
			-- recursive step:
			-- The "tails" of the lists must compare equal,
			-- and the characters at the heads of the lists
			-- must also be equal.
			return ((Left.Next = Right.Next) and 
					Left.Char = Right.Char);
		end if;
	end "=";
-----------------------------------------------------	
	-- Function "<"
	-- Purpose: Allows < operator.
	-- True if Left comes before Right in dictionary order.
	-- False otherwise.
	function "<" (Left, Right : Lstring) return Boolean is
	begin
		-- Convert to strings and use Ada's built-in
		-- string comparison.
		return ToString(Left) < ToString(Right);
	end "<";
-----------------------------------------------------	
	-- Function ">"
	-- Purpose: Allows > operator.
	-- True if Left comes after Right in dictionary order.
	-- False otherwise.
	function ">" (Left, Right : Lstring) return Boolean is
	begin
		-- Convert to strings and use Ada's built-in
		-- string comparison.
		return ToString(Left) > ToString(Right);
	end ">";
-----------------------------------------------------		
end linked_string;
