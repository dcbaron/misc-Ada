--Daniel Baron
--This program asks the user for a positive integer
--and finds the sum of all the positive integers
--less than or equal to the input value.
--It does this iteratively first, and then
--confirms the iterative value using the formula,
-- (1 + 2 + ... + n) = n(n+1)/2.

with ada.text_io;
with ada.integer_text_io;
use ada.Text_IO;
use ada.Integer_Text_IO;


PROCEDURE loop_demo IS

	num   : natural;
	count : natural := 0;
	sum   : natural := 0;


BEGIN
	-- Begin by asking for the number
	put_line(item=> "Give me a number, and I'll sum all the numbers");
	put(item=> "from 1 through your value.  ");
	get(item=> num);
	NEW_LINE;

	-- Sum up the integers one by one.
	while count < num loop
		count := count + 1;
		sum := sum + count;
	end loop;

	put(item=> "Your sum, calculated iteratively, is ");
	put(item=> sum, width => 1);
	put_line(item=> ".");

	-- Calculate the sum using the formula.
	sum := (num * (num + 1))/ 2;
	put(item=> "Your sum, calculated using the formula, is ");
	put(item=> sum, width => 1);
	put_line(item=> ".");

end loop_demo;
