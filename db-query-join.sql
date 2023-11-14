--1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT degrees.name AS `name_of_degree` , `students`.* 
FROM `students`
INNER JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
WHERE degrees.name = 'Corso di Laurea in Economia'

--2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze
SELECT `departments`.`name` AS `departments_name` , `degrees`.*
FROM `degrees`
INNER JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze' AND `degrees`.`level` = 'magistrale'

--3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
-- avrei potuto usare l'id e fare solo una JOIN però non potrei avere nome e cognome
SELECT `teachers`.`name` AS `teacher_name`, `teachers`.`surname`  AS `teacher_surname`, `teachers`.`id` as `teacher_id`, `courses`.*
FROM `courses`
INNER JOIN `course_teacher`
ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
WHERE `teachers`.`name` = 'Fulvio' AND `teachers`.`surname` = 'Amato'

--3.1
SELECT `course_teacher`.`teacher_id` as `teacher_id`, `courses`.*
FROM `courses`
INNER JOIN `course_teacher`
ON `course_teacher`.`course_id` = `courses`.`id`
WHERE `course_teacher`.`teacher_id` = 44

--4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome

-- che dati devo prendere dal dipartimento e dal corso di laurea?
SELECT `students`.*,`degrees`.`name` AS `name_degree`, `departments`.`name` AS `name_department`
FROM `students`
INNER JOIN `degrees`
ON `degrees`.`id` = `students`.`degree_id`
INNER JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
ORDER BY `students`.`surname` , `students`.`name`

--5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT `degrees`.`name` AS `name_degrees` , `courses`.`name` AS `name_courses` , `teachers`.`name` , `teachers`.`surname`
FROM `degrees`
INNER JOIN `courses`
ON `courses`.`degree_id` = `degrees`.`id`
INNER JOIN `course_teacher`
ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
ORDER BY `degrees`.`name`

--6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.*
FROM `degrees`
INNER JOIN `courses`
ON `courses`.`degree_id` = `degrees`.`id`
INNER JOIN `course_teacher`
ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
WHERE `degrees`.`department_id` = 5

--6.1
SELECT DISTINCT `departments`.`name` AS `departments_name` , `teachers`.*
FROM `teachers`
INNER JOIN `course_teacher`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
INNER JOIN `courses`
ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `degrees`
ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Matematica'

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18.

SELECT `students`.`name` , `students`.`surname`,`courses`.`name` AS `Course_name`, COUNT(`exam_student`.`student_id`) AS `numero_tentativi`, MAX(`exam_student`.`vote`)
FROM `students`
INNER JOIN `exam_student`
ON `exam_student`.`student_id` = `students`.`id`
INNER JOIN `exams`
ON `exams`.`id` = `exam_student`.`exam_id`
INNER JOIN `courses`
ON `courses`.`id` = `exams`.`course_id`
GROUP BY `students`.`id`, `courses`.`id`
HAVING MAX(`exam_student`.`vote`) >= 18
ORDER BY `students`.`surname` , `students`.`name` , `courses`.`name`;