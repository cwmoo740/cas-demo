CREATE EXTENSION pgcrypto;
GRANT ALL PRIVILEGES ON DATABASE cowmoo TO cowmoo;
CREATE SCHEMA authentication;
CREATE TABLE authentication.users (
    pk BIGSERIAL PRIMARY KEY,
    id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);
INSERT INTO authentication.users (username, password) VALUES ('cowmoo', 'my-password');
