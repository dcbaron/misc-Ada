--------------------------------------------------------------------
--
-- program: case_converter

-- purpose:
-- command line arguments:
-- 1. 'U', 'u', 'L', 'l' to specify to uppercase or to lowercase
-- 2. (optional) name of file to be used for input
-- 3. (optional) name of file to be used for output
-- Author:	Daniel Baron
-- Date:		April 12, 2013
--------------------------------------------------------------------
WITH Ada.Text_IO, Ada.Command_Line;
USE  Ada.Text_IO, Ada.Command_Line;


PROCEDURE Case_Converter IS

   Argument_Error 	:	EXCEPTION; 					-- the exception raise for bad command-line arguments
   Input, Output  	:	File_Type;					-- input and output files, if specified
   uppercase_bool 	:	boolean;						-- True if the program is to do uppercase, false otherwise.
	Ch             	:	character;					-- Sequentially holds the characters from the input.
	Standard_In_Bool	:	boolean;						-- Records whether we are accepting text from Standard_input;
											  					-- 		will be used to end the input loop in that case.
	Quit_Sequence		: string(1..5) := "\quit";	-- The command to terminate the input loop.
	Quit_position		: natural :=1;					-- The quit_sequence will be read character-by-character.
																-- 		This variable records the next position in the sequence.

   -- function is_uppercase
   -- purpose:to determine whether the program is to do uppercase or lowercase
   -- raises argument error if neither option specified
   -- Ada.Command_Line.Argument(1) returns the first command argument as a string
   -- Ada.Command_Line.Argument(2) returns the second command argumetn as a string... so on and so forth.

   FUNCTION Is_Uppercase RETURN Boolean IS
   BEGIN
      IF Argument(1)(1) = 'U' OR Argument(1)(1) = 'u' THEN
         RETURN True;
      ELSIF Argument(1)(1) = 'L' OR Argument(1)(1) = 'l' THEN
      	RETURN False;
      ELSE
         RAISE Argument_Error;
      END IF;
   END Is_Uppercase;

   -- function to_upper
   -- purpose: convert a lower-case character to upper-case
   -- all other characters are returned unchanged

   FUNCTION To_Upper(Ch : IN Character) RETURN Character IS
   	upper_position : natural	;
   	return_Ch 		: character ;
   BEGIN
	   if Ch >= 'a' and Ch <= 'z' then
			-- find the current character in the list
			-- and shift by 32 to change case.
			upper_position := Character'Pos(Ch) - 32;
			return_Ch := Character'Val(upper_position);
		else
			return_Ch := Ch;
		end if;
		return return_Ch;
   END To_Upper;


   -- function to_lower
   -- purpose: convert an upper-case character to lower-case
   --	all other characters are returned unchanged
   FUNCTION To_Lower(Ch : IN Character) RETURN Character IS
   	lower_position : natural;
		return_Ch 		: character ;
   BEGIN
	   if Ch >= 'A' and Ch <= 'Z' then
			-- find the current character in the list
			-- and shift by 32 to change case.
			lower_position := Character'Pos(Ch) + 32;
			return_Ch := Character'Val(lower_position);
		else
			return_Ch := Ch;
		end if;
		return return_Ch;
   END To_Lower;

	-- Procedure finish_up
   -- purpose: close files and print a pleasing exit message.
	PROCEDURE finish_up (Input, Output: IN OUT File_Type) IS
	BEGIN
		New_Line(2); -- output two new lines

   	-- Print an exit message to the terminal.
   	set_output(Standard_Output);
		put("Thanks for using Case Converter, a program by Dan Baron.");
		New_Line(2);

		-- close files, if necessary
		IF Is_Open(Input) THEN
		   Close(Input);
		END IF;

		IF Is_Open(Output) THEN
		   Close(Output);
		END IF;
	END finish_up;

BEGIN
   -- if the number of command line arguments is less than 1, raise an argument error
   If Argument_Count < 1 THEN
   	raise argument_error;
   end if;

   -- if there is a 2nd command-line argument use that file instead of standard input
   IF Argument_Count > 1 THEN
      Open(Input, In_File, Argument(2));
      Set_Input(Input);
      standard_in_bool := False;
   else
   	--If we are using standard input, enable a command
   	--    for the user to enter in order to quit the program.
   	standard_in_bool := True;
   	put_line("Please enter your text to be converted;");
   	put_line("when you are finished, type \quit (all lower case).");
   END IF;

   -- if there is a 3rd command-line argument use that file instead of standard output
   IF Argument_Count > 2 THEN
      Create(Output, Out_File, Argument(3));
      Set_Output(Output);
   END IF;

   -- determine whether uppercase conversion or lowercase conversion
	uppercase_bool := Is_Uppercase;

   -- reading each character
   WHILE NOT End_Of_File LOOP

      -- deal with line feed character
      IF End_Of_Line THEN
         New_Line;  --New_Line procedure is supposed to take one parameter.
                    --in the case of no parameter, the default parameter 1
                    --(that has already been specified in the procedure definition) will be used.
      END IF;  -- for line feed character

      -- read the current character
      Get(Ch);

      --End the program if the user types \quit
      --(Otherwise, when reading from standard input,
      --the program will keep accepting new inputs
      --and never end).
      If standard_in_bool then
		   If Ch = Quit_sequence(Quit_position) then
		   	Quit_position := Quit_position + 1;
		   	exit when Quit_position = 6;
		   else
		   	Quit_position := 1;
			end if;
		end if;

      -- if the character is alphabetic, do the case conversion
		if uppercase_bool then
			Ch := to_upper(Ch);
		else
			Ch := to_lower(Ch);
		end if;

      -- output the character
      Put(Ch);

   END LOOP; -- for each character

	--Prepare to end the program.
	finish_up(Input, Output);

EXCEPTION
   WHEN Name_Error => -- The input file can't be read.
      Put_Line("The file " & Argument(2) & " cannot be used for input");

	WHEN Argument_Error => -- Bad command line arguments.
		Put_Line("Usage: case_converter U|L [infile [outfile]]");

	WHEN End_Error => -- Caused by unix-style line-endings
							--		when there is an empty line at the end
							-- 	of an input file. All *text* will have
							-- 	already been handled correctly, so
							-- 	we can simply ignore this error.
		finish_up(Input, Output);


END Case_Converter;
