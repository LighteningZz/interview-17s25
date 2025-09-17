CREATE TABLE IF NOT EXISTS public.teachers (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name text,
  last_name text
);


CREATE TABLE IF NOT EXISTS public.students (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name text,
  last_name text
);


CREATE TABLE IF NOT EXISTS public.subjects (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  code text NOT NULL UNIQUE,
  title text NOT NULL,
  description text,
  teacher_id bigint NOT NULL UNIQUE REFERENCES public.teachers(id),
  created_at timestamp with time zone NOT NULL DEFAULT now()
);


CREATE TABLE IF NOT EXISTS public.enrollments (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  student_id bigint NOT NULL REFERENCES public.students(id),
  subject_id bigint NOT NULL REFERENCES public.subjects(id),
  enrolled_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT unique_enrollment_per_student_per_subject UNIQUE(student_id, subject_id)
);


CREATE TABLE IF NOT EXISTS public.class_sessions (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  subject_id bigint NOT NULL REFERENCES public.subjects(id),
  teacher_id bigint NOT NULL REFERENCES public.teachers(id),
  session_date timestamp with time zone NOT NULL,
  topic text,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.attendances (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  enrollment_id bigint NOT NULL REFERENCES public.enrollments(id),
  class_session_id bigint NOT NULL REFERENCES public.class_sessions(id),
  status text NOT NULL,
  recorded_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT unique_attendance_per_enrollment_per_session UNIQUE(enrollment_id, class_session_id)
);


CREATE INDEX IF NOT EXISTS idx_subjects_teacher_id ON public.subjects(teacher_id);
CREATE INDEX IF NOT EXISTS idx_subjects_code ON public.subjects(code);

CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON public.enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_subject_id ON public.enrollments(subject_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_subject ON public.enrollments(student_id, subject_id);

CREATE INDEX IF NOT EXISTS idx_class_sessions_subject_id ON public.class_sessions(subject_id);
CREATE INDEX IF NOT EXISTS idx_class_sessions_teacher_id ON public.class_sessions(teacher_id);
CREATE INDEX IF NOT EXISTS idx_class_sessions_date ON public.class_sessions(session_date);

CREATE INDEX IF NOT EXISTS idx_attendances_enrollment_id ON public.attendances(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_attendances_session_id ON public.attendances(class_session_id);
CREATE INDEX IF NOT EXISTS idx_attendances_session_status ON public.attendances(class_session_id, status);
-- เติมข้อมูล mock-up
-- Teachers
INSERT INTO public.teachers (first_name, last_name) VALUES
('Somchai', 'Sukjai'),
('Anong', 'Kritsada'),
('Worawut', 'Khemmarat');

-- Students
INSERT INTO public.students (first_name, last_name) VALUES
('Nattawut', 'Chaiyawan'),
('Pimchanok', 'Srisuk'),
('Kittipong', 'Nualsri'),
('Malee', 'Thongdee');

-- Subjects (แต่ละวิชาผูกกับครูคนเดียว)
-- สมมติ teacher_id=1 สอน MATH101, teacher_id=2 สอน ENG201, teacher_id=3 สอน SCI301
INSERT INTO public.subjects (code, title, description, teacher_id) VALUES
('MATH101', 'Calculus I', 'Introduction to differential calculus', 1),
('ENG201', 'English Literature', 'Survey of English prose and poetry', 2),
('SCI301', 'General Physics', 'Mechanics and thermodynamics', 3);

-- Enrollments (นักเรียนลงทะเบียนเรียนหลายวิชา)
-- student_id 1 ลง MATH101, ENG201
-- student_id 2 ลง MATH101, SCI301
-- student_id 3 ลง ENG201
-- student_id 4 ลงทั้งหมด
INSERT INTO public.enrollments (student_id, subject_id, enrolled_at) VALUES
(1, 1, now()),
(1, 2, now()),
(2, 1, now()),
(2, 3, now()),
(3, 2, now()),
(4, 1, now()),
(4, 2, now()),
(4, 3, now());

-- Class sessions (แต่ละวิชามีการสอนหลายครั้ง)
-- สำหรับ MATH101 (subject_id=1) มี 2 sessions
-- สำหรับ ENG201 (2) มี 2 sessions
-- สำหรับ SCI301 (3) มี 1 session
INSERT INTO public.class_sessions (subject_id, teacher_id, session_date, topic, notes) VALUES
(1, 1, now() - interval '7 days', 'Limits and continuity', 'Introductory examples'),
(1, 1, now() - interval '1 days', 'Derivatives', 'Basic derivative rules'),
(2, 2, now() - interval '6 days', 'Shakespeare: Sonnet 18', 'Reading and discussion'),
(2, 2, now() - interval '2 days', 'Romantic poets', 'Group presentations'),
(3, 3, now() - interval '3 days', 'Newton''s Laws', 'Lab demonstration');

-- Attendances (บันทึกการเข้าเรียน)
-- หา enrollment ids to map: We'll select logically assuming insertion order gives ids 1..8
-- enrollment id mapping (from above inserts):
-- 1:(student1, subj1), 2:(student1, subj2), 3:(student2, subj1), 4:(student2, subj3), 5:(student3, subj2), 6:(student4, subj1), 7:(student4, subj2), 8:(student4, subj3)

-- For class_session ids assume insertion order 1..5
-- Mark some attendances
INSERT INTO public.attendances (enrollment_id, class_session_id, status, recorded_at) VALUES
(1, 1, 'present', now() - interval '7 days'),
(3, 1, 'absent', now() - interval '7 days'),
(6, 1, 'present', now() - interval '7 days'),
(1, 2, 'present', now() - interval '1 days'),
(3, 2, 'present', now() - interval '1 days'),
(6, 2, 'late', now() - interval '1 days'),
(2, 3, 'present', now() - interval '6 days'),
(5, 3, 'present', now() - interval '6 days'),
(7, 4, 'present', now() - interval '2 days'),
(4, 5, 'present', now() - interval '3 days'),
(8, 5, 'absent', now() - interval '3 days');


SELECT	std.first_name || ' ' || std.last_name as student_name,
		sub.code,
        sub.title,
        e.enrolled_at
     
FROM public.enrollments e
INNER JOIN public.subjects sub on sub.id = e.subject_id
INNER JOIN public.students std on std.id = e.student_id
ORDER BY student_name, sub.code