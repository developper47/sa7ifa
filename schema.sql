-- ==========================================
-- Production SQL Schema for Fikr Magazine
-- ==========================================

-- 0. ADMIN CHECK FUNCTION
CREATE OR REPLACE FUNCTION public.is_admin() 
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. PROFILES: User Metadata
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  avatar_url TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Trigger to prevent privilege escalation via profiles.role modification
CREATE OR REPLACE FUNCTION public.check_profile_role()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.role <> OLD.role AND NOT (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = auth.uid() AND role = 'admin'
    )
  ) THEN
    RAISE EXCEPTION 'Seuls les administrateurs peuvent modifier le rôle des profils.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER before_profile_update_role
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.check_profile_role();

-- 2. SECTIONS: Editorial Categories
CREATE TABLE IF NOT EXISTS public.sections (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  icon TEXT,
  color TEXT,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.sections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Active sections are viewable by everyone" ON public.sections FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "Admins can manage sections" ON public.sections FOR ALL USING (is_admin());

-- 3. POSTS: Magazine Content
CREATE TABLE IF NOT EXISTS public.posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  excerpt TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT, -- Legacy support during migration
  section_id UUID REFERENCES public.sections ON DELETE SET NULL,
  featured_image_url TEXT,
  author_id UUID REFERENCES auth.users NOT NULL,
  author_name TEXT NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('draft', 'pending', 'needs_revision', 'published', 'rejected', 'archived')),
  is_featured BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Published posts viewable by everyone" ON public.posts FOR SELECT USING (status = 'published');
CREATE POLICY "Authors can view all their posts" ON public.posts FOR SELECT USING (auth.uid() = author_id);
CREATE POLICY "Admins can view all posts" ON public.posts FOR SELECT USING (is_admin());
CREATE POLICY "Users can create posts" ON public.posts FOR INSERT WITH CHECK (auth.uid() = author_id AND (status IN ('draft', 'pending') OR is_admin()));
CREATE POLICY "Authors can update their own drafts/pending" ON public.posts FOR UPDATE 
  USING (auth.uid() = author_id AND (status IN ('draft', 'pending', 'needs_revision')));
CREATE POLICY "Admins can manage all posts" ON public.posts FOR UPDATE USING (is_admin());
CREATE POLICY "Admins can delete posts" ON public.posts FOR DELETE USING (is_admin());

-- 4. COMMENTS: Threaded Discussions
CREATE TABLE IF NOT EXISTS public.comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES public.posts ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users NOT NULL,
  author_name TEXT NOT NULL,
  content TEXT NOT NULL,
  parent_id UUID REFERENCES public.comments ON DELETE CASCADE,
  status TEXT DEFAULT 'approved' CHECK (status IN ('pending', 'approved', 'hidden')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Comments viewable by everyone" ON public.comments FOR SELECT USING (status = 'approved');
CREATE POLICY "Authenticated users can post comments" ON public.comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can moderate comments" ON public.comments FOR ALL USING (is_admin());

-- 5. SITE SETTINGS: Global Configs
CREATE TABLE IF NOT EXISTS public.site_settings (
  id INT PRIMARY KEY DEFAULT 1,
  site_name TEXT DEFAULT 'مجلة فكر',
  default_post_image_url TEXT,
  facebook_app_id TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT one_row CHECK (id = 1)
);

ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Settings are viewable by everyone" ON public.site_settings FOR SELECT USING (true);
CREATE POLICY "Admins can update settings" ON public.site_settings FOR UPDATE USING (is_admin());

-- 6. TRIGGER: Auto-create Profile on Sign Up
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email, role)
  VALUES (new.id, COALESCE(new.raw_user_meta_data->>'full_name', 'مستخدم جديد'), new.email, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
