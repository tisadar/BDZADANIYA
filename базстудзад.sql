
-- Задание 3
-- • Вывести списки групп по заданному направлению с указание номера группы в формате ФИО, бюджет/внебюджет. Студентов выводить в алфавитном порядке.
SELECT `Student`.`fullname` as `Full name`, 
		`Groups`.`group_name` as `Group name`, 
		if (`Student`.`osnova` = 1, "Бюджет", "Внебюджет") as `osnova`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
ORDER BY `Student`.`fullname`;
 
 
-- • Вывести студентов с фамилией, начинающейся с первой буквы вашей фамилии, с  указанием ФИО, номера группы и направления обучения. 
SELECT `Student`.`fullname` as `Full name`,
		`Groups`.`group_name` as `Group name`,
        `Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Groups`.`direction_id`
WHERE `Student`.`fullname` LIKE "А%";


-- • Вывести список студентов для поздравления по месяцам в формате Фамилия И.О., день и название месяца рождения, номером группы и направлением обучения.
SELECT 
CONCAT(LEFT(`fullname`, LOCATE(' ', `fullname`)),
       CONCAT(LEFT(RIGHT(`fullname`, CHAR_LENGTH(`fullname`) - LOCATE(' ', `fullname`)), 1), '. '),
      CONCAT(LEFT(RIGHT(`fullname`, CHAR_LENGTH(`fullname`) - LOCATE(' ', `fullname`, (LOCATE(' ', `fullname`) + 1))), 1), '.')) 
as `Name`,
DAYOFMONTH(`Student`.`birthday`) as `Day`,
CASE
	WHEN MONTHNAME(`Student`.`birthday`) = "January" 
    	THEN "Январь"
    WHEN MONTHNAME(`Student`.`birthday`) = "February" 
    	THEN "Февраль"
    WHEN MONTHNAME(`Student`.`birthday`) = "March" 
    	THEN "Март"
    WHEN MONTHNAME(`Student`.`birthday`) = "April" 
    	THEN "Апрель"
    WHEN MONTHNAME(`Student`.`birthday`) = "May" 
    	THEN "Май"
    WHEN MONTHNAME(`Student`.`birthday`) = "June" 
    	THEN "Июнь"
    WHEN MONTHNAME(`Student`.`birthday`) = "July" 
    	THEN "Июль"
    WHEN MONTHNAME(`Student`.`birthday`) = "August" 
    	THEN "Август"
    WHEN MONTHNAME(`Student`.`birthday`) = "September" 
    	THEN "Сентябрь"
    WHEN MONTHNAME(`Student`.`birthday`) = "October" 
    	THEN "Октябрь"
    WHEN MONTHNAME(`Student`.`birthday`) = "November" 
    	THEN "Ноябрь"
    WHEN MONTHNAME(`Student`.`birthday`) = "December" 
    	THEN "Декабрь"
 END AS 'Month',
`Groups`.`group_name` as `Group name`,
`Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Groups`.`direction_id`
ORDER BY MONTH(`Student`.`birthday`); 


-- • Вывести студентов с указанием возраста в годах.
SELECT fullname, (YEAR(CURRENT_DATE()) - YEAR(birthday)) as Age
FROM Student;


-- • Вывести студентов, у которых день рождения в текущем месяце.
SELECT `fullname` as `Name`, `birthday` as `Birthday`
FROM `Student`
WHERE MONTH(`Student`.`birthday`) = MONTH(CURRENT_DATE());


-- • Вывести количество студентов по каждому направлению.
SELECT COUNT(`Student`.`id`) as `Students number`, `Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Groups`.`direction_id`
GROUP BY `Directions_of_study`.`direction_name`;

-- • Вывести количество бюджетных и внебюджетных мест по группам. Для каждой группы вывести номер и название направления.
SELECT 
	Groups.group_name, 
    Directions_of_study.direction_name, 
	COUNT(CASE WHEN osnova = true THEN 1 ELSE 0 END) as number_of_buget 
FROM Student
	JOIN Groups ON Groups.id = Student.group_id
    JOIN Directions_of_study ON Directions_of_study.id = Groups.direction_id
GROUP BY Groups.id



-- Задание 5
-- • Вывести списки групп по каждому предмету с указанием преподавателя.
SELECT `Disciplines`.`name`, `Groups`.`group_name`,`Teachers`.`name`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `DirectionDisciplineTeacher`.`direction_id`
JOIN `Groups` ON `Groups`.`direction_id` = `Directions_of_study`.`id`
JOIN `Teachers` ON `Teachers`.`id` = `DirectionDisciplineTeacher`.`teacher_id`


-- • Определить, какую дисциплину изучает максимальное количество студентов.
SELECT `Disciplines`.`name` as `disc_name`, COUNT(`Student`.`fullname`) as `s_num`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `scores` ON `scores`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `scores`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`fullname`) DESC 
LIMIT 1


-- • Определить сколько студентов обучатся у каждого их преподавателей.
SELECT `Teachers`.`name`, COUNT(`Student`.`id`) as `s_num`
FROM `Teachers`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`teacher_id` = `Teachers`.`id`
JOIn `scores` ON `scores`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `Student`.`id` = `scores`.`student_id`
GROUP BY `Teachers`.`name`


-- • Определить долю ставших студентов по каждой дисциплине (не оценки или 2 считать не
-- сдавшими).
SELECT `Disciplines`.`name` as `disc_name`, COUNT(IF(`scores`.`score` > 2, 1, NULL)) as `s_num`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `scores` ON `scores`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `scores`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`fullname`) DESC


-- • Определить среднюю оценку по предметам (для сдавших студентов)
SELECT `Disciplines`.`name` as `disc_name`, AVG(IF(`scores`.`score` > 2, `scores`.`score`, NULL)) as `s_avg`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `scores` ON `scores`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `scores`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`fullname`) DESC


-- • Определить группу с максимальной средней оценкой (включая не сдавших)
SELECT `Groups`.`group_name`, AVG(`scores`.`score`) as `average_score`
FROM `Groups`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Groups`.`direction_id`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`direction_id` = `Directions_of_study`.`id`
JOIN `scores` ON `scores`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
GROUP BY `Groups`.`group_name`
LIMIT 1


-- • Вывести студентов со всем оценками отлично и не имеющих несданный экзамен
SELECT Student.fullname, AVG(scores.score)
FROM Student
JOIN scores ON scores.student_id = Student.id
GROUP BY Student.fullname
HAVING AVG(scores.score) = 5.0;


-- • Вывести кандидатов на отчисление (не сдан не менее двух предметов)
SELECT Student.fullname
FROM Student
JOIN scores ON scores.student_id = Student.id
WHERE scores.score = 2
GROUP BY Student.fullname
HAVING COUNT(*)>1



-- Задание 7
-- • Вывести по заданному предмету количество посещенных занятий.
SELECT COUNT(Attendance.id) as num_presense 
FROM Disciplines
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.discipline_id = Disciplines.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Disciplines.name = "Программирование дискретных структур" AND Attendance.presense = true
GROUP BY Attendance.presense;


-- • Вывести по заданному предмету количество пропущенных занятий.
SELECT COUNT(Attendance.id) as num_presense 
FROM Disciplines
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.discipline_id = Disciplines.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Disciplines.name = "Программирование дискретных структур" AND Attendance.presense = false
GROUP BY Attendance.presense;


-- • Вывести по заданному преподавателю количество студентов на каждом занятии.
SELECT COUNT(Attendance.id) as num_presense, DirectionDisciplineTeacher.id
FROM Teachers
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.teacher_id = Teachers.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Teachers.name = "Шиловский Дмитрий Михайлович" AND Attendance.presense = true
GROUP BY Lessons_shedule.sub_disc_teach_id;


-- • Для каждого студента вывести общее время, потраченное на изучение каждого предмета.
SELECT
Student.id AS student_id, Student.fullname AS student_name, Directions_of_study.direction_name AS direction_name, Disciplines.name AS discipline_name, 
SUM(TIME_TO_SEC(Study_time.time_end) - TIME_TO_SEC(Study_time.time_start)) AS total_study_time
FROM Student
JOIN Groups ON Student.group_id = Groups.id
JOIN Directions_of_study ON Groups.direction_id = Directions_of_study.id
JOIN DirectionDisciplineTeacher ON Directions_of_study.id = DirectionDisciplineTeacher.direction_id
JOIN Disciplines ON DirectionDisciplineTeacher.discipline_id = Disciplines.id
JOIN Lessons_shedule ON DirectionDisciplineTeacher.id = Lessons_shedule.sub_disc_teach_id
JOIN Study_time ON Lessons_shedule.time_id = Study_time.id
JOIN Attendance ON Lessons_shedule.id = Attendance.schedule_id AND Student.id = Attendance.student_id AND Attendance.presense = true
GROUP BY Student.id, Directions_of_study.id, Disciplines.id;

-- ТРИГГЕРЫ

-- table 'Student'

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullname` varchar(200) NOT NULL,
  `birthday` date NOT NULL,
  `address` varchar(200) DEFAULT 'NULL',
  `email` varchar(100) DEFAULT 'NULL',
  `group_id` int(11) NOT NULL,
  `osnova` tinyint(1) NOT NULL,

DROP TRIGGER IF EXISTS Student_insert;

CREATE TRIGGER Student_insert BEFORE INSERT ON Student
FOR EACH ROW BEGIN 
IF (!(NEW.email REGEXP "[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+")) THEN
	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Некорректный email.';
END IF;
IF (!(NEW.fullname REGEXP "([A-Я]{1}[а-я]+[[:space:]]){2}[А-Я]{1}[а-я]+")) THEN
	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Некорректное имя.';
END IF;
END

-- тестовый ввод
INSERT INTO Student(fullname, birthday, address, email, group_id, osnova)
VALUES 
("Демиденко Андейр Абаб", "2003-04-07", "г. Пушкина, ул. Пушкина, д. 1", "digitexsample@gmail.com", 1, True);



-- table 'Phone_numbers'

DROP TRIGGER IF EXISTS Phone_numbers_insert;

CREATE TRIGGER Phone_numbers_insert BEFORE INSERT ON Phone_numbers
FOR EACH ROW BEGIN

IF (!(NEW.phone_number REGEXP "^[+]7(9[0-9]{9})$")) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Некорректный номер телефона.';
END IF;
END

-- тестовый ввод
INSERT INTO Phone_numbers(student_id, phone_number) VALUES(22, "89513915866");