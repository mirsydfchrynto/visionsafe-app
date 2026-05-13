-- ==========================================
-- VISIONSAFE MASTER SCHEMA (SAFE-START VERSION)
-- Executed by SDA (Supreme Developer Agent)
-- Purpose: Total Database Sync & Security
-- ==========================================

-- 1. ENSURE TABLES EXIST (Pondasi Utama)
-- Dibuat pertama agar DROP POLICY tidak error jika tabel belum ada.
CREATE TABLE IF NOT EXISTS public.telemetry (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    distance float8 NOT NULL,
    is_violation boolean DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_settings (
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    safe_distance float8 DEFAULT 35.0 NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.news (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text NOT NULL,
    content text NOT NULL,
    image_url text,
    source_url text,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- 2. CLEANUP POLICIES (Mencegah Duplikasi)
DROP POLICY IF EXISTS "Users can view their own telemetry" ON public.telemetry;
DROP POLICY IF EXISTS "Users can insert their own telemetry" ON public.telemetry;
DROP POLICY IF EXISTS "Users can manage their own settings" ON public.user_settings;
DROP POLICY IF EXISTS "Anyone can read news" ON public.news;

-- 3. SECURITY ENFORCEMENT (Row Level Security)
ALTER TABLE public.telemetry ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;

-- 4. APPLY POLICIES (Proteksi Data User)
CREATE POLICY "Users can view their own telemetry" ON public.telemetry FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own telemetry" ON public.telemetry FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can manage their own settings" ON public.user_settings FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Anyone can read news" ON public.news FOR SELECT USING (true);

-- 5. INITIAL DATA (Seed)
INSERT INTO public.news (title, content, image_url, source_url)
VALUES 
('Pentingnya Jarak 30cm', 'Menjaga jarak mata minimal 30cm dapat mengurangi risiko miopi pada anak.', 'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8', 'https://kemenkes.go.id'),
('Aturan 20-20-20', 'Setiap 20 menit, istirahatkan mata selama 20 detik dengan melihat benda berjarak 20 kaki.', 'https://images.unsplash.com/photo-1576091160550-2173dba999ef', 'https://who.int')
ON CONFLICT DO NOTHING;

-- 6. PERFORMANCE (Indexing)
CREATE INDEX IF NOT EXISTS idx_telemetry_user_created ON public.telemetry (user_id, created_at DESC);
