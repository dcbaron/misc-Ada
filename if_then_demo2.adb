--Daniel Baron
--This program asks the user for the model year
--of his or car, then classifies the car by
--age category: antique, classic, late model, or boring.


with ada.text_io;
with ada.integer_text_io;
use ada.Text_IO;
use ada.Integer_Text_IO;


PROCEDURE if_then_demo2 IS

	year_age   : natural;

BEGIN
	-- Begin by asking for the model year
	put(item=> "In what year was your car made?  ");
	get(item=> year_age);
	NEW_LINE;

	-- Subtract the model year from the current year
	-- to obtain the car's age.
	year_age := 2013-year_age;


	IF year_age >= 50 then
		put_line(item=> "Your car is an antique!");
	elsif year_age > 30 then
		put_line(item=> "Your car is a classic.");

	--We want cars made in the last three years, so
	--the age should be strictly less than 3
	elsif year_age < 3 then
		put_line(item=> "Cool, a late model car.");
	else
		put_line(item=> "Gee, what a boring car.");
	end if;
end if_then_demo2;
