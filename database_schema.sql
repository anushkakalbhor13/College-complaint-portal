-- College Complaint Portal Database Schema
-- Created for Java/JDBC implementation

-- Create database
CREATE DATABASE IF NOT EXISTS college_complaint_portal;
USE college_complaint_portal;

-- Users table (students and admins)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'admin') NOT NULL DEFAULT 'student',
    phone VARCHAR(15),
    student_id VARCHAR(20),
    department VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Officials table (complaint handlers)
CREATE TABLE officials (
    id INT PRIMARY KEY AUTO_INCREMENT,
    official_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(50) NOT NULL,
    designation VARCHAR(50),
    phone VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Complaint categories table
CREATE TABLE complaint_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Complaints table
CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    category_id INT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    status ENUM('pending', 'assigned', 'in_progress', 'resolved', 'closed', 'withdrawn') DEFAULT 'pending',
    assigned_to INT,
    department VARCHAR(50),
    resolution_details TEXT,
    attachment_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES complaint_categories(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES officials(id) ON DELETE SET NULL
);

-- Notifications table
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    official_id INT,
    complaint_id INT,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (official_id) REFERENCES officials(id) ON DELETE SET NULL,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
);

-- Complaint history/tracking table
CREATE TABLE complaint_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT NOT NULL,
    status_from VARCHAR(50),
    status_to VARCHAR(50) NOT NULL,
    changed_by INT,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Feedback table
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    feedback_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- System settings table
CREATE TABLE system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default complaint categories
INSERT INTO complaint_categories (category_name, description) VALUES
('Academic Issues', 'Issues related to courses, exams, grades, and academic matters'),
('Infrastructure', 'Problems with buildings, classrooms, labs, and facilities'),
('Hostel/Accommodation', 'Issues related to hostel facilities and accommodation'),
('Library Services', 'Problems with library resources and services'),
('Transportation', 'Issues with college transportation and parking'),
('Canteen/Food Services', 'Problems with food quality and canteen services'),
('Administrative Issues', 'Issues with administrative processes and documentation'),
('Harassment/Discrimination', 'Reports of harassment, discrimination, or misconduct'),
('IT Services', 'Problems with internet, computers, and IT infrastructure'),
('Other', 'Any other issues not covered in above categories');

-- Insert default admin user
INSERT INTO users (name, email, password, role, department) VALUES
('System Administrator', 'admin@college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Administration');

-- Insert sample officials
INSERT INTO officials (official_id, name, email, password, department, designation, phone) VALUES
('OFF001', 'Dr. John Smith', 'john.smith@college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Academic Affairs', 'Dean', '+1234567890'),
('OFF002', 'Ms. Sarah Johnson', 'sarah.johnson@college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Infrastructure', 'Facilities Manager', '+1234567891'),
('OFF003', 'Mr. David Wilson', 'david.wilson@college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Student Affairs', 'Student Coordinator', '+1234567892'),
('OFF004', 'Dr. Emily Brown', 'emily.brown@college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'IT Services', 'IT Head', '+1234567893');

-- Insert sample students
INSERT INTO users (name, email, password, role, student_id, department, phone) VALUES
('Alice Cooper', 'alice.cooper@student.college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'STU001', 'Computer Science', '+1234567894'),
('Bob Johnson', 'bob.johnson@student.college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'STU002', 'Electrical Engineering', '+1234567895'),
('Carol Davis', 'carol.davis@student.college.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student', 'STU003', 'Mechanical Engineering', '+1234567896');

-- Insert system settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('max_file_size', '5242880', 'Maximum file upload size in bytes (5MB)'),
('allowed_file_types', 'jpg,jpeg,png,pdf,doc,docx', 'Allowed file extensions for attachments'),
('complaint_auto_close_days', '30', 'Days after which resolved complaints are auto-closed'),
('notification_email_enabled', 'true', 'Enable email notifications'),
('maintenance_mode', 'false', 'Enable maintenance mode');

-- Create indexes for better performance
CREATE INDEX idx_complaints_user_id ON complaints(user_id);
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_complaints_assigned_to ON complaints(assigned_to);
CREATE INDEX idx_complaints_created_at ON complaints(created_at);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_complaint_history_complaint_id ON complaint_history(complaint_id);