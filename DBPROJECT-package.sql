create or replace type preReqArray IS VARRAY(100) OF VARCHAR2(20);

create or replace
PACKAGE DBPROJECT AS
  PROCEDURE show_students(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_tas(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_courses(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_classes(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_enrollments(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_prerequisites(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE show_logs(sys_cur OUT SYS_REFCURSOR);
  PROCEDURE class_ta(class_id IN VARCHAR2, ta_cur OUT SYS_REFCURSOR, err OUT number);
  PROCEDURE get_prereq(deptcode IN varchar2,course_# IN number, preResult OUT preReqArray, err OUT number);
  PROCEDURE enroll_student(b_# IN VARCHAR2,class_id IN VARCHAR2,err OUT number);
  PROCEDURE drop_student(b_# IN VARCHAR2,class_id IN VARCHAR2,err OUT number);
  PROCEDURE delete_student(b_# IN VARCHAR2,err OUT number);
  /* TODO enter package declarations (types, exceptions, methods etc) here */

END DBPROJECT;

create or replace PACKAGE BODY DBPROJECT AS

  PROCEDURE show_students(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM students;
  END show_students;

  PROCEDURE show_tas(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM tas;
  END show_tas;

  PROCEDURE show_courses(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM courses;
  END show_courses;

  PROCEDURE show_classes(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM classes;
  END show_classes;

  PROCEDURE show_enrollments(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM enrollments;
  END show_enrollments;

  PROCEDURE show_prerequisites(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM prerequisites;
  END show_prerequisites;

  PROCEDURE show_logs(sys_cur OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN sys_cur FOR SELECT * FROM logs;
  END show_logs;
  
  PROCEDURE class_ta(class_id IN VARCHAR2, ta_cur OUT SYS_REFCURSOR, err OUT number) IS
  hasTa number;
  isValidClassId number;
  check_b# number;
  BEGIN
  
  select count(classid) into isValidClassId from classes where classid = class_id;
  IF isValidClassId = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The classid is invalid');
          err := 1;
          return;
  END IF;
  
  select count(classid) into hasTa from classes where classid = class_id and TA_B# is not null;
  IF hasTa = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The class has no TA');
          err := 2;
          return;
  END IF;
  
  err :=3;
  open ta_cur for select B#, first_name, last_name from students join classes on B#=TA_B# where classid = class_id;
  
  END class_ta;
  
  PROCEDURE get_prereq(deptcode IN varchar2,course_# IN number, preResult OUT preReqArray, err OUT number)
  AS
  isValidCourse number;
  arrInd number(10);
  loopcount number(10);
  preResultTemp preReqArray; 
  deptCourse varchar2(8);
  BEGIN
  
  select count(*) into isValidCourse from courses where DEPT_CODE = deptcode and course#=course_#;
  IF isValidCourse = 0 THEN
          DBMS_OUTPUT.PUT_LINE('course does not exist');
          err := 0;
          return;
  END IF;
  
  arrInd := 0;
  loopcount :=1;
  preResultTemp := preReqArray();
  for d in (select *  from prerequisites where  dept_code = deptcode and course# = course_#)
    loop
      arrInd := arrInd + 1;
      preResultTemp.extend;
      preResultTemp(arrInd) := d.PRE_DEPT_CODE||d.PRE_COURSE#;
    END LOOP;
    
  WHILE loopcount <= arrInd
    LOOP
      deptCourse := preResultTemp(loopcount);
    loopcount := loopcount + 1;
      for e in (select * from prerequisites where  dept_code||course# = deptCourse)
      loop
      arrInd := arrInd + 1;
      preResultTemp.extend;
      preResultTemp(arrInd) := e.PRE_DEPT_CODE||e.PRE_COURSE#;
    END LOOP;
   END LOOP;
  preResult := preResultTemp;
  err := 1;
  END get_prereq;
  
  PROCEDURE enroll_student(b_# IN VARCHAR2,class_id IN VARCHAR2,err OUT number) IS
  isValidClassId number;
  isValidB# number;
  availSeats number;
  lim number;
  isStudEnr number;
  yr classes.year%TYPE;
  sem classes.semester%TYPE;
  isOverload number(10);
  prer number;
  
  CURSOR prer_cur is select pre_dept_code, pre_course# from prerequisites where 
  (dept_code, course#) in (select dept_code, course# from classes where classid = class_id); 
       prer_rec prer_cur%rowtype;
  BEGIN
  
  select count(b#) into isValidB# from students where b# = b_#;
  IF isValidB# = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The B# is invalid');
          err := 1;
          return;
  END IF;
  
  select count(classid) into isValidClassId from classes where classid = class_id;
  IF isValidClassId = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The classid is invalid');
          err := 2;
          return;
  END IF;
  
  select count(classid) into isValidClassId from classes where classid=class_id and year=2018 and semester='Fall';
  IF isValidClassId = 0 THEN
          DBMS_OUTPUT.PUT_LINE('Cannot enroll into a class from a previous semester');
          err := 3;
          return;
  END IF;
  
  select (limit-class_size) into availSeats from classes where classid = class_id;
  IF availSeats=0  THEN
          DBMS_OUTPUT.PUT_LINE('The class is already full');
    err := 4;
    return;
  END IF;
  
  select COUNT(classid) into isStudEnr from enrollments where b# =b_# AND classid = class_id;
  IF isStudEnr = 1 THEN
          DBMS_OUTPUT.PUT_LINE('The student is already in the class');
    err := 5;
    return;
  END IF;
  
  select year into yr from classes where classid = class_id;
  select semester into sem from classes where classid = class_id;
  select count(classid) into isOverload from enrollments  where b# = b_# and classid in (select classid from classes where year IN (yr) and semester IN (sem));
  
  IF isOverload = 4 THEN
    DBMS_OUTPUT.PUT_LINE('The student will be overloaded with the new enrollment');
    err := 6;
  END IF;
  
  IF isOverload = 5 THEN
    err := 7;
    DBMS_OUTPUT.PUT_LINE('Students cannot be enrolled in more than five classes in the same semester');
    return;
  END IF;
  
  OPEN prer_cur; 
    LOOP 
        FETCH prer_cur into prer_rec; 
        EXIT WHEN prer_cur%notfound; 
          select count(*) into prer from enrollments e join classes c on e.classid=c.classid 
          where c.dept_code = prer_rec.pre_dept_code and c.course#=prer_rec.pre_course# and e.B# = b_# 
          and e.lgrade not in ('C-','D','F','I',null);
          IF prer > 0 THEN
            err := 8;
            DBMS_OUTPUT.PUT_LINE('Prerequisite not satisfied');
            return;
          END IF;
    END LOOP;
  CLOSE prer_cur;
    err := 9;
    insert into enrollments(b#,classid) values(b_#,class_id);
  END enroll_student;
  
  PROCEDURE drop_student(b_# IN VARCHAR2,class_id IN VARCHAR2,err OUT number) IS
  isValid number;
  deptcode classes.dept_code%TYPE;
  crs classes.course#%TYPE;
  
  BEGIN
  
  select count(b#) into isValid from students where b# = b_#;
  IF isValid = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The B# is invalid');
          err := 1;
          return;
  END IF;
  
  select count(classid) into isValid from classes where classid = class_id;
  IF isValid = 0 THEN
          DBMS_OUTPUT.PUT_LINE('The classid is invalid');
          err := 2;
          return;
  END IF;
  
  select COUNT(*) into isValid from enrollments where b# = b_# and classid = class_id;
  IF isValid = 0 THEN
      DBMS_OUTPUT.PUT_LINE('The student is not enrolled in the class');
    err := 3;
    return;
  END IF;
  
  select count(*) into isValid from classes where classid=class_id and semester='Fall' and year=2018;
  IF isValid = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Only enrollment in the current semester can be dropped');
    err := 4;
    return;
  END IF;
  
  select dept_code into deptcode from classes where classid = class_id;
  select course# into crs from classes where classid = class_id;
  
  for i in (select cl.dept_code, cl.course# from enrollments e join classes cl on e.classid=cl.classid 
  where e.B#=b_# and cl.year=2018 and cl.semester='Fall')
    loop
      select count(*) into isValid from prerequisites where DEPT_CODE=i.DEPT_CODE and course#=i.course# and pre_dept_code=deptcode and pre_course#=crs;
    IF isValid = 1 THEN
      DBMS_OUTPUT.PUT_LINE('The drop is not permitted because another class the student registered uses it as a prerequisite');
    err := 5;
    return;
    END IF;
    END LOOP;
  
  delete from enrollments where b#=b_# and classid=class_id;
  
  select count(*) into isValid from enrollments e join classes cl on e.classid=cl.classid where b#=b_# and cl.year=2018 and semester='Fall';
  IF isValid = 0 THEN
      DBMS_OUTPUT.PUT_LINE('This student is not enrolled in any classes');
    err := 6;
  END IF; 
  
  select count(*) into isValid from enrollments where classid=class_id;
  IF isValid = 0 THEN
      DBMS_OUTPUT.PUT_LINE('The class now has no students');
    IF err = 6 THEN
      err := 8;
    ELSE 
      err := 7;
    END IF;
  END IF; 
  
  END drop_student;
  
  PROCEDURE delete_student(b_# IN VARCHAR2,err OUT number)
  IS
  isValid number;
  BEGIN
  select COUNT(b#) into isValid from students where b# = b_#;
  IF isValid = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The B# is invalid');
    err := 1;
    return;
  END IF;
  delete from students where b# = b_#;
  err := 2;
  END delete_student;

END DBPROJECT;
