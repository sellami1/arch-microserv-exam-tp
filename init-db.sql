DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'avis_db') THEN
        CREATE DATABASE avis_db;
    END IF;
END
$$;