-- init-scripts/01-schema.sql

CREATE TABLE users (
    id INT AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_users PRIMARY KEY (id)
);

CREATE TABLE issues (
    id INT AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'OPEN',
    reporter_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_issues PRIMARY KEY (id),
    CONSTRAINT fk_issues_reporter 
        FOREIGN KEY (reporter_id) 
        REFERENCES users(id)
        ON DELETE RESTRICT
);

CREATE TABLE issue_history (
    id INT AUTO_INCREMENT,
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    field_changed VARCHAR(50) NOT NULL,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_issue_history PRIMARY KEY (id),
    CONSTRAINT fk_history_issue 
        FOREIGN KEY (issue_id) 
        REFERENCES issues(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_history_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(id)
);

-- ====================================================================
-- TRIGGER DE AUDITORIA (Sintaxe direta de uma linha, sem DELIMITER!)
-- ====================================================================
CREATE TRIGGER tg_clean_issues_status_history
AFTER UPDATE ON issues
FOR EACH ROW
INSERT INTO issue_history (issue_id, user_id, field_changed, old_value, new_value)
SELECT 
    NEW.id, 
    NEW.reporter_id, 
    'status', 
    OLD.status, 
    NEW.status
WHERE OLD.status <> NEW.status;

-- ==========================================
-- VIEWS (RELATÓRIOS VIRTUAIS)
-- ==========================================
CREATE VIEW v_issue_history_report AS
SELECT 
    i.id AS issue_id,
    i.title AS issue_title,
    u.username AS changed_by,
    h.field_changed,
    h.old_value,
    h.new_value,
    h.changed_at
FROM issue_history h
INNER JOIN issues i ON h.issue_id = i.id
INNER JOIN users u ON h.user_id = u.id;

-- ==========================================
-- ÍNDICES (OTIMIZAÇÃO DE PERFORMANCE)
-- ==========================================
CREATE INDEX idx_issues_status ON issues(status);