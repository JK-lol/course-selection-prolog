%main menu for choice
menu:-
	write('1. Show completed course'),nl,
	write('2. Show credit hours fulfilled'),nl,
	write('3. Show eligible course'),nl,
	write('4. Check eligibility of internship and FYP'),nl,
    	write('5. Enroll a new subject'),nl,
	write('6. View enrolled subject'),nl,
    	write('7. Exit'),nl,
	
	write('Please enter student id: '),
	read(StudentID),

    
	write('Please enter an option: '),
	read(Input),

	(
		Input=:= 1 -> completed_courses(StudentID, CompletedCourses)
    					,write(CompletedCourses),nl;
		Input=:= 2 -> total_credit_hours(StudentID, CreditHours)
    					,write('Credit Hours completed: ' = CreditHours),nl;
		Input=:= 3 -> eligible_courses(StudentID,EligibleCourses)
                        ,write(EligibleCourses),nl;
		Input=:= 4 -> eligibility_IR_FYP(StudentID);
    		Input=:= 5 -> write('Enter subject code: '),nl, read(CourseID),
    					enroll_subject(StudentID,CourseID),show_enrolled_subjects(StudentID);
    		Input=:= 6 ->  show_enrolled_subjects(StudentID);
        	Input=:= 7 ->  write('Thank You for using our system, see u again'),abort
	),
    menu.



%Define courses 
course(tma1111, "Mathematical Techniques", 4, []).
course(tcp1121,"Computer Programming",4,[]).
course(tdb1131,"Database Systems",3,[]).
course(tos1141,"Operating Systems",3,[]).
course(tma1211,"Discrete Mathemetics and Probability",4,[]).
course(tao1221,"Computer Architecture and Organisation",4,[]).
course(tdc1231,"Data Communications and Networking",4,[]).
course(tds2111,"Data Structure and Algorithms",3,[tcp1121]).
course(top2121,"Object-oriented Programming",3,[tcp1121]).
course(tsa2131,"System Analysis and Design",3,[tdb1131]).
course(tep1241,"Ethics and Professional Conducts",3,[]).
course(tpl2141,"Programming Language Concept",3,[tcp1121]).
course(tai2151,"Artificial Intelligence Fundamental",3,[tcp1121]).
course(ttv2161,"Technopreneur Venture",2,[]).
course(thi2211,"Human Computer Interaction",3,[tcp1121]).
course(tml2221,"Machine Learning",3,[tcp1121]).
course(tse2231,"Software Engineering Fundamental",3,[tcp1121]).
course(twt2231,"Web Techniques and Application",3,[]).
course(tpr2251,"Pattern Recognition",3,[tcp1121]).
course(tci3121,"Computational Intelligence",3,[tai2151]).
course(tcn2141,"Computer Networks",3,[tdc1231]).
course(tes3141,"Expert Systems",3,[tma1211]).
course(tcv3151,"Computer Vision",3,[tai2151]).
course(tnl3221,"Natural Language Processing",3,[tai2151]).
course(tda3231,"Algorithm Design and Analysis",3,[tma1211]).
course(tsw3241,"Semantic Web Technology",3,[tma1211]).
course(elective1,"Elective 1",3,[]).
course(elective2,"Elective 2",3,[]).
course(elective3,"Elective 3",3,[]).
course(elective4,"Elective 4",3,[]).



%Insert student data 
:-dynamic student/4.
student(jordan, 1191102760, [tma1111,tcp1121,tdb1131,tos1141,tma1211,tao1221
 ,tep1241],[]).
student(juankai, 1191103363,[tma1111,tcp1121,tdb1131,tos1141,tma1211,tao1221,tdc1231
,tep1241,elective1,tds2111,top2121,tsa2131,tpl2141,tai2151,ttv2161,
thi2211,tml2221,tse2231,twt2231,tpr2251,elective2],[]).
student(shahd, 1191101853, [tma1111],[]).
student(habibahteralman, 1211300789, [],[]).

%Show completed course
completed_courses(StudentID, CompletedCourses) :-
    student(_, StudentID, CompletedCourses,_).

%Show eligible course
eligible_courses(StudentID, EligibleCourses) :-
    student(_, StudentID, CompletedCourses, _),
    findall(Course, (course(Course, _, _, Prereqsuite),
                     \+member(Course, CompletedCourses),
                     subset(Prereqsuite, CompletedCourses)),
            EligibleCourses).

%Define rule to identify credit hours
total_credit_hours(StudentID, CreditHours) :-
    completed_courses(StudentID, CompletedCourses),
    % Calculate the total credit hours for the completed courses
    total_credit_hours(CompletedCourses, CreditHours).

%Define total_credit_hours function
total_credit_hours([], 0).
total_credit_hours([Course|Courses], CreditHours) :-
    course(Course, _, CourseCreditHours, _),
    total_credit_hours(Courses, RemainingCreditHours),
    CreditHours is CourseCreditHours + RemainingCreditHours.

%Check if a student is eligible to have (industrial traning/FYP) or not
eligibility_IR_FYP(StudentID):-
	total_credit_hours(StudentID,CreditHours),
	CreditHours >=60,
    write('Credit Hour Fulfilled. Eligible for industrial training and FYP'),nl,nl;
    write('Not eligible, does not fulfilled 60 credit hours'),nl,nl.

% Enroll a student in a subject
enroll_subject(StudentID, Subject) :-
    % Look up the student's record
    eligible_courses(StudentID, EligibleCourses), % get list of eligible courses
    member(Subject, EligibleCourses), % check if course is in list of eligible courses
    student(_, StudentID, CompletedCourses, EnrollingSubjects),
    % Check if the subject is already enrolled or completed and if the student passes prerequisite or not
    \+ member(Subject, EnrollingSubjects),
    \+ member(Subject, EnrollingSubjects),
    \+ member(Subject,CompletedCourses),
    

    % Add the subject to the enrolling subjects
    append(EnrollingSubjects, [Subject], NewEnrollingSubjects),
    % Update the student record
    retract(student(_, StudentID, CompletedCourses, _)),
    assert(student(_, StudentID, CompletedCourses, NewEnrollingSubjects));
    (write('Error, please check if the subject is taken, completed, available or you did
           not passed its prerequisite'),nl,menu).


% Show the enrolled subjects for a student
show_enrolled_subjects(StudentID) :-
    % Look up the student's record
    student(_, StudentID, _, EnrolledSubjects),
    % Return the enrolled subjects
    write('Enrolled subjects are: ' -> EnrolledSubjects),nl.
