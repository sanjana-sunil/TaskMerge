CREATE TABLE users(
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE jobs (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    schedule VARCHAR(100),
    command TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CHECK (priority >= 0)
);
CREATE TABLE worker(
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    hostname VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'idle',
    last_heartbeat TIMESTAMPTZ,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE job_executions(
    id BIGSERIAL PRIMARY KEY,
    job_id BIGINT REFERENCES jobs(id),
    worker_id BIGINT REFERENCES worker(id),
    status VARCHAR(20) NOT NULL DEFAULT 'running',
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ,
    attempt INTEGER DEFAULT 1,
    error_message TEXT,
    CHECK(ATTEMPT > 0)
);
CREATE TABLE job_dependencies(
    job_id BIGINT REFERENCES jobs(id),
    depends_on_job_id  BIGINT NOT NULL,
    PRIMARY KEY(job_id, depends_on_job_id),
    FOREIGN KEY(depends_on_job_id) REFERENCES jobs(id),
    CHECK (job_id <> depends_on_job_id)
);