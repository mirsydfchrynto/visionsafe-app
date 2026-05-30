-- ==========================================
-- VISIONSAFE ELITE SCHEMA (PRODUCTION-GRADE)
-- Author: VISIONSAFE SUPREME BACKEND ARCHITECT
-- Version: 4.0.0
-- Standards: Scalable, Secure, Gamified, Omni-Sync, Idempotent
-- ==========================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. TABLES

-- Profiles (Gamification & Identity)
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name text,
    avatar_url text,
    xp integer DEFAULT 0 NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    total_focus_time_seconds bigint DEFAULT 0 NOT NULL,
    total_violations integer DEFAULT 0 NOT NULL,
    streak_days integer DEFAULT 0 NOT NULL,
    mascot_state text DEFAULT 'happy' NOT NULL, -- 'happy', 'sad', 'focused', 'tired'
    last_active_at timestamptz DEFAULT now() NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- Telemetry (High Volume Tracking)
CREATE TABLE IF NOT EXISTS public.telemetry (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
    distance float8 NOT NULL CHECK (distance >= 0),
    is_violation boolean DEFAULT false NOT NULL,
    is_blinking boolean DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- User Settings
CREATE TABLE IF NOT EXISTS public.user_settings (
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    safe_distance float8 DEFAULT 35.0 NOT NULL,
    is_vibration_enabled boolean DEFAULT true NOT NULL,
    is_sound_enabled boolean DEFAULT true NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- Stickers / Heroes (Master Data)
CREATE TABLE IF NOT EXISTS public.stickers (
    id text PRIMARY KEY,
    title text NOT NULL,
    description text NOT NULL,
    image_url text,
    requirement_type text NOT NULL, -- 'focus_time', 'streak', 'no_violation'
    requirement_value integer NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- User Rewards (Unlocked Stickers)
CREATE TABLE IF NOT EXISTS public.user_stickers (
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    sticker_id text REFERENCES public.stickers(id) ON DELETE CASCADE NOT NULL,
    unlocked_at timestamptz DEFAULT now() NOT NULL,
    PRIMARY KEY (user_id, sticker_id)
);

-- Notifications (In-App Messaging)
CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL DEFAULT auth.uid(),
    title text NOT NULL,
    content text NOT NULL,
    type text DEFAULT 'info' NOT NULL, -- 'info', 'reward', 'alert'
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- News / Education
DROP TABLE IF EXISTS public.news CASCADE;
CREATE TABLE public.news (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text NOT NULL,
    content text NOT NULL,
    category text DEFAULT 'Edukasi' NOT NULL,
    image_url text,
    source_url text,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- 2.1 SCHEMA MIGRATION / UPGRADES (Ensure all columns exist in existing tables)
-- Profiles Upgrades
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS full_name text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS avatar_url text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS xp integer DEFAULT 0 NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS level integer DEFAULT 1 NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS total_focus_time_seconds bigint DEFAULT 0 NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS total_violations integer DEFAULT 0 NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS streak_days integer DEFAULT 0 NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS mascot_state text DEFAULT 'happy' NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS last_active_at timestamptz DEFAULT now() NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now() NOT NULL;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now() NOT NULL;

-- Telemetry Upgrades
ALTER TABLE public.telemetry ADD COLUMN IF NOT EXISTS distance float8 DEFAULT 0 NOT NULL;
ALTER TABLE public.telemetry ADD COLUMN IF NOT EXISTS is_violation boolean DEFAULT false NOT NULL;
ALTER TABLE public.telemetry ADD COLUMN IF NOT EXISTS is_blinking boolean DEFAULT false NOT NULL;
ALTER TABLE public.telemetry ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now() NOT NULL;

-- Legasi Column Patch: buat client_timestamp nullable jika ada agar sinkronisasi tidak gagal
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND table_name = 'telemetry' 
          AND column_name = 'client_timestamp'
    ) THEN
        ALTER TABLE public.telemetry ALTER COLUMN client_timestamp DROP NOT NULL;
    END IF;
END $$;

-- User Settings Upgrades
ALTER TABLE public.user_settings ADD COLUMN IF NOT EXISTS safe_distance float8 DEFAULT 35.0 NOT NULL;
ALTER TABLE public.user_settings ADD COLUMN IF NOT EXISTS is_vibration_enabled boolean DEFAULT true NOT NULL;
ALTER TABLE public.user_settings ADD COLUMN IF NOT EXISTS is_sound_enabled boolean DEFAULT true NOT NULL;
ALTER TABLE public.user_settings ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now() NOT NULL;

-- Stickers Upgrades
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS title text DEFAULT '' NOT NULL;
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS description text DEFAULT '' NOT NULL;
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS image_url text;
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS requirement_type text DEFAULT '' NOT NULL;
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS requirement_value integer DEFAULT 0 NOT NULL;
ALTER TABLE public.stickers ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now() NOT NULL;

-- User Stickers Upgrades
ALTER TABLE public.user_stickers ADD COLUMN IF NOT EXISTS unlocked_at timestamptz DEFAULT now() NOT NULL;

-- Notifications Upgrades
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS title text DEFAULT '' NOT NULL;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS content text DEFAULT '' NOT NULL;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS type text DEFAULT 'info' NOT NULL;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT false NOT NULL;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now() NOT NULL;

-- 3. SECURITY (Row Level Security)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telemetry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stickers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_stickers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;

-- 4. COLUMN-LEVEL WRITER PRIVILEGES
-- Limit direct updates on profiles to non-sensitive fields. All metrics must go through triggers.
REVOKE UPDATE ON public.profiles FROM authenticated;
GRANT UPDATE (full_name, avatar_url, updated_at) ON public.profiles TO authenticated;

-- 5. POLICIES
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile metadata" ON public.profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can select their own telemetry" ON public.telemetry FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own telemetry" ON public.telemetry FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can select their own settings" ON public.user_settings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own settings" ON public.user_settings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own settings" ON public.user_settings FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Stickers are viewable by everyone" ON public.stickers FOR SELECT USING (true);
CREATE POLICY "Users can view their own stickers" ON public.user_stickers FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can select their own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own notifications to read" ON public.notifications FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "News is viewable by everyone" ON public.news FOR SELECT USING (true);

-- 6. AUTOMATION (Triggers & Functions)

-- Function: Handle New User
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');

  INSERT INTO public.user_settings (user_id)
  VALUES (new.id);

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: On Auth Signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Function: Batch Update XP, Focus Time, and Streak on Telemetry Insert (Optimized statement-level transition table)
CREATE OR REPLACE FUNCTION public.update_stats_on_telemetry_batch()
RETURNS trigger AS $$
DECLARE
    v_user_id uuid;
    v_inserted_count integer;
    v_violation_count integer;
    v_total_focus_time bigint;
    v_total_xp integer;
    v_last_active timestamptz;
    v_current_streak integer;
BEGIN
    FOR v_user_id, v_inserted_count, v_violation_count IN
        SELECT user_id, count(*), sum(case when is_violation then 1 else 0 end)
        FROM new_table
        GROUP BY user_id
    LOOP
        -- 0. Get current stats
        SELECT last_active_at, streak_days INTO v_last_active, v_current_streak 
        FROM public.profiles WHERE id = v_user_id;

        v_current_streak := COALESCE(v_current_streak, 0);

        -- 1. STREAK LOGIC
        IF v_last_active IS NULL THEN
            v_current_streak := 1;
        ELSIF (v_last_active::date = CURRENT_DATE) THEN
            -- Already active today
        ELSIF (v_last_active::date = CURRENT_DATE - INTERVAL '1 day') THEN
            v_current_streak := v_current_streak + 1;
        ELSE
            v_current_streak := 1;
        END IF;

        -- 2. Update Profile Stats and Level in exactly one update query to reduce WAL write load & MVCC row bloat
        UPDATE public.profiles
        SET 
            xp = xp + (v_inserted_count * 10), -- Give 10 XP per 1 focus unit
            total_focus_time_seconds = total_focus_time_seconds + v_inserted_count,
            total_violations = total_violations + v_violation_count,
            streak_days = v_current_streak,
            last_active_at = now(),
            mascot_state = (CASE 
                WHEN v_violation_count > 0 THEN 'sad' 
                WHEN ((xp + (v_inserted_count * 10)) % 100) < 10 THEN 'focused'
                ELSE 'happy' 
            END),
            level = floor(sqrt((xp + (v_inserted_count * 10)) / 100)) + 1
        WHERE id = v_user_id
        RETURNING total_focus_time_seconds, xp INTO v_total_focus_time, v_total_xp;

        -- 3. AUTO-UNLOCK STICKERS (Gamification Engine)
        -- Cyber Sentinel (s1): 1800 seconds focus
        IF v_total_focus_time >= 1800 THEN
            INSERT INTO public.user_stickers (user_id, sticker_id)
            VALUES (v_user_id, 's1')
            ON CONFLICT DO NOTHING;
        END IF;

        -- Eye Ninja (s2): Streak 3 days
        IF v_current_streak >= 3 THEN
            INSERT INTO public.user_stickers (user_id, sticker_id)
            VALUES (v_user_id, 's2')
            ON CONFLICT DO NOTHING;
        END IF;

        -- Guardian Soul (s4): 5000 XP
        IF v_total_xp >= 5000 THEN
            INSERT INTO public.user_stickers (user_id, sticker_id)
            VALUES (v_user_id, 's4')
            ON CONFLICT DO NOTHING;
        END IF;
    END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: On Telemetry Insert (Statement level optimization)
DROP TRIGGER IF EXISTS on_telemetry_inserted ON public.telemetry;
CREATE TRIGGER on_telemetry_inserted
  AFTER INSERT ON public.telemetry
  REFERENCING NEW TABLE AS new_table
  FOR EACH STATEMENT EXECUTE PROCEDURE public.update_stats_on_telemetry_batch();

-- Function: Notify on Reward Unlock (Hardened against null title concatenation)
CREATE OR REPLACE FUNCTION public.notify_on_reward()
RETURNS trigger AS $$
DECLARE
    v_sticker_title text;
BEGIN
    SELECT COALESCE(title, NEW.sticker_id) INTO v_sticker_title FROM public.stickers WHERE id = NEW.sticker_id;
    IF v_sticker_title IS NULL THEN
        v_sticker_title := NEW.sticker_id;
    END IF;

    INSERT INTO public.notifications (user_id, title, content, type)
    VALUES (NEW.user_id, 'Koleksi Baru!', 'Selamat! Kamu baru saja membuka: ' || v_sticker_title, 'reward');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: On Reward Unlock
DROP TRIGGER IF EXISTS on_reward_unlocked ON public.user_stickers;
CREATE TRIGGER on_reward_unlocked
  AFTER INSERT ON public.user_stickers
  FOR EACH ROW EXECUTE PROCEDURE public.notify_on_reward();

-- Stored Procedure: Telemetry Retention Policy (Delete logs older than 30 days)
CREATE OR REPLACE FUNCTION public.clean_old_telemetry()
RETURNS void AS $$
BEGIN
    DELETE FROM public.telemetry WHERE created_at < now() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. INITIAL DATA (Seed)
INSERT INTO public.stickers (id, title, description, requirement_type, requirement_value)
VALUES 
('s1', 'Cyber Sentinel', 'Jaga jarak aman selama 30 menit.', 'focus_time', 1800),
('s2', 'Eye Ninja', 'Gunakan VisionSafe selama 3 hari berturut-turut.', 'streak', 3),
('s3', 'Calibration Master', 'Selesaikan kalibrasi pertama matamu.', 'achievement', 1),
('s4', 'Guardian Soul', 'Kumpulkan 5000 XP.', 'xp', 5000)
ON CONFLICT (id) DO UPDATE SET 
  title = EXCLUDED.title,
  description = EXCLUDED.description;

INSERT INTO public.news (title, content, category)
VALUES 
('Pentingnya Jarak 30cm', 'Menjaga jarak mata minimal 30cm dapat mengurangi risiko miopi pada anak.', 'Edukasi'),
('Aturan 20-20-20', 'Istirahatkan mata setiap 20 menit selama 20 detik.', 'Tips')
ON CONFLICT DO NOTHING;

-- 8. PERFORMANCE & INDEXES
CREATE INDEX IF NOT EXISTS idx_telemetry_user_created ON public.telemetry (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_xp ON public.profiles (xp DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON public.notifications (user_id) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_user_stickers_sticker_id ON public.user_stickers (sticker_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON public.notifications (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_created ON public.news (created_at DESC);
