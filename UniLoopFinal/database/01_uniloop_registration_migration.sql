-- UniLoop registration and student verification migration
-- BACK UP the uniloop database before running this script.
-- Run this migration ONCE against the existing schema.
USE uniloop;

ALTER TABLE users
    ADD COLUMN phone VARCHAR(25) NULL,
    ADD COLUMN college_name VARCHAR(180) NULL,
    ADD COLUMN department VARCHAR(120) NULL,
    ADD COLUMN course VARCHAR(120) NULL,
    ADD COLUMN academic_year VARCHAR(40) NULL,
    ADD COLUMN student_id VARCHAR(80) NULL,
    ADD COLUMN campus_location VARCHAR(180) NULL,
    ADD COLUMN approval_status VARCHAR(20) NOT NULL DEFAULT 'APPROVED',
    ADD COLUMN verified_by INT NULL,
    ADD COLUMN verified_at DATETIME NULL,
    ADD COLUMN rejection_reason VARCHAR(500) NULL,
    ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Preserve existing accounts. New registrations are explicitly PENDING in AuthServlet.
UPDATE users SET role = 'STUDENT' WHERE role IS NULL OR role = '';

CREATE INDEX idx_users_approval_status ON users (approval_status);
CREATE INDEX idx_users_role_approval ON users (role, approval_status);

SELECT id, full_name, email, role, approval_status, created_at
FROM users
ORDER BY id DESC;
