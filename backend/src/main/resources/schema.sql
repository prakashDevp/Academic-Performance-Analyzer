-- ============================================================
-- CGPA Target-Based Learning & Guidance System
-- Database: cgpa_tracker_db
-- MySQL Setup Script
-- ============================================================

CREATE DATABASE IF NOT EXISTS cgpa_tracker_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cgpa_tracker_db;

-- ── Students Table ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS students (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100)   NOT NULL,
    email            VARCHAR(150)   NOT NULL UNIQUE,
    register_number  VARCHAR(50)    NOT NULL UNIQUE,
    branch           VARCHAR(100)   NOT NULL,
    target_cgpa      DECIMAL(4,2)   NOT NULL,
    current_cgpa     DECIMAL(4,2)   DEFAULT 0.00,
    current_semester INT            DEFAULT 0,
    created_at       DATETIME       DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_register (register_number),
    INDEX idx_branch (branch)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Semester Records Table ──────────────────────────────────
CREATE TABLE IF NOT EXISTS semester_records (
    id                    BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id            BIGINT        NOT NULL,
    semester_number       INT           NOT NULL,
    gpa                   DECIMAL(4,2)  NOT NULL,
    cgpa_after_semester   DECIMAL(4,2),
    required_gpa_remaining DECIMAL(4,2),
    progress_status       ENUM('ON_TRACK','AHEAD','BEHIND','CRITICAL','ACHIEVED') DEFAULT 'ON_TRACK',
    guidance_message      TEXT,
    recorded_at           DATETIME      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY uq_student_semester (student_id, semester_number),
    INDEX idx_student_id (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Sample Data ─────────────────────────────────────────────
INSERT INTO students (name, email, register_number, branch, target_cgpa, current_cgpa, current_semester)
VALUES
  ('Prakash Kumar',     'prakash@college.edu',  'CSE2021001', 'Computer Science Engineering', 9.5, 0.00, 0),
  ('Priya Sharma',      'priya@college.edu',    'ECE2021002', 'Electronics Engineering',       9.0, 0.00, 0),
  ('Arjun Mehta',       'arjun@college.edu',    'MECH2021003','Mechanical Engineering',        8.5, 0.00, 0);

-- Note: Semester records will be added through the API
-- Run this SQL first, then start Spring Boot (it will auto-create/update tables via Hibernate)
