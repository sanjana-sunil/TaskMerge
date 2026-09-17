INSERT INTO workers(name, hostname, status, last_heartbeat)
VALUES
('worker-1', 'worker1.local', 'idle', NOW()),
('worker-2', 'worker2.local', 'idle', NOW()),
('worker-3', 'worker3.local', 'busy', NOW());

INSERT INTO jobs
(name, description, schedule, command, status, priority)
VALUES
('Database Backup',
'Daily Database Backup',
'0 0 * * *',
'pg_dump job_scheduler > backup.sql',
'pending',
10),

('Data Processing',
'Process daily data',
'0 * * * *',
'python process_data.py',
'pending',
8),

('Generate Report',
'Generate daily report',
'0 6 * * *',
'python degenrate_report.py',
'pending',
5),

('Cleanup',
'Remove temporary files',
'0 0 * * 0',
'rm -rf /tmp/job_files',
'pending',
3);

INSERT INTO job_dependencies(job_id, depends_on_job_id)
VALUES
(3, 2),
(4, 1);

INSERT INTO job_executions
(job_id, worker_id, status, started_at, finished_at, attempt, error_message)
VALUES
(1, 1, 'completed',
NOW() - INTERVAL '2 hours',
NOW() - INTERVAL '1 hour 55 minutes',
1, 
NULL),
(2, 2, 'failed',
NOW() - INTERVAL '1 hour',
NOW() - INTERVAL '50 minutes',
1,
'Connection timeout');
