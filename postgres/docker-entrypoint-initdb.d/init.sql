CREATE EXTENSION IF NOT EXISTS pgcrypto;
GRANT ALL PRIVILEGES ON DATABASE authentication TO db_user;
CREATE TABLE public.users (
    pk BIGSERIAL PRIMARY KEY,
    id UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);
INSERT INTO public.users (username, password) VALUES ('jyoung2', 'jyoung2');
INSERT INTO public.users (username, password) VALUES ('twong', 'twong');
INSERT INTO public.users (username, password) VALUES ('mpearson', 'mpearson');

