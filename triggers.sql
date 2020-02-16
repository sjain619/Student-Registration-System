create or replace TRIGGER drop_student AFTER
delete on enrollments 
FOR EACH ROW
BEGIN
	update classes SET 
	class_size = class_size-1 where
	classid = :old.classid;
END;

create or replace TRIGGER log_delete AFTER
DELETE on enrollments
FOR EACH ROW
DECLARE
username varchar2(10);
BEGIN
select user into username from dual;
  INSERT INTO logs values(logseq.nextval,username,SYSDATE,'Enrollments','delete',:old.b#||','||:old.classid);
END;

create or replace TRIGGER log_enrollment AFTER
INSERT on enrollments
FOR EACH ROW
DECLARE
username varchar2(10);
BEGIN
    select user into username from dual;
    INSERT INTO logs values(logseq.nextval,username,SYSDATE,'Enrollments','insert',:new.b#||','||:new.classid);
END;

create or replace TRIGGER log_student_del AFTER
DELETE on students
FOR EACH ROW
DECLARE
    username varchar2(10);
BEGIN
select user into username from dual;
IF DELETING THEN
        INSERT INTO logs values(LOGSEQ.nextval,username,SYSDATE,'students','delete',:OLD.b#);
END IF;
END;

create or replace TRIGGER on_delete_std AFTER
delete on students 
FOR EACH ROW
BEGIN
  delete from enrollments where b#=:old.b#;
END;

create or replace TRIGGER on_enrollment AFTER
insert on enrollments 
FOR EACH ROW
BEGIN
	update classes SET 
	class_size = class_size+1 where
	classid = :new.classid;
END;