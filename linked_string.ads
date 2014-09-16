-- 
-- 
-- Linked String package specification
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

package linked_string is
		-- The linked string type.
		type Lstring is limited private;
		
		-- Returns the length of the Lstring
		function length (Lstr: Lstring) return natural;

		-- Returns an Lstring with the same content as Str.
		function toLstring (Str : String) return Lstring;

		-- Returns a String with the same content as Lstr.
		function toString (Lstr : Lstring) return String;

		-- Read from StdIn to an Lstring.
		procedure Get (Lstr: out Lstring);

		-- Read a line from a file to an Lstring.
		procedure Get (InFile: in File_type; Lstr: out Lstring);

		-- Write an Lstring to StdOut
		procedure Put (Lstr : in Lstring);

		-- Write an Lstring to a file
		procedure Put (OutFile : in file_type; Lstr : in Lstring);

		-- Write an Lstring to StdOut with a final carriage return.
		procedure Put_Line (Lstr : in Lstring);

		-- Write an Lstring to a file with a final carriage return.
		procedure Put_Line (OutFile : in file_type; Lstr : in Lstring);

		-- Concatenate 2 Lstrings with "&"
		function "&" (left, right : Lstring) return Lstring;

		-- Copy Source Lstring to Target.
		procedure copy (Source : in Lstring; Target : out Lstring);

		-- Return an Lstring with a slice from start to finish of Lstr.
		-- Returns a single space in an Lstr of length 1 if finish > start
		-- or if the indices are out of bounds
		function slice (Lstr: Lstring ; start, finish : positive) return Lstring;

		-- Compare two Lstrings for equality; True if their lengths are equal
		-- and they are equal character-by-character.
		function "=" (Left, Right : Lstring) return Boolean;

		-- Returns True if Left comes before Right in dictionary order
		function "<" (Left, Right : Lstring) return Boolean;

		-- Returns True if Left comes after Right in dictionary order
		function ">" (Left, Right : Lstring) return Boolean;
		
		
		
	private
		type Lchar; --nodes
		type Lstring is access Lchar; --pointers
		type Lchar is record
			char : character;
			next : Lstring;
		end record;
		
end linked_string;
