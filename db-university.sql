--Query con SELECT
--1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT *
FROM `students` 
WHERE YEAR(`date_of_birth`) = 1990;
	
--2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * 
FROM `courses` 
WHERE `cfu` > 10  

--3. Selezionare tutti gli studenti che hanno più di 30 anni
-- non mi convince?? DATEDIFF
SELECT * 
FROM `students` 
WHERE YEAR(CURRENT_DATE) - YEAR(`date_of_birth`) > INTERVAL 30 YEAR

--3.1
SELECT * 
FROM `students` 
WHERE CURRENT_DATE - INTERVAL 30 YEAR > `date_of_birth`

--3.2
SELECT *
FROM `students` 
WHERE DATEDIFF(CURRENT_DATE,`date_of_birth`) > 30 * 365  

--3.3
SELECT *, TIMESTAMPDIFF(YEAR,`date_of_birth`,CURRENT_DATE) AS age
FROM `students`
HAVING age > 30

--4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * 
FROM `courses` 
WHERE `period` = 'I semestre' AND `year` = 1

--5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * 
FROM `exams` 
WHERE `date` = '2020-06-20' AND `hour` > '14:00:00';

--6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * 
FROM `degrees` 
WHERE `level` = 'magistrale'

--7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS `num_departments` 
FROM `departments`

--8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS `teachers_no_phone`
FROM `teachers` 
WHERE `phone` IS NULL



--Query con GROUP BY
--1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(`enrolment_date`) as year, COUNT(*) AS `enrollment_for_year`
FROM `students` 
GROUP BY year

--2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT `office_address` , COUNT(*) as `num_teacher_office_address`
FROM `teachers`
GROUP BY `office_address`

--3. Calcolare la media dei voti di ogni appello d'esame
SELECT `exam_id` , (SUM(`vote`) / COUNT(*)) AS `average_vote`
FROM `exam_student`
GROUP BY `exam_id`

--3.1
SELECT courses.name , exam_student.exam_id ,(SUM(`vote`) / COUNT(*)) AS `average_vote`
FROM `exam_student`
LEFT JOIN `exams`
ON exam_student.exam_id = exams.id
LEFT JOIN `courses`
ON exams.course_id = courses.id
GROUP BY exam_student.exam_id

--4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT `department_id` , COUNT(*) AS `course_for_departments`
FROM `degrees`
GROUP BY `department_id`

--4.1
SELECT departments.name, `department_id` , COUNT(*) AS `course_for_departments`
FROM `degrees`
LEFT JOIN `departments`
ON degrees.department_id = departments.id
GROUP BY `department_id`
