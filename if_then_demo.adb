--Daniel Baron
--This program asks the user for his or her
--month and year of birth
--and then determines, using clever if statements,
--whether the user is of legal drinking age.


with ada.text_io;
with ada.integer_text_io;
use ada.Text_IO;
use ada.Integer_Text_IO;


PROCEDURE if_then_demo IS

	month : natural;
	year  : natural;
	age   : natural;


BEGIN
	-- Ask for the birth month.
	put(item=> "In what month (e.g. 10 for October) were you born? ");
	 get(item=> month);
	NEW_LINE;

	-- Ask for the birth year.
	put(item=> "In what year (e.g. 1927) were you born? ");
	 get(item=> year);
	NEW_LINE;

	--Determine applicant's age,
	--as of January 31, 2013.
	age := 2013 - year;
	if month > 1 then
		age := age - 1;
	end if;

	--Is the applicant of age?
	if age >= 21 then
		put_line(item=>"Congratulations! Allow me to pour you a drink.");
	else
		put_line(item=>"Sorry, kid. Milk for you.");
	end if;

end if_then_demo;
