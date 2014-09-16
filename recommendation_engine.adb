--
-- Music Recommendation System --
-- This program reads the music survey
-- data from text files and finds students
-- who are similar to each other or generates
-- recommendations for new bands.


WITH ada.text_io;
USE ada.text_io;
WITH ada.integer_text_io;
USE ada.integer_text_io;



PROCEDURE recommendation_engine IS

   --CONSTANTS
   stringSize    : CONSTANT natural := 30;
   numBands      : CONSTANT natural := 20;
   numStudents   : CONSTANT natural := 4;
   MinSimilarity : CONSTANT Integer := - 25 * NumBands;

   -- minSimilarity is the most negative number you could get when
   -- calculating the similarity score
   TYPE band IS
      RECORD
         bandName     : string (1 .. stringSize);
         bandNameSize : natural;                           -- holds size of bandName
   END RECORD;

   SUBTYPE ChoiceRange IS Integer RANGE 1..4;
   Choice : ChoiceRange;


   SUBTYPE bandRange IS integer RANGE 1..numBands;
   TYPE bandArray IS ARRAY(bandRange) OF band;
   B : bandArray;


   SUBTYPE ClassRange IS Integer RANGE 1..NumStudents;

   type dotP_array is array(classrange) of integer;
   TYPE allDotpArray IS ARRAY(classrange) of dotP_array;
	allDotp : allDotpArray;  -- The dot products of the student for whom the particular
               -- Dot_Products is named with all the students in the class,
               -- in the same order as the student records in the big array.


   TYPE musicSurveyArray IS ARRAY(bandRange) OF integer;

   TYPE student IS
      RECORD
         stuName     : string(1 .. stringSize);
         stuNameSize : natural;                  -- holds size of name
      MusicSurvey : MusicSurveyArray;

      END RECORD;

   TYPE classArray IS ARRAY(classRange) OF student;
   C : classArray;

   InData           : Ada.Text_Io.File_Type;
   UserName         : String( 1 .. Stringsize);
   UserNum          : Classrange;
   similarUser      : Classrange;
   Opinionated      : Natural :=0;

   -- **************************************************************************
   -- PRE: The file TESTbands.txt should be in the same directory as the program file
   -- Post: Writes each band's name and nameSize to the bandarray 'B'.

   PROCEDURE readBandFile (
         B :    OUT bandArray) IS

   BEGIN
      ada.text_io.open(inData,ada.text_io.in_file,"TESTbands.txt");
      new_line;

      FOR i IN bandRange LOOP
         get_line(inData, B(i).bandName, B(i).bandNameSize);
      END LOOP;
      ada.text_io.close(inData);
   END readBandFile;

   -- **************************************************************************
-- PRE: The file TESTmusicSurvey.txt should be in the same directory as the program file
-- POST: Populates classArray with student records, each with a StuName and StuNameSize.

   PROCEDURE readSurveyFile (
         C :    OUT classArray) IS

   BEGIN
      ada.text_io.open(inData,ada.text_io.in_file,"TESTmusicSurvey.txt");
      new_line;

      FOR i IN classRange LOOP
         get_line(inData, C(i).stuName, C(i).stuNameSize);
         FOR j IN bandRange LOOP
            get(inData,C(i).musicSurvey(j));
         END LOOP;
         skip_line(inData);
         -- because we're transitioning from get to get_line
      END LOOP;
      ada.text_io.close(inData);
   END readSurveyFile;

  -- *****************************************************************************
-- PRE: I is the index of the student whose dotproducts we want, C is the classArray.
-- POST: returns a Dotp_array containing the dotproduct of student I with each
-- student in C. The index of (student I) dot (student J) is J in student I's array.

   FUNCTION Dotp_Func(I : Classrange; C : classarray) RETURN Dotp_array IS
       dotp : Dotp_array;
   BEGIN
      FOR J IN Classrange LOOP
         Dotp(J) := 0;
            FOR K IN Bandrange LOOP
               Dotp(J) := Dotp(J) + C(J).Musicsurvey(K) *
                                     C(I).Musicsurvey(K);
            END LOOP;
      END LOOP;
      RETURN Dotp;
   END Dotp_Func;

   -- *****************************************************************************
-- PRE: This is the first interaction with the user.
-- POST: Function outputs the menu where user enters choice for program to run.
   FUNCTION UserMenu RETURN ChoiceRange IS

      Choice : ChoiceRange;

   BEGIN

      Put_line("***************************************************");
      Put_Line("    Welcome to the CS 141 Music Recommendation System");
      Put_Line("***************************************************");
      Put_Line("Choices: ");
      Put_Line("     1. Enter a user ID and find a user with similar taste");
      Put_Line("     2. Find the userID with the most opinionated ratings");
      Put_Line("     3. Get a recommendation for a new band");
      put_line("     4. Exit Music Recommendation System.");
      New_Line;
      Put("Enter your choice: ");
      Get(Choice);
      RETURN Choice;

      EXCEPTION
         WHEN Constraint_Error | Data_Error =>
            Put_Line(" Sorry, that was not a valid menu option.");
            skip_line;
            new_line(2);
            Choice := UserMenu;
            Return choice;

   END UserMenu;

 -- *****************************************************************************
-- PRE:  The array allDotp should hold each student's individual array of dotproducts
-- wih the student's in the class. UserNum is the index of the student for whom
-- we want to find the most similar user.
-- POST: Compares the student's dotproducts with each of the other students and finds the
-- highest value; this is the dotproduct with most similar person. Returns that
-- person's index.
   FUNCTION MostSimilar (allDotp : allDotparray; UserNum : ClassRange) RETURN ClassRange IS
      BestMatch : Integer := MinSimilarity;
      BestStudent  : Classrange;

   BEGIN
      FOR I IN Classrange LOOP
         IF allDotp(UserNum)(I) >= BestMatch AND I/= UserNum THEN
            Bestmatch := allDotp(UserNum)(I);
            BestStudent := I;
         END IF;
      END LOOP;

      RETURN BestStudent;
   END MostSimilar;

   -- *******************************************************************************
-- PRE:  Needs only the classArray, C.
-- POST: Asks the user for a name then searches C for that name;
-- returns the index of the student named UserName.

   FUNCTION GetUserNum (C : Classarray) RETURN Classrange IS
      UserNum   : Classrange;
      FoundName : boolean := false;
      UserName  : String(1 .. Stringsize);
      UserNameSize : Natural;

   BEGIN
      skip_line;
      WHILE NOT FoundName LOOP
         Put("Please enter a user name (all lower case) : ");
         Get_Line(Item => Username, Last => Usernamesize);

         FOR I IN Classrange LOOP
            IF C(I).StuName(1 .. C(I).stuNameSize) = UserName(1 .. UserNameSize) THEN
               FoundName:= True;
               UserNum := I;
               EXIT;
            END IF;
         END LOOP;

         IF NOT FoundName THEN
            Put_line("I could not find that name. Please try again. ");
         END IF;
      END LOOP;

      RETURN UserNum;
   end GetUserNum;
-- ******************************************************************************
-- PRE:  Needs the classarray C, the bandarray B, the indices 'UserNum' and 'SimilarUser'
-- of, respectively, the student entered by the user and the most similar student.
-- POST: Finds a recommendation by searching similarUser's survey data for bands he/she
-- liked and that UserNum hasn't listened to, then displays these bands.

   procedure dispRecommend (C : in Classarray ; B : in Bandarray ; UserNum , similarUser : in Classrange) IS
      TYPE Bandnumarray IS ARRAY(Bandrange) OF Bandrange;
      Bandnums : Bandnumarray;
      Bandnum : Bandrange;
         bandcount : natural :=0;
      foundBand : boolean := false;
   BEGIN
      -- Look for bands rated 5.
      FOR I IN Bandrange LOOP
         IF C(UserNum).Musicsurvey(I) = 0 AND C(Similaruser).Musicsurvey(I) = 5 THEN
            FoundBand := True;
            Bandcount := Bandcount + 1;
            Bandnums(Bandcount) := I;
         END IF;
      END LOOP;

      -- If there weren't any, look for bands rated 3.
      IF NOT FoundBand THEN
            FOR I IN Bandrange LOOP
               IF C(UserNum).Musicsurvey(I) = 0 AND C(Similaruser).Musicsurvey(I) = 3 THEN
                  FoundBand := True;
                  bandcount := bandcount + 1;
                  Bandnums(Bandcount) := I;
               END IF;
            END LOOP;
      END IF;

      IF FoundBand THEN
         Put("You might like ");
         FOR I IN 1 .. (Bandcount - 1) LOOP
            bandnum := bandnums(I);
            Put(B(Bandnum).Bandname(1 .. B(Bandnum).Bandnamesize) & " and ");
         END LOOP;
         bandnum := bandnums(bandcount);
         put(B(Bandnum).Bandname(1 .. B(Bandnum).Bandnamesize) & ".");
      ELSE
         Put("Sorry, we cannot make a recommendation for you.");
      END IF;

   END DispRecommend;




   -- **************************
   -- **************************
   -- **************************
BEGIN


   readBandFile(B);
   ReadSurveyFile(C);

   LOOP  -- Return to the main menu after each run through the program,
         -- until the user chooses 'exit'.
      new_line(2);
      Choice := UserMenu;

      new_line;

      FOR I IN Classrange LOOP
            allDotp(I) := Dotp_Func(I, C);
      END LOOP;

      CASE Choice is
         WHEN 1 =>
            userNum     := getUserNum(C);
            SimilarUser := MostSimilar(allDotp, UserNum);
            UserName    := C(SimilarUser).StuName;
            put("The most similar user to you is " & Username(1 .. C(SimilarUser).stuNameSize) & ".");
         WHEN 2 =>
            FOR I IN Classrange LOOP
               if Alldotp(I)(I) >= Opinionated THEN
                  Opinionated := Alldotp(I)(I);
                  UserNum := I;
               end if;
            END LOOP;
            Put("The student with the most opinionated tastes in music is ");
            put(C(userNum).StuName(1 .. C(UserNum).stuNameSize) & ".");
         WHEN 3=>
               UserNum := GetUserNum(C);
               SimilarUser := Mostsimilar(allDotp, UserNUm);
               dispRecommend(C, B, Usernum, similarUser);
         WHEN 4 =>
            exit;
      END CASE;

   END LOOP;
END recommendation_engine;
