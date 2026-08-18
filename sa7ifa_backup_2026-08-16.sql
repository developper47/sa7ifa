-- ============================================================
-- SQL Import Script generated from sa7ifa_backup_2026-08-16.json
-- ============================================================

DO $$ 
DECLARE 
    v_user_id UUID;
    v_user_name TEXT;
    v_sec_ideas_id UUID;
    v_sec_politics_id UUID;
    v_sec_health_id UUID;
    v_sec_tech_id UUID;
    v_sec_economy_id UUID;
BEGIN
    -- 1. Get the first user from the profiles table to act as the author
    SELECT id, name INTO v_user_id, v_user_name FROM public.profiles LIMIT 1;

    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'لا يوجد مستخدمون في قاعدة البيانات. يرجى تسجيل حساب أولاً في الموقع قبل تشغيل هذا السكريبت.';
    END IF;

    -- Confirm the admin email and grant admin role
    UPDATE auth.users SET email_confirmed_at = NOW(), confirmed_at = NOW() WHERE email = 'developper47@gmail.com';
    UPDATE public.profiles SET role = 'admin' WHERE email = 'developper47@gmail.com';

    -- Clear existing posts to replace them with the backup
    DELETE FROM public.posts;

    -- 2. Insert Sections
    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order, is_active)
    VALUES ('فكر', 'Ideas', 'ideas', 'حوارات فكرية وفلسفية وتحليلات معمقة للأفكار والتحولات الثقافية', '💡', '#8e44ad', 1, true)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order
    RETURNING id INTO v_sec_ideas_id;

    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order, is_active)
    VALUES ('سياسة', 'Politics', 'politics', 'تحليلات سياسية معمقة وتغطية للشؤون الدولية والعربية', '🏛️', '#c0392b', 3, true)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order
    RETURNING id INTO v_sec_politics_id;

    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order, is_active)
    VALUES ('صحة', 'Health', 'health', 'أخبار وإرشادات طبية وصحية لسلامة الفرد والمجتمع', '🩺', '#27ae60', 4, true)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order
    RETURNING id INTO v_sec_health_id;

    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order, is_active)
    VALUES ('تكنولوجيا', 'Technology', 'tech', 'تغطية شاملة للثورة الرقمية وتأثير التقنيات الناشئة على الإنسان والمجتمع', '💻', '#2980b9', 5, true)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order
    RETURNING id INTO v_sec_tech_id;

    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order, is_active)
    VALUES ('اقتصاد', 'Economy', 'economy', 'تقارير وتحليلات مالية واقتصادية تغطي العالم العربي والأسواق الدولية', '📊', '#2c3e50', 2, true)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order
    RETURNING id INTO v_sec_economy_id;

    -- If section already existed and RETURNING didn't set the variable, select it
    IF v_sec_ideas_id IS NULL THEN
        SELECT id INTO v_sec_ideas_id FROM public.sections WHERE slug = 'ideas';
    END IF;
    IF v_sec_politics_id IS NULL THEN
        SELECT id INTO v_sec_politics_id FROM public.sections WHERE slug = 'politics';
    END IF;
    IF v_sec_health_id IS NULL THEN
        SELECT id INTO v_sec_health_id FROM public.sections WHERE slug = 'health';
    END IF;
    IF v_sec_tech_id IS NULL THEN
        SELECT id INTO v_sec_tech_id FROM public.sections WHERE slug = 'tech';
    END IF;
    IF v_sec_economy_id IS NULL THEN
        SELECT id INTO v_sec_economy_id FROM public.sections WHERE slug = 'economy';
    END IF;

    -- 3. Insert Posts
    -- Post 1: بنية العقل العربي المعاصر: قراءة في فكر ...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'بنية العقل العربي المعاصر: قراءة في فكر محمد عابد الجابري', 
      'structure-of-arab-reason-jabri', 
      'تحليل نقدي لإسهامات الفيلسوف المغربي محمد عابد الجابري في نقد وتفكيك العقل العربي ومصادره المعرفية.', 
      '<p><span class="lettrine">يعد</span> محمد عابد الجابري من أبرز الفلاسفة العرب المعاصرين الذين قاربوا مسألة التراث والحداثة بمشرط النقد المعرفي. في مشروعه الضخم "نقد العقل العربي"، سعى الجابري إلى تتبع النظم المعرفية التي حكمت الثقافة العربية وحصرها في ثلاثة نظم رئيسية: البيان، والعرفان، والبرهان. ويرى الجابري أن تجديد الفكر العربي المعاصر لا يمكن أن يتم عبر القطيعة التامة مع التراث، بل من خلال إعادة قراءته ونقده من الداخل لاستئناف العقلانية البرهانية التي تمثلت قديماً في الرشدية الأندلسية.</p>', 
      v_sec_ideas_id, 
      'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=1200&q=80', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      true, 
      '2026-08-15T19:09:38.591Z', 
      '2026-08-15T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 2: السياسة الدولية في مهب الريح: تشكل موازي...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'السياسة الدولية في مهب الريح: تشكل موازين قوى جديدة', 
      'international-politics-new-powers', 
      'تحليل للتغيرات المتسارعة في السياسة العالمية وصعود الأقطاب المتعددة وتأثير ذلك على استقرار الشرق الأوسط.', 
      '<p><span class="lettrine">تشهد</span> الساحة الدولية تحولات بنيوية متسارعة تعيد صياغة النظام العالمي الذي ساد منذ عقود. إن صعود قوى اقتصادية وعسكرية جديدة وتنامي التحالفات الإقليمية ينبئ بولادة نظام متعدد الأقطاب أكثر تعقيداً. وفي هذا السياق، تواجه دول الشرق الأوسط تحديات وفرصاً تتطلب سياسات خارجية مرنة ترتكز على التوازن الإستراتيجي وحماية المصالح القومية والتنموية.</p>', 
      v_sec_politics_id, 
      'https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=1200&q=80', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-13T19:09:38.591Z', 
      '2026-08-13T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 3: الرعاية الصحية الأولية: حجر الأساس لمستق...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الرعاية الصحية الأولية: حجر الأساس لمستقبل طبي مستدام', 
      'primary-healthcare-sustainable-future', 
      'تقرير شامل عن دور الطب الوقائي وأهمية الاستثمار في المراكز الطبية المحلية للحد من انتشار الأمراض المزمنة.', 
      '<p><span class="lettrine">تمثل</span> الرعاية الصحية الأولية اللبنة الأساسية في بناء نظام صحي عادل ومستدام. تشير الدراسات الطبية إلى أن التركيز على الطب الوقائي والفحص المبكر للأمراض المزمنة يسهم بشكل مباشر في خفض تكاليف العلاج وتحسين جودة حياة المواطنين. إن تطوير المراكز الطبية المحلية وتأهيل الكوادر البشرية في مجالات الرعاية الصحية يعد استثماراً وطنياً لا غنى عنه.</p>', 
      v_sec_health_id, 
      'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=1200&q=80', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-12T19:09:38.591Z', 
      '2026-08-12T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 4: الذكاء الاصطناعي التوليدي: هل نحن أمام ث...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الذكاء الاصطناعي التوليدي: هل نحن أمام ثورة معرفية جديدة؟', 
      'ethics-of-ai-arab-digital-space', 
      'تساؤلات فلسفية وتقنية حول حدود الذكاء الاصطناعي، والمسؤولية الأخلاقية للأنظمة الذكية، وتأثيرها على الهوية المجتمعية.', 
      '<p><span class="lettrine">لم</span> يعد الذكاء الاصطناعي مجرد تقنية جديدة، بل أصبح قوة فاعلة تشكل معالم وجودنا الإنساني والرقمي. وفي حين تتسابق المؤسسات العربية لتبني حلول الذكاء الاصطناعي لزيادة الكفاءة، تبرز قضايا أخلاقية بالغة التعقيد حول الخصوصية، والتحيز الخوارزمي، وحماية الهوية الثقافية. يتطلب هذا التحول الرقمي بناء أطر أخلاقية تتوافق مع القيم والمبادئ للتعامل مع تحديات الذكاء التوليدي والتشغيل الذاتي.</p>', 
      v_sec_tech_id, 
      'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=1200&q=80', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-11T19:09:38.591Z', 
      '2026-08-11T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 5: الثقافة العربية في مواجهة العولمة: هوية ...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الثقافة العربية في مواجهة العولمة: هوية أم انفتاح؟', 
      'arabic-culture-globalization', 
      'تستوقفنا مسألة الهوية الثقافية العربية في خضم موجات العولمة المتلاحقة التي تعيد تشكيل الوعي الجمعي.', 
      '<p>يعيش العالم العربي تحولات جذرية في بنيته الثقافية، بين من يرى في الانفتاح فرصة لإثراء الهوية وتحديثها دون المساس بجوهرها، وبين من يحذر من الذوبان الثقافي وضياع الخصوصية الحضارية. تبقى المعادلة صعبة تستدعي تفكيراً هادئاً ورصيناً بعيداً عن الانفعال والإقصاء.</p>', 
      v_sec_ideas_id, 
      'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=800&q=80', 
      v_user_id, 
      'د. ليلى مصطفى', 
      'published', 
      false, 
      '2026-08-10T19:09:38.591Z', 
      '2026-08-10T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 6: النقد الأدبي العربي بين المنهج الغربي وا...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'النقد الأدبي العربي بين المنهج الغربي والأصالة', 
      'arabic-literary-criticism', 
      'هل يمكن للنقد الأدبي أن ينهل من المناهج الغربية دون أن يُغرّب النص العربي ويُجرّده من روحه؟ إشكالية تشغل الدراسات الأدبية.', 
      '<p>شكّل مفهوم المنهج النقدي إشكالية مركزية في الدراسات الأدبية العربية الحديثة. فمنذ انفتح النقد العربي على المدارس الغربية كالبنيوية والتفكيكية وما بعد الاستعمارية، بات السؤال قائماً: أين تقع الهوية النقدية العربية في هذا الزخم من المناهج الوافدة؟</p>', 
      v_sec_ideas_id, 
      'https://images.unsplash.com/photo-1524995997946-a1172ddbc0bf?w=800&q=80', 
      v_user_id, 
      'أ. كمال الدين', 
      'published', 
      false, 
      '2026-08-09T19:09:38.591Z', 
      '2026-08-09T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 7: فلسفة الزمن عند ابن رشد: قراءة في الأصول...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'فلسفة الزمن عند ابن رشد: قراءة في الأصول', 
      'ibn-rushd-time-philosophy', 
      'يعود هذا المقال إلى تراث ابن رشد ليستجلي نظريته في الزمن والحركة الكونية ومدى تقاطعها مع الفيزياء الحديثة.', 
      '<p>يُعدّ ابن رشد من أكثر الفلاسفة العرب تأثيراً في الفكر الغربي الوسيط، غير أن منظومته الفلسفية الخاصة بالزمن والحركة والكون لا تزال تستحق المزيد من الدراسة والتمحيص.</p>', 
      v_sec_ideas_id, 
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80', 
      v_user_id, 
      'د. نور الإسلام', 
      'published', 
      false, 
      '2026-08-08T19:09:38.591Z', 
      '2026-08-08T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 8: الانتخابات والديمقراطية في العالم العربي...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الانتخابات والديمقراطية في العالم العربي: واقع وآفاق', 
      'elections-democracy-arab', 
      'دراسة مقارنة للمسارات الديمقراطية في عدد من الدول العربية والعوامل المؤثرة في جودة العملية الانتخابية.', 
      '<p>تتباين التجارب الديمقراطية في العالم العربي تبايناً كبيراً؛ بين من اجتازت عتبة الانتقال الديمقراطي بخطوات ثابتة وإن متعثرة، وبين من لا تزال تتلمس طريقها وسط إكراهات بنيوية عميقة.</p>', 
      v_sec_politics_id, 
      'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=800&q=80', 
      v_user_id, 
      'علاء منصور', 
      'published', 
      false, 
      '2026-08-10T19:09:38.591Z', 
      '2026-08-10T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 9: الجيوسياسة الإقليمية: محاور التوافق والص...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الجيوسياسة الإقليمية: محاور التوافق والصراع', 
      'regional-geopolitics', 
      'خريطة التحالفات الإقليمية تتشكل من جديد في ظل تغير موازين القوى وتقاطع مصالح متباينة في ملفات الأمن والطاقة.', 
      '<p>تتشكل الجغرافيا السياسية الإقليمية من جديد في ضوء التقلبات المتسارعة التي تشهدها المنطقة. إن التنافس بين القوى الإقليمية والدولية على ملفات الطاقة والممرات التجارية يُعيد رسم خرائط التحالف والصراع.</p>', 
      v_sec_politics_id, 
      'https://images.unsplash.com/photo-1575320181282-9afab399332c?w=800&q=80', 
      v_user_id, 
      'هند الشامي', 
      'published', 
      false, 
      '2026-08-09T19:09:38.591Z', 
      '2026-08-09T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 10: حوكمة المدن الكبرى: تحديات الإدارة المحل...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'حوكمة المدن الكبرى: تحديات الإدارة المحلية في العالم العربي', 
      'arab-city-governance', 
      'تعاني المدن العربية الكبرى من ضغوط التحضر السريع، فأين تقع مسؤولية الحوكمة المحلية في تحسين جودة حياة المواطن؟', 
      '<p>تتفاقم تحديات الحوكمة الحضرية في ظل التوسع الديموغرافي المتسارع وضغوط الهجرة الداخلية. إن ضمان الخدمات الأساسية وتوزيع عادل للموارد باتا مطالب لا يمكن للإدارات المحلية تجاوزها.</p>', 
      v_sec_politics_id, 
      'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&q=80', 
      v_user_id, 
      'رامي الخليل', 
      'published', 
      false, 
      '2026-08-08T19:09:38.591Z', 
      '2026-08-08T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 11: الصحة النفسية في الوطن العربي: كسر صمت ا...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الصحة النفسية في الوطن العربي: كسر صمت الوصمة', 
      'mental-health-arab-stigma', 
      'لا تزال الاضطرابات النفسية محاطة بالوصمة الاجتماعية في كثير من المجتمعات العربية مما يُقلل من فرص طلب المساعدة.', 
      '<p>تكشف الإحصاءات أن نحو 30٪ من العرب يعانون شكلاً من أشكال الاضطرابات النفسية، غير أن قرابة 80٪ منهم لا يلتمسون أي مساعدة متخصصة. يُشكّل الخوف من الوصمة الاجتماعية عقبة رئيسية.</p>', 
      v_sec_health_id, 
      'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80', 
      v_user_id, 
      'د. منار الجميل', 
      'published', 
      false, 
      '2026-08-10T19:09:38.591Z', 
      '2026-08-10T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 12: الغذاء والسرطان: ماذا تقول الدراسات الحد...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الغذاء والسرطان: ماذا تقول الدراسات الحديثة؟', 
      'food-cancer-research', 
      'تزخر الأبحاث الطبية الحديثة بمعطيات جديدة حول العلاقة بين النظام الغذائي وخطر الإصابة بالسرطان.', 
      '<p>بات من الثابت علمياً أن نمط الغذاء يلعب دوراً محورياً في تنظيم المخاطر الصحية. فالأغذية الغنية بمضادات الأكسدة والألياف تمثل درعاً وقائية طبيعية تشير إليها دراسات نُشرت في أرقى المجلات الطبية.</p>', 
      v_sec_health_id, 
      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80', 
      v_user_id, 
      'د. سلوى حميدان', 
      'published', 
      false, 
      '2026-08-09T19:09:38.591Z', 
      '2026-08-09T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 13: الوقاية من السكري: دليل عملي للأسرة العر...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الوقاية من السكري: دليل عملي للأسرة العربية', 
      'diabetes-prevention-guide', 
      'ينتشر داء السكري بمعدلات مقلقة في العالم العربي. نقدم دليلاً علمياً بسيطاً حول أساليب الوقاية والتغذية السليمة.', 
      '<p>يُعدّ داء السكري من أكثر الأمراض المزمنة انتشاراً في المجتمعات العربية، إذ تشير تقارير منظمة الصحة العالمية إلى أن 1 من كل 6 بالغين مصاب أو في خطر مرتفع للإصابة. الغذاء الصحي والنشاط البدني يقلصان هذه المخاطر.</p>', 
      v_sec_health_id, 
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80', 
      v_user_id, 
      'صحة ورياضة', 
      'published', 
      false, 
      '2026-08-08T19:09:38.591Z', 
      '2026-08-08T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 14: أمن المعلومات في عصر الهجمات الإلكترونية...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'أمن المعلومات في عصر الهجمات الإلكترونية المتطورة', 
      'infosec-cyberattacks', 
      'تتصاعد الهجمات السيبرانية استهدافاً للبنى التحتية الحيوية، وتعاظم التهديدات يستلزم تحديثاً جذرياً لاستراتيجيات الأمن الرقمي.', 
      '<p>تكشف التقارير الدولية عن تصاعد حاد في عدد الهجمات الإلكترونية الموجهة ضد البنى التحتية للدول العربية. يتراوح الاستهداف بين شبكات الطاقة والقطاعات المالية وصولاً إلى منظومات البيانات الحكومية.</p>', 
      v_sec_tech_id, 
      'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80', 
      v_user_id, 
      'م. طارق السعيد', 
      'published', 
      false, 
      '2026-08-10T19:09:38.591Z', 
      '2026-08-10T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 15: الميتافيرس: بين الوعد الرقمي وتحديات الو...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الميتافيرس: بين الوعد الرقمي وتحديات الواقع', 
      'metaverse-promise-reality', 
      'هل يملك الميتافيرس القدرة على إحداث نقلة نوعية في طرق العمل والتعليم والترفيه، أم أنه مجرد موضة عابرة؟', 
      '<p>منذ أن أعادت شركة فيسبوك تسمية نفسها بـ ''ميتا'' إعلاناً عن توجهها نحو عالم افتراضي شامل، صار الميتافيرس حديث كل التقنيين والمستثمرين. غير أن التساؤلات تبقى قائمة حول الجدوى الفعلية لهذه البيئات الرقمية.</p>', 
      v_sec_tech_id, 
      'https://images.unsplash.com/photo-1633356122102-3fe601e05bd2?w=800&q=80', 
      v_user_id, 
      'نور الهدى', 
      'published', 
      false, 
      '2026-08-09T19:09:38.591Z', 
      '2026-08-09T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 16: البلوك تشين والعملات الرقمية: قراءة في ا...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'البلوك تشين والعملات الرقمية: قراءة في المشهد العربي', 
      'blockchain-crypto-arab', 
      'شهدت المنطقة العربية اهتماماً متزايداً بتقنية البلوك تشين والعملات الرقمية. نستعرض واقع التبني والفرص والتحديات التنظيمية.', 
      '<p>تتبنى عدة دول عربية تقنية البلوك تشين في قطاعات الخدمات الحكومية والمالية والعقارية، بينما تتباين المواقف التنظيمية من العملات الرقمية بين التشجيع الحذر والتقييد الصريح.</p>', 
      v_sec_tech_id, 
      'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=800&q=80', 
      v_user_id, 
      'أحمد الزهراني', 
      'published', 
      false, 
      '2026-08-08T19:09:38.591Z', 
      '2026-08-08T19:09:38.591Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 17: استراتيجية الصين تجاه الذهب: من شراء الم...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'استراتيجية الصين تجاه الذهب: من شراء المعدن إلى بناء نظام مالي جديد', 
      '--msv7hnn7', 
      '
                  <a name="_b', 
      '
                  <h1 align="center" dir="RTL" style="margin:0cm;text-align:center;mso-pagination:
widow-orphan;page-break-after:auto;direction:rtl;unicode-bidi:embed"><a name="_b0t10sani0gb"></a></h1><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;
line-height:115%">في 24 يوليو 2026، اتخذت أكبر بنوك الصين، وعلى رأسها البنك
الصناعي والتجاري الصيني (</span><span lang="fr" dir="LTR" style="font-size:12.0pt;
line-height:115%">ICBC</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:115%"><span dir="RTL"></span><span dir="RTL"></span>) -وهو أكبر بنك في العالم من حيث الأصول- قرارًا مفاجئًا: وقف
تداول الذهب الورقي لعملائها الأفراد بشكل كامل. وقبل ذلك بأيام قليلة، كانت هونغ
كونغ قد أعلنت خبرًا آخر: إطلاق نظام مقاصة وتسوية مركزي جديد للذهب، يدعمه 11
بنكًا كبيرًا. الخبران مرتبطان ببعضهما ارتباطًا مباشرًا، وهما جزء من مشروع واحد
أكبر بكثير: لماذا أصبحت الصين، ثاني أكبر اقتصاد في العالم، تراهن بهذا الشكل على
معدن عمره آلاف السنين؟ وما علاقة كل هذا بالدولار الأمريكي، الذي يحكم قبضته على
التجارة العالمية منذ عقود؟ إنها محاولة صينية مدروسة وطويلة النفس لبناء نظام
مالي بديل، يقوم بأكمله حول الذهب، ويهدف في نهاية المطاف إلى تقليل اعتماد العالم
على الدولار الأمريكي. ولفهم هذه الاستراتيجية، يجب أن نبدأ من نقطة أساسية: الفرق
بين "الذهب الذي تراه" و"الذهب الذي لا تراه".</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_28b2ece46bfi"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">الذهب الورقي والذهب
الحقيقي: لماذا يهم الفرق؟</span></b><b><span lang="fr" dir="LTR" style="font-size:
12.0pt;line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">عندما يرغب
معظم المستثمرين اليوم في شراء الذهب، فإنهم لا يشترون المعدن نفسه، بل يشترون
حقًا ماليًا مرتبطًا به. ويتم ذلك عبر عقود أو شهادات أو صناديق استثمار تمنحهم
الاستفادة من تغيرات سعر الذهب، من دون أن يحصلوا على أي سبيكة أو قطعة ذهبية. ويُطلق
على هذا النوع من الاستثمار اسم <b>"الذهب الورقي"</b>، وهو يشكل الجزء
الأكبر من التداول العالمي على الذهب. ففي بورصات كبرى مثل لندن ونيويورك، يجري
تداول عقود تمثل كميات ضخمة من الذهب، بينما لا يقابل جزء كبير منها ذهب مادي جاهز
للتسليم، بل مجرد التزام أو وعد مالي مرتبط بقيمة الذهب. المشكلة أن حجم هذه
العقود الورقية يفوق كمية الذهب الحقيقي المتوفر فعليًا بفارق كبير جدًا، قد يصل
بحسب بعض التقديرات إلى تسعة أضعاف أو أكثر. بمعنى آخر: لكل كيلوغرام واحد من
الذهب الحقيقي المخزّن في القبو، قد توجد عقود ورقية تعادل تسعة كيلوغرامات أو
أكثر يتم تداولها والمراهنة عليها. يشبّه بعض المحللين هذا الوضع
بـ"كازينو" ضخم، حيث يتحدد سعر الذهب عالميًا ليس بناءً على من يشتري
ذهبًا حقيقيًا ويحمله بين يديه، بل بناءً على تدفق هائل من المضاربات الورقية التي
لا علاقة مباشرة لمعظمها بمعدن فعلي. هذا النظام له نتيجة مهمة: من يتحكم في تداول
هذه العقود الورقية -وهما بورصتا </span><span lang="fr" dir="LTR" style="font-size:
12.0pt;line-height:115%">LBMA</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:115%"><span dir="RTL"></span><span dir="RTL"></span>&nbsp; بلندن و </span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%">COMEX</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:115%"><span dir="RTL"></span><span dir="RTL"></span> بنيويورك- يملك
عمليًا التأثير الأكبر في تحديد سعر الذهب عالميًا، حتى لو لم يكن هو من يملك أكبر
كمية من المعدن نفسه. وهنا بالضبط تبدأ الخطوة الصينية الأولى والأكثر إثارة
للدهشة.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_nrobwwbmrz32"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">الخطوة الأولى: الصين تغلق
"كازينو" الذهب الورقي أمام أفرادها</span></b><b><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">ابتداءً من 24
يوليو 2026، بدأت كبرى البنوك الصينية، وعلى رأسها البنك الصناعي والتجاري الصيني
(</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%">ICBC</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:115%"><span dir="RTL"></span><span dir="RTL"></span>) -وهو أكبر بنك في
العالم من حيث الأصول- وبنك الادخار البريدي الصيني، في وقف خدمة تداول المعادن
النفيسة الورقية لعملائها الأفراد عبر بورصة شنغهاي للذهب. طُلب من هؤلاء العملاء
تصفية مراكزهم، أي بيع عقودهم الورقية وتحويلها إلى نقد، قبل الموعد المحدد. بنوك أخرى
مثل بنك تشاينا غوانغفا سارت في المسار نفسه. قد يبدو هذا القرار للوهلة الأولى
وكأنه تضييق على عامة الناس في الصين ومنعهم من الاستثمار في الذهب. لكن الحقيقة
مختلفة تمامًا: فالصين لا تمنع الأفراد من امتلاك الذهب أو الاستثمار فيه، بل
تحديدًا تمنعهم من نوع واحد فقط من التداول، وهو المراهنة الورقية السريعة التي لا
يقابلها ذهب حقيقي. الهدف المعلن هو الوصول إلى ما يمكن تسميته بـ"الاكتشاف
الحقيقي للسعر"، أي أن يتحدد سعر الذهب في السوق الصينية بناءً على العرض
والطلب على المعدن الفعلي وحده، بعيدًا عن ضجيج المضاربات الورقية التي تصنعها
بورصات أخرى بعيدة جغرافيًا وسياسيًا عن الصين. بعبارة أبسط: تخيل أن سعر الأرز في
بلدك يحدده تجار في بلد آخر يتاجرون بـ"عقود أرز" لا علاقة لها فعليًا
بأكياس الأرز الموجودة في مخازنك. من الطبيعي أن ترغب الصين -وهي من أكبر مستهلكي
ومنتجي الذهب في العالم- في أن يكون لسعر الذهب الذي يتعامل به أفرادها وبنوكها
علاقة مباشرة بالمعدن الحقيقي الموجود على أرضها، لا بالمضاربات</span><span dir="LTR"></span><span dir="LTR"></span><span lang="AR-SA" dir="LTR" style="font-size:
12.0pt;line-height:115%"><span dir="LTR"></span><span dir="LTR"></span> </span><span lang="AR-AE" style="font-size:12.0pt;line-height:115%;mso-bidi-language:AR-AE">الوهمية</span><span lang="AR-SA" style="font-size:12.0pt;line-height:115%"> البعيدة.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_kk657mi3hdae"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">الخطوة الثانية: بناء
"مصنع الذهب الفعلي" في هونغ كونغ</span></b><b><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">إذا كانت
الخطوة الأولى تتعلق بإغلاق باب المضاربة الورقية، فإن الخطوة الثانية أكثر طموحًا
بكثير: بناء بنية تحتية كاملة للتعامل مع الذهب الحقيقي، الذي يمكن لمسه ونقله
وتخزينه فعليًا. ومسرح هذه الخطوة هو هونغ كونغ، المدينة التي تتمتع بموقع خاص
كجسر بين الصين القارية -حيث القيود على حركة رؤوس الأموال لا تزال صارمة- وبين
بقية العالم.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:
115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">الخطة هنا
واضحة الأرقام: تسعى هونغ كونغ إلى رفع قدرتها على تخزين الذهب من نحو 200 طن
حاليًا إلى 2000 طن خلال ثلاث سنوات فقط. ولتقريب حجم هذا الرقم إلى الذهن: 2000
طن من الذهب تعادل تقريبًا 55% من إجمالي إنتاج مناجم الذهب في العالم كله خلال
عام كامل. بمعنى آخر، تريد هونغ كونغ وحدها أن تكون قادرة على تخزين ما يقارب نصف
الإنتاج العالمي السنوي من الذهب في خزائنها.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">ولكي تعمل هذه
الخزائن الضخمة بكفاءة، لا يكفي بناء المستودعات فقط، بل يجب أيضًا وجود نظام يضمن
انتقال ملكية هذا الذهب بسرعة وأمان بين المشترين والبائعين، تمامًا كما يحتاج أي
سوق كبير إلى نظام مصرفي يسمح بتحويل الأموال. هنا يأتي دور "نظام المقاصة
والتسوية"، وهو ببساطة الآلية التي تتأكد من أن الذهب انتقل فعليًا من طرف
إلى آخر، وأن الأموال المقابلة له انتقلت في الاتجاه المعاكس، دون أن يخسر أحد
الطرفين حقه. تم بالفعل إطلاق نظام مقاصة وتسوية مركزي للذهب في هونغ كونغ، تدعمه
11 بنكًا، ويرتبط مباشرة ببورصة شنغهاي للذهب عبر آلية أُطلق عليها اسم "</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%">Delivery Connect</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:115%"><span dir="RTL"></span><span dir="RTL"></span>" أي
"رابط التسليم"، وهي تسمح بأن يشتري مستثمر في هونغ كونغ ذهبًا ويحصل
عليه فعليًا مرتبطًا بمخزون البورصة في شنغهاي، دون تعقيدات إدارية طويلة. الأهم
من ذلك أن هذا النظام يفتح الباب أمام المستثمرين الأجانب للوصول إلى السوق
الصينية للذهب والتعامل بالذهب الفعلي، متجاوزين بذلك القيود التقليدية الصارمة
التي تفرضها الصين القارية عادة على حركة رؤوس الأموال الداخلة والخارجة من
حدودها. بعبارة أخرى: هونغ كونغ تعمل هنا كـ"منفذ آمن ومرن"، يتيح
للعالم الخارجي التعامل مع النظام الذهبي الصيني دون الاصطدام بجدار القيود
المالية الصينية المعتاد.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;
line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_jy7ytz7r60zq"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">لماذا لا تكتفي الصين بشراء
الذهب فقط؟</span></b><b><span lang="fr" dir="LTR" style="font-size:12.0pt;
line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">قد يسأل
القارئ هنا: إذا كان الهدف هو امتلاك ذهب أكثر، فلماذا لا تكتفي الصين بأن يشتري
بنكها المركزي كميات ضخمة من الذهب ويخزنها في خزائنه، بدلًا من كل هذا التعقيد في
بناء بورصات وأنظمة مقاصة وخزائن دولية؟</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">الإجابة تكمن
في الفرق بين "الامتلاك" و"النفوذ". فامتلاك الذهب وحده يمنح
الصين حماية لاحتياطياتها الخاصة من التقلبات ومن مخاطر العقوبات المالية
المحتملة، وهذا مهم بالفعل، خصوصًا بعد أن رأى العالم كيف تم تجميد أصول البنك
المركزي الروسي المودعة في الدول الغربية عقب اندلاع الحرب في أوكرانيا عام 2022.
لكن هذا وحده لا يمنح الصين أي دور في تحديد "قواعد اللعبة" العالمية
لتجارة الذهب، وهو الدور الذي احتكرته منذ عقود مراكز مالية غربية مثل لندن. فبناء
بورصة، وخزائن، وأنظمة تسوية، ونظام تسعير مستقل، يعني أن الصين لم تعد مجرد
"مشتري كبير" يتلقى الأسعار التي تحددها أسواق أخرى، بل أصبحت
"صانع سوق" له قواعده الخاصة، يمكن لدول أخرى أن تختار التعامل معه
كبديل عن النظام الغربي التقليدي. وهذا بالضبط ما تحاول بكين تحقيقه: الانتقال من
موقع "المستهلك الكبير" إلى موقع "المحور الذي تدور حوله تجارة
الذهب في آسيا وربما العالم"، تمامًا كما يمكن لتاجر أن يقرر الانتقال من
مجرد شراء البضاعة بسعر يحدده غيره، إلى بناء سوقه الخاص الذي يبيع فيه ويشتري
بشروطه هو.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:
115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_foe69zojxlxl"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">القطعة الأخيرة في اللغز:
ربط اليوان بالذهب</span></b><b><span lang="fr" dir="LTR" style="font-size:12.0pt;
line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">نصل الآن إلى
الهدف الأعمق والأبعد مدى في هذه الاستراتيجية بأكملها: عملة الصين نفسها، اليوان.
فرغم أن الصين هي ثاني أكبر اقتصاد في العالم وأكبر دولة تجارية على وجه الأرض
تقريبًا، فإن عملتها لا تحظى بنفس مستوى الثقة العالمية التي يحظى بها الدولار
الأمريكي أو حتى اليورو. والسبب بسيط: الحكومة الصينية تسيطر سيطرة كبيرة على قيمة
اليوان وحركته، وهو ما يجعل كثيرًا من الدول والمستثمرين حول العالم أقل اطمئنانًا
للاحتفاظ به كاحتياطي أو استخدامه في تجارتهم الدولية، مقارنة بعملة كالدولار
التي، رغم كل الانتقادات الموجهة لسياسة الاحتياطي الفيدرالي الأمريكي، لا تزال
الأكثر قبولًا وثقة عالميًا. هنا يأتي دور الذهب كأداة لحل هذه المعضلة تحديدًا.
فكرة الصين، كما تشير المصادر، هي أن ربط اليوان بكميات ضخمة من الذهب المادي
المخزّن فعليًا في هونغ كونغ وشنغهاي، يمنح العالم ما يشبه "ضمانة من
الباطن": حتى لو لم تُعلن الصين رسميًا عودة إلى نظام "الغطاء
الذهبي" الذي كان معمولًا به قبل عام 1971 (حين كان الدولار الأمريكي نفسه
مرتبطًا بكمية محددة من الذهب قبل أن يلغي الرئيس الأمريكي ريتشارد نيكسون هذا
الارتباط)، فإن وجود احتياطيات ذهبية هائلة، وبنية تحتية كاملة لتداولها وتسليمها
فعليًا، يبعث برسالة ثقة ضمنية لكل من يتعامل باليوان: هذه العملة مدعومة بشيء
ملموس وحقيقي، وليست مجرد أوراق تطبعها الحكومة.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">بهذا المعنى،
فإن كل الخطوات التي استعرضناها -إغلاق التداول الورقي، بناء الخزائن الضخمة،
إنشاء أنظمة المقاصة والتسليم الفعلي، تسهيل استيراد الذهب عبر تمديد التصاريح
والسماح لمزيد من الموانئ بتمرير الشحنات، والربط الوثيق بين شنغهاي وهونغ كونغ-
ليست خطوات منفصلة، بل حلقات في سلسلة واحدة متماسكة، هدفها النهائي أن يصبح
اليوان، مدعومًا بالذهب، خيارًا أكثر جاذبية وموثوقية في التجارة الدولية.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_u0k49jhkdqy4"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">ما الذي تسعى الصين إلى
تحقيقه؟ </span></b><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:
115%"><o:p></o:p></span></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">تسعى الصين
بهذه الخيارات إلى بناء "طريق بديل" بجانب الطريق الرئيسي القائم، طريق
تدريجي يتسع شيئًا فشيئًا، ويصبح خيارًا أكثر جاذبية لدول معينة -خصوصًا تلك التي
تخشى من احتمال تعرضها لعقوبات مالية غربية، أو تلك الباحثة عن تنويع احتياطياتها
بعيدًا عن الاعتماد الكامل على عملة واحدة. بعبارة أخرى، الهدف الصيني ليس أن
يستيقظ العالم غدًا ويجد الدولار قد سقط، بل أن يبني تدريجيًا نظامًا موازيًا،
بحيث كلما ازدادت الشكوك حول استقرار النظام المالي الغربي أو ازدادت التوترات
الجيوسياسية، وجدت دول العالم بديلًا جاهزًا ومكتمل الأركان يمكنها اللجوء إليه
جزئيًا أو كليًا. هذا التوجه ليس مجرد تكهنات، بل تؤكده الأرقام على أرض الواقع.
فبنك الشعب الصيني (البنك المركزي) واصل شراء الذهب بشكل صافٍ لمدة عشرين شهرًا
متتاليًا حتى نهاية يونيو 2026، حتى في الوقت الذي كان فيه يغلق أبواب المضاربة
الورقية أمام الأفراد داخل الصين. ووفق الأرقام الرسمية، أضاف البنك المركزي إلى
احتياطياته 44.17 طنًا خلال عام 2024 وحده، ليصل رصيده المعلن إلى نحو 2280 طنًا،
وهو ما جعل الصين تحتل المرتبة السادسة عالميًا من حيث حجم احتياطيات الذهب. لكن
اللافت أن كثيرًا من المحللين يرون أن الرقم الحقيقي أكبر بكثير من الرقم المعلن:
إذ تشير بعض التقديرات إلى أن الصين تشتري منذ اندلاع الحرب في أوكرانيا كميات من
الذهب تقارب خمسة أضعاف ما تفصح عنه رسميًا لصندوق النقد الدولي، وأن احتياطياتها
الفعلية قد تصل إلى ما يقارب 5400 طن. وفي الربع الثالث من عام 2025 وحده، قفزت مشتريات
البنك المركزي بنسبة 55% على أساس سنوي، وهو ما يجعله المحرك الأكبر منفردًا وراء
صعود أسعار الذهب عالميًا إلى مستويات قياسية. هذا الحجم الهائل من الشراء المستمر
ليس مجرد تحوّط تقليدي، بل هو الوقود الذي يغذي كل الخطوات الأخرى التي
استعرضناها: فبلا كمية كافية من الذهب الفعلي، تبقى كل هذه الخزائن وأنظمة التسوية
مجرد هياكل فارغة، وهو ما يؤكد أن الهدف ليس الانسحاب من سوق الذهب، بل إعادة
تشكيله بالكامل بما يخدم المصالح الاستراتيجية الصينية طويلة الأمد.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><h2 dir="RTL" style="margin: 0cm; break-after: auto; direction: rtl; unicode-bidi: embed;"><a name="_w3raa7y0r5qq"></a><b><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">خلاصة: لعبة طويلة النفس لا
معركة سريعة</span></b><b><span lang="fr" dir="LTR" style="font-size:12.0pt;
line-height:115%"><o:p></o:p></span></b></h2><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">حين نجمع كل
هذه الخيوط معًا -إغلاق الذهب الورقي، وبناء الخزائن الضخمة في هونغ كونغ، وإنشاء
أنظمة المقاصة والتسليم الفعلي، وتسهيل الاستيراد، والربط العضوي بين بورصة شنغهاي
وهونغ كونغ- تتضح الصورة الكاملة: الصين لا تلعب لعبة قصيرة المدى تهدف إلى تحقيق
أرباح سريعة من ارتفاع سعر الذهب، بل تخوض مشروعًا استراتيجيًا طويل النفس، يمتد
على مدى سنوات إن لم يكن عقودًا، هدفه النهائي هو تحويل الذهب من مجرد "أصل
استثماري" إلى "ركيزة ثقة" تُبنى حولها منظومة مالية بديلة، مركزها
آسيا لا الغرب، وعملتها المحورية هي اليوان لا الدولار وحده.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;line-height:115%">هذا لا يعني
أن هذه الاستراتيجية ستنجح بالضرورة بالكامل، أو أنها ستحقق أهدافها في الإطار
الزمني الذي تطمح إليه بكين. فالثقة العالمية في عملة ما لا تُبنى بقرارات إدارية
أو بخزائن ذهب وحدها، بل تحتاج إلى شفافية واستقرار سياسي واقتصادي طويل الأمد،
وهي أمور لا تزال محل تساؤل بالنسبة للنظام الصيني في نظر كثير من المستثمرين
الدوليين. لكن ما هو مؤكد أن العالم يشهد اليوم أحد أكثر التحولات جدية وتنظيمًا
في مسار سوق الذهب العالمي منذ عقود، وأن الصين، سواء نجحت في تحقيق كامل طموحها
أم لا، قد وضعت بالفعل حجر الأساس لنظام مالي موازٍ، يتقدم خطوة بخطوة، بصبر
وتخطيط، نحو هدف واحد واضح: ألا يبقى الدولار الأمريكي هو الخيار الوحيد المتاح
أمام العالم.</span><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:
115%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p>&nbsp;</o:p></span></p><p>











































</p><p class="MsoNormal" dir="RTL" style="direction: rtl; unicode-bidi: embed;"><span lang="fr" dir="LTR" style="font-size:12.0pt;line-height:115%"><o:p>&nbsp;</o:p></span></p>
                ', 
      v_sec_economy_id, 
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJTn3uGayO9WgWMaDaGz9gH0wa9Baw3Js9tcFQYUhXrQ&s=10', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-16T16:21:55.130Z', 
      '2026-08-16T02:49:08.084Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 18: وهم السوق الحر: قراءة في الاحتكار المقنع...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'وهم السوق الحر: قراءة في الاحتكار المقنع داخل الرأسمالية', 
      '--msv7koj0', 
      '
                  <span lang="AR-SA" style="font-s', 
      '
                  <p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size: 12pt; font-family: Arial, sans-serif; color: rgb(31, 31, 31);">في النظام
الرأسمالي، الشركات الكبرى ليست مجرد مجموعة فاعلين اقتصاديين يسعون إلى الربح
داخل السوق، بل تحولت إلى قوى بنيوية قادرة على التأثير العميق في السياسات
العامة، تشكيل الأسواق، والتحكم في تدفق المعلومات والرأي العام. هذا النفوذ لم
يكن نتيجة الصدفة أو الكفاءة وحدها، بل هو حصيلة تراكم تاريخي لرأس المال،
واستفادة ذكية من القوانين، ولوبيينغ مكثف، إضافة إلى تحالفات مباشرة وغير مباشرة
مع المؤسسات السياسية والإعلامية. عند النظر إلى تجربتي الولايات المتحدة وفرنسا،
يتضح أن هذا النموذج لم يكن استثناء، بل هو أحد السمات الأساسية الهيكلية للنظام
الإقتصادي الرأسمالي</span><span dir="LTR" style="font-size: 1.1rem;"></span><span dir="LTR" style="font-size: 1.1rem;"></span><span lang="FR" dir="LTR" style="font-size: 12pt; font-family: Arial, sans-serif; color: rgb(31, 31, 31);"><span dir="LTR"></span><span dir="LTR"></span>.</span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في
الولايات المتحدة، تتجلى الهيمنة الاقتصادية بشكل صارخ في قطاع التكنولوجيا. خمس
شركات فقط، وهي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Apple </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Microsoft </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Google </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Amazon </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، تتحكم اليوم في أكثر من نصف القيمة السوقية
لقطاع التكنولوجيا الأمريكي. هذا التركز غير المسبوق للثروة والقيمة يمنح هذه
الشركات قدرة هائلة على توجيه السوق، فرض معاييرها، والتحكم في وتيرة الابتكار. في
التجارة الإلكترونية، تستحوذ</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Amazon </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وحدها على
أكثر من 38 بالمئة من السوق الأمريكية، ما يجعلها بوابة شبه إجبارية لأي بائع أو
علامة تجارية تريد الوصول إلى المستهلك. أما في مجال الإعلانات الرقمية، فإن</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">تتحكمان معا فيما يقارب نصف السوق، وهو ما
يعني أن الجزء الأكبر من تمويل الإعلام الرقمي والمحتوى يمر عبر منصاتهما
وخوارزمياتهما</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">ولا تقتصر
هيمنة الشركات الكبرى في الولايات المتحدة على الإعلام والتكنولوجيا فقط، بل تمتد
بعمق إلى قطاعات حيوية تمس حياة الناس اليومية بشكل مباشر، وعلى رأسها قطاع
الأدوية، الطاقة، والنظام البنكي، حيث يتحول منطق السوق الحر نظريا إلى احتكارات
فعلية تفرض الأسعار، تتحكم في القوانين، وتؤثر في القرار السياسي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في قطاع
الأدوية، أو ما يعرف بـ</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Big Pharma</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>،
تسيطر مجموعة صغيرة جدا من الشركات على الجزء الأكبر من السوق الأمريكية
والعالمية. شركات مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Pfizer </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Johnson &amp; Johnson </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Merck </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Eli Lilly
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">AbbVie </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تتحكم في
نسبة كبيرة من سوق الأدوية الموصوفة في الولايات المتحدة، حيث تشير التقديرات إلى
أن أقل من عشر شركات تسيطر على أكثر من 60% من سوق الأدوية العالمي. في الولايات
المتحدة وحدها، تمثل الأدوية المملوكة لهذه الشركات الجزء الأكبر من الإنفاق
الصحي، الذي تجاوز 4.5 تريليون دولار سنويا. قوة هذه الشركات لا تأتي فقط من
حجمها، بل من سيطرتها على براءات الاختراع، حيث تمنحها القوانين الأمريكية حماية
قد تمتد إلى 20 سنة أو أكثر، ما يمنع أي منافسة حقيقية ويجعلها قادرة على فرض
أسعار مرتفعة جدا. مثال صارخ على ذلك هو الإنسولين، وهو دواء أساسي لمرضى السكري،
حيث تسيطر ثلاث شركات فقط تقريبا على السوق الأمريكية، وارتفع سعره بأكثر من 300%
خلال عقدين، رغم أن تكلفته الفعلية في التصنيع منخفضة جدا. هذه الهيمنة مكنت</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Big Pharma </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">من تحقيق
أرباح خيالية، وفي نفس الوقت من إنفاق عشرات الملايين سنويا على اللوبيينغ للتأثير
في الكونغرس ومنع أي إصلاح جذري لنظام تسعير الأدوية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">الأمر لا
يختلف كثيرا في قطاع الطاقة، حيث تهيمن شركات النفط الكبرى مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> ExxonMobil </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Chevron </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">ConocoPhillips
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">على جزء مهم من سوق الطاقة الأمريكي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. ExxonMobil </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وحدها
حققت إيرادات تجاوزت 400 مليار دولار في بعض السنوات، وتعد من أقوى الشركات نفوذا
في واشنطن. هذه الشركات ليست مجرد منتجين للطاقة، بل لاعبين سياسيين بامتياز، حيث
أنفقت لعقود طويلة مئات الملايين من الدولارات لعرقلة سياسات المناخ، التشكيك في
الاحتباس الحراري، والتأثير على التشريعات البيئية. رغم أن الولايات المتحدة تتحدث
عن الانتقال الطاقي، فإن شركات النفط ما تزال تستفيد من إعفاءات ضريبية ضخمة ودعم
حكومي مباشر وغير مباشر يقدر بعشرات المليارات سنويا. هيمنة هذه الشركات تجعل
أسعار الطاقة، خيارات الاستثمار، وحتى السياسات الخارجية الأمريكية مرتبطة بشكل
وثيق بمصالحها الاقتصادية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">أما في
القطاع البنكي والمالي، فالصورة أكثر وضوحا من حيث التركز. خمسة بنوك كبرى فقط،
وهي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> JPMorgan Chase </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Bank of America </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Citigroup </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Wells Fargo </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Goldman Sachs</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، تتحكم في
أكثر من نصف الأصول البنكية في الولايات المتحدة، بأصول تقدر بعشرات التريليونات
من الدولارات</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. JPMorgan Chase </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وحده يدير
أصولا تفوق 3.5 تريليون دولار. هذه البنوك أصبحت "أكبر من أن تفشل"، ما
يعني عمليا أنها محمية من الانهيار لأن سقوطها يهدد النظام المالي بأكمله. هذا ما
ظهر بوضوح خلال الأزمة المالية سنة 2008، حين تم إنقاذ البنوك بأموال دافعي
الضرائب، في حين تحمل المجتمع تبعات الأزمة من بطالة وفقدان مساكن وانخفاض في
الأجور. ورغم ذلك، لم يتم تفكيك هذه البنوك، بل ازدادت حجما ونفوذا بعد الأزمة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">هيمنة
البنوك لا تقتصر على الاقتصاد فقط، بل تمتد إلى السياسة، حيث يلعب القطاع المالي
دورا محوريا في تمويل الحملات الانتخابية والتأثير على التشريعات. العديد من كبار
المسؤولين في وزارة الخزانة والبنك المركزي الأمريكي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> (Federal
Reserve) </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">يأتون مباشرة من وول ستريت أو يعودون إليها بعد انتهاء
مهامهم، ما يخلق دائرة مغلقة بين السلطة المالية والسلطة السياسية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">بهذا
المعنى، تتكامل هيمنة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Big Tech </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Big Pharma </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وشركات
النفط والبنوك الكبرى لتشكل منظومة متماسكة من النفوذ الاقتصادي والسياسي
والإعلامي. الإعلام يساهم في تلطيف الصورة، التكنولوجيا تتحكم في تدفق المعلومة،
الأدوية تتحكم في الصحة، الطاقة في نمط العيش، والبنوك في المال نفسه. هذه
المنظومة لا تحتاج إلى مؤامرة سرية، لأنها تعمل بشكل علني داخل قواعد النظام
الرأسمالي ذاته، مستفيدة من تركز رأس المال، ضعف القوانين، وقوة اللوبيينغ.
والنتيجة هي نظام تمارس فيه السلطة الحقيقية من قبل شركات غير منتخبة، لكن تأثيرها
يفوق أحيانا تأثير الحكومات نفسها</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في فرنسا،
يتخذ تركز السوق شكلا مختلفا لكنه لا يقل عمقا وتأثيرا في الاقتصاد والمجتمع.
مجموعات كبرى مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> LVMH </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تهيمن على
قطاع السلع الفاخرة عالميا، بعائدات تتجاوز 86 مليار يورو سنويا، ما يمنحها نفوذا
اقتصاديا وثقافيا واسعا. وفي توزيع المواد الغذائية، تتحكم سلاسل كبرى مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Carrefour </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Leclerc </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Auchan </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Casino </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Intermarché
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">Super U </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في ما
يقرب من 92٪ من السوق الفرنسي، وتمثل وحدها حوالي 60٪ من نفقات المستهلكين على
الغذاء، مقابل 10٪ فقط في بداية الستينيات، ما يعكس هيمنة شبه احتكارية على هذا
القطاع الحيوي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وفي قطاع
الطاقة والبنوك يتكرر نفس النمط، حيث تسيطر شركات كبرى على موارد أساسية للسوق.
ففي البنوك، كانت ست بنوك كبرى مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> BNP Paribas
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">Société Générale </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Crédit Agricole </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">BPCE </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Crédit
Mutuel CIC </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">La Banque Postale </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تسيطر على
حوالي 89٪ من السوق المصرفي، بينما تمتلك أربع منها وحدها نحو 70٪ من سوق القروض،
ما يجعل المنافسة الحقيقية ضعيفة للغاية. وفي إدارة المياه والنفايات، تهيمن</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Veolia </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Suez </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">ومعهما</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Saur </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">على الجزء
الأكبر من السوق الخاص، حيث يسيطر اللاعبان الأولان وحدهما على نحو ثلثي سوق إدارة
المياه و70٪ من سوق معالجة النفايات، مما يضع خدمات حيوية في أيدي عدد محدود من
الشركات</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">حتى في
الاتصالات وقطاع السيارات، يتضح التركز، إذ يسيطر عدد قليل من الشركات على خدمات
الهاتف الجوال، بينما تصل شركات مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Renault </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">PSA </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">معا إلى أكثر من 60٪ من سوق السيارات في
فرنسا، مما يحد من المنافسة في صناعات استراتيجية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">هذه
الهيمنة القطاعية لا تعني فقط أن المنافسة أصبحت شكلية أكثر منها فعلية، بل إنها
تخلق حواجز عالية أمام دخول فاعلين جدد وتقوض قدرة الشركات الصغيرة والمتوسطة على
النمو، كما تمنح الفاعلين الكبار إمكانية التأثير على السياسات العامة وتوجيه
الأسواق بما يخدم مصالحهم الخاصة أكثر من مصلحة المستهلكين أو اقتصاد البلاد ككل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">هذا
النفوذ الاقتصادي لا يبقى محصورا في السوق، بل يمتد إلى التشريعات والقوانين عبر
آليات اللوبيينغ. في الولايات المتحدة، تنفق شركات التكنولوجيا الكبرى عشرات
الملايين من الدولارات سنويا للضغط على الكونغرس وصناع القرار</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. Amazon </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وحدها
تنفق أكثر من 20 مليون دولار سنويا على اللوبيينغ، بينما تقترب</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Meta </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">من 19
مليون دولار، وتنفق</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">ما بين 10
و15 مليون دولار حسب السنوات. هذا الضغط المنظم يسمح لهذه الشركات بإيقاف أو إفراغ
مشاريع قوانين تهدف إلى الحد من الاحتكار، والحصول على حماية قانونية مثل المادة
230 التي تحمي منصات التواصل من المسؤولية عن المحتوى، إضافة إلى تأخير أو تعطيل
محاولات تفكيكها رغم دعاوى الاحتكار المتكررة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في فرنسا،
يمارس لوبي الشركات الكبرى نفوذه عبر قنوات أكثر هدوءا لكن لا تقل فعالية. منظمات
مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> MEDEF</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، التي تمثل
أرباب العمل، تلعب دورا محوريا في توجيه السياسات الاقتصادية. مجموعات الطاقة،
وعلى رأسها</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> TotalEnergies</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، ضغطت
باستمرار على سياسات المناخ والضرائب بما يحفظ مصالحها</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">كثير من
القوانين، مثل الضريبة على الشركات الرقمية، جاءت في صيغ أخف بكثير مما كان مطروحا
في البداية نتيجة هذا الضغط المتواصل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">التأثير
لا يتوقف عند حدود القوانين، بل يصل مباشرة إلى السياسة وصناعة القرار. في
الولايات المتحدة، تمول شركات مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">حملات انتخابية ومراكز أبحاث ومؤسسات
تفكير تؤثر في صياغة السياسات العامة. العلاقة بين وادي السيليكون والبيت الأبيض
أصبحت شبه عضوية، حيث ينتقل مسؤولون بين المناصب الحكومية والشركات الكبرى في
اتجاهين، ما يخلق تضارب مصالح بنيويا. مثال ذلك قضية الاحتكار ضد</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">التي
رفعتها وزارة العدل، والتي تمكنت الشركة من تأخيرها لسنوات طويلة بفضل شبكة ضخمة
من المحامين والضغط السياسي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في فرنسا،
يظهر التأثير السياسي بشكل أقل علنية لكنه حاضر بقوة. كبار الصناعيين يساهمون في
تمويل الحملات الانتخابية بطرق غير مباشرة، وتوجد علاقة وثيقة بين الحكومات
المتعاقبة وشركات</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> CAC40. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">شخصية مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Bernard Arnault</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، مالك</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> LVMH</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، لا تعد فقط
رجل أعمال، بل فاعلا مؤثرا في التوجهات الاقتصادية والقرارات الجبائية، بحكم وزن
مجموعته في الاقتصاد الفرنسي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">أما
الإعلام، فيعد من أخطر مجالات الهيمنة في النظام الرأسمالي، لأن السيطرة عليه لا
تعني فقط امتلاك شركات أو تحقيق أرباح، بل تعني بالأساس التحكم في تشكيل الوعي
الجماعي وصناعة الرأي العام وتحديد ما يقال وما يخفى. في فرنسا، تكشف عديد
الدراسات والتقارير المستقلة أن عددا محدودا جدا من كبار الأثرياء يسيطرون على
الجزء الأكبر من المشهد الإعلامي. أقل من عشرة مليارديرات فقط يمتلكون ما يقارب
تسعين بالمئة من الصحف الفرنسية ذات التوزيع الواسع، سواء كانت صحفا اقتصادية أو
سياسية أو عامة، وهو تركز غير مسبوق في تاريخ الإعلام الفرنسي الحديث</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. Bernard Arnault </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">على سبيل
المثال، يملك صحفا مؤثرة مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Les Échos </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Le Parisien</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، وهي من أكثر الجرائد قراءة وتأثيرا في
الرأي العام والدوائر الاقتصادية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. Xavier
Niel </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">يسيطر على</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Le Monde</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>،
التي تعد من أهم الصحف المرجعية في فرنسا وتؤثر بشكل مباشر في النخب السياسية
والثقافية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. Vincent Bolloré </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">بدوره بنى
إمبراطورية إعلامية ضخمة تشمل قنوات تلفزية وإذاعية مثل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> CNews </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Europe 1 </span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>+Canal</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، وقد أصبحت
هذه المنصات من بين الأكثر مشاهدة واستماعا في البلاد</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">هذا
التركز لا يقتصر على الصحافة المكتوبة فقط، بل يمتد بقوة إلى التلفزيون، حيث تشير
التقديرات إلى أن أكثر من خمسين بالمئة من نسب المشاهدة التلفزية في فرنسا تمر عبر
قنوات مملوكة لنفس هذه المجموعات الكبرى أو خاضعة لنفوذها المباشر أو غير المباشر.
معنى ذلك أن جزءا كبيرا من الفرنسيين يتلقى الأخبار، التحاليل السياسية، والنقاشات
العامة من وسائل إعلام تتحكم فيها مصالح اقتصادية واضحة. هذه السيطرة تمنح مالكي
الإعلام قدرة فعلية على توجيه الخطاب الإعلامي، ليس بالضرورة عبر الرقابة
المباشرة، بل من خلال اختيار المواضيع التي يتم تضخيمها أو تهميشها، تحديد الضيوف،
رسم حدود النقاش، وتكرار زوايا تحليل تخدم رؤية معينة للاقتصاد والسياسة والمجتمع</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في
الولايات المتحدة، لا تقل هيمنة الشركات الكبرى على الإعلام خطورة عما هو حاصل في
فرنسا، بل تتخذ شكلا أكثر تعقيدا وعمقا بسبب الطابع الرقمي للنظام الإعلامي
الأمريكي. فامتلاك صحيفة أو قناة لم يعد الشرط الوحيد للسيطرة على الرأي العام، بل
الأهم هو التحكم في البنية التحتية التي يمر عبرها الخبر نفسه. مثال واضح على ذلك
هو</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Amazon</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، التي تمتلك
صحيفة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Washington Post </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">منذ أن
اشتراها</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Jeff Bezos </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">سنة 2013
مقابل 250 مليون دولار. هذه الصحيفة تعد من أعرق المؤسسات الإعلامية في الولايات
المتحدة، وتلعب دورا مركزيا في تغطية السياسة الأمريكية، خاصة البيت الأبيض،
الكونغرس، وقضايا الأمن القومي. ورغم تأكيد الإدارة التحريرية على استقلاليتها،
فإن وجود مالك بحجم</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Bezos</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>،
الذي يملك في نفس الوقت واحدة من أقوى الشركات في العالم والمتعاقدة مباشرة مع
الحكومة الأمريكية ووزارة الدفاع، يطرح إشكالا بنيويا حول حدود النقد الممكن
ومجالات الصمت غير المعلنة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">لكن
الأخطر من امتلاك الصحف، هو سيطرة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">على تدفق الأخبار نفسه</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تتحكم
اليوم في أكثر من 90% من سوق البحث على الإنترنت في الولايات المتحدة، ما يجعلها
البوابة الرئيسية التي يمر عبرها الناس في أمريكا للوصول إلى الأخبار والمعلومات.
أكثر من 65% من الزيارات للمواقع الإخبارية تأتي إما مباشرة من</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google Search </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">أو من</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google News. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">هذا يعني
أن أي تغيير صغير في خوارزمية الترتيب يمكن أن يرفع موقعا إخباريا إلى الواجهة أو
يدفنه في الصفحات الخلفية دون أي قرار قضائي. فعليا، </span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تحدد ما
يرى وما لا يرى، أي ما يصبح "خبرا مهما" وما يعتبر هامشيا</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">Meta</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>،
المالكة لـ</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Facebook </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Instagram</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، تلعب دورا مشابها لكن عبر الشبكات
الاجتماعية. تشير الدراسات إلى أن أكثر من 50% من الأمريكيين يحصلون على أخبارهم
جزئيا أو كليا من</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Facebook. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">الخوارزميات
هنا لا تروج للأخبار بناء على قيمتها الصحفية، بل بناء على قدرتها على إثارة
التفاعل، الغضب، أو الخوف، لأن ذلك يزيد من الوقت الذي يقضيه المستخدم على المنصة،
وبالتالي من الأرباح الإعلانية. هذا النموذج أدى إلى تضخيم الأخبار المثيرة
والاستقطابية، وتراجع الصحافة التحليلية العميقة، وهو ما كان له تأثير مباشر على
الانتخابات الأمريكية، خاصة في 2016 و2020</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">مثال صارخ
على هذه الهيمنة هو فضيحة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Cambridge
Analytica</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، حيث تبين أن بيانات عشرات الملايين من
مستخدمي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Facebook </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">استعملت
للتأثير على سلوكهم الانتخابي عبر محتوى سياسي موجه بدقة. هنا لم تكن</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Meta </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">مجرد وسيط
محايد، بل منصة سمحت – عن قصد أو إهمال – بتحويل الإعلام إلى أداة هندسة نفسية
جماعية. ورغم الغرامات والتحقيقات، لم يتغير النموذج الاقتصادي للشركة، لأنها ما
تزال تحتكر الفضاء الاجتماعي الرقمي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">إلى جانب
ذلك، تسيطر</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">معا على ما بين 55% و60% من سوق الإعلانات
الرقمية في الولايات المتحدة، وهو ما جعل المؤسسات الإعلامية التقليدية في حالة
تبعية مالية شبه كاملة لهما. الصحف والمواقع الإخبارية أصبحت مضطرة لتكييف محتواها
مع متطلبات الخوارزميات حتى تضمن الظهور وجذب الإعلانات، ما يعني عمليا أن شركات
التكنولوجيا الكبرى لا تتحكم فقط في التوزيع، بل تؤثر أيضا في طبيعة المحتوى نفسه،
عناوينه، لغته، وأولوياته</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">حتى منصة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> YouTube</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، المملوكة
لـ</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، أصبحت
لاعبا إعلاميا ضخما يفوق في تأثيره العديد من القنوات التلفزية التقليدية.
خوارزميات الاقتراح فيها قادرة على دفع محتوى معين إلى ملايين المستخدمين خلال
ساعات، مقابل تهميش محتويات أخرى، دون أي شفافية حقيقية حول معايير الاختيار. هذا
ما جعل بعض الباحثين يصفون</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Google </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">Meta </span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;
color:#1F1F1F;mso-fareast-language:FR">بأنهما "محرو العصر الرقمي"،
لكن دون مسؤوليات المحررين التقليديين ودون خضوع فعلي للمحاسبة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">بهذا
الشكل، لم تعد السيطرة الإعلامية في الولايات المتحدة قائمة فقط على امتلاك
الجرائد والقنوات، بل على امتلاك الخوارزميات، المنصات، والبيانات. شركات
التكنولوجيا الكبرى لا تنتج المحتوى بالضرورة، لكنها تتحكم في كيفية ظهوره،
انتشاره، وسرعة وصوله، ومن يراه ومن لا يراه. هذه سلطة غير مسبوقة في التاريخ
الحديث، لأنها تمارس بشكل غير مرئي، تقني، ويومي، ما يجعلها أكثر فاعلية من
الرقابة التقليدية، وأصعب على المقاومة أو التفكيك. وإذا كان الإعلام في السابق
"السلطة الرابعة"، فإن المنصات الرقمية اليوم أصبحت السلطة التي تتحكم
في كل السلطات الأخرى دون أن تنتخب أو تحاسب</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في هذا
السياق، يصبح الإعلام أداة حماية للمصالح الاقتصادية أكثر من كونه سلطة رقابية
مستقلة. عندما يكون مالك القناة أو الجريدة في نفس الوقت صاحب مجموعة صناعية أو
مالية ضخمة، فإن الخط التحريري يميل تلقائيا إلى تجنب نقد الشركات الكبرى، تليين
النقاش حول الضرائب، الخصخصة، أو حقوق العمال، والتركيز بدل ذلك على قضايا جانبية
أو صراعات ثقافية تشتت الانتباه عن جوهر الاختلالات الاقتصادية. بهذا المعنى، لا
تمارس الشركات الكبرى هيمنتها فقط عبر السوق والقوانين، بل عبر السيطرة على
الرواية نفسها، أي الطريقة التي يفهم بها الناس ما يحدث حولهم، ومن يتحمل
المسؤولية، وما الذي يعتبر ممكنا أو مستحيلا سياسيا</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>. </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">وللحفاظ
على هذه الهيمنة، تعتمد الشركات الكبرى على مجموعة من الأساليب المتكاملة لمنع
المنافسة. من أبرزها شراء المنافسين المحتملين قبل أن يكبروا، كما فعلت</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Meta </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">عندما
استحوذت على</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Instagram </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">و</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR">WhatsApp</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span>، أو كما تفعل</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> LVMH </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">بشراء
علامات فاخرة ناشئة قبل أن تتحول إلى منافسين حقيقيين. هناك أيضا حروب الأسعار،
حيث تعتمد</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Amazon </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">سياسة
الخسارة المؤقتة لإخراج المتاجر الصغيرة من السوق، ثم ترفع الأسعار تدريجيا بعد
إحكام السيطرة. السيطرة على سلاسل التوريد تمثل بدورها أداة قوية، كما هو الحال مع</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> Apple </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">التي
تتحكم في المصنعين، براءات الاختراع، أنظمة التشغيل، والمتاجر الرقمية، ما يخلق
منظومة مغلقة تصعب منافستها. إضافة إلى ذلك، تستغل هذه الشركات الثغرات القانونية
لنقل الأرباح إلى ملاذات ضريبية وتفادي الضرائب عبر شبكات من الشركات الفرعية.
وأخيرا، فإن امتلاك المنصات نفسها يجعل أي منافس محتمل مضطرا للدخول عبر بوابات
خاضعة لسيطرة هذه الشركات، سواء تعلق الأمر بالبحث أو التجارة أو التواصل أو توزيع
التطبيقات</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom:0cm;text-align:justify;
line-height:normal;direction:rtl;unicode-bidi:embed"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">في
المحصلة، يكشف هذا المشهد أن النظام الرأسمالي الحالي لا يقوم فقط على المنافسة،
بل على تركز متزايد للقوة الاقتصادية والسياسية والإعلامية في يد عدد محدود من
الشركات العملاقة. هذه الشركات القادرة على إعادة تشكيل القوانين بما يخدم
مصالحها، في علاقة معقدة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="AR-SA" dir="LTR" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-theme-font:minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-hansi-theme-font:minor-bidi;mso-bidi-theme-font:minor-bidi;color:#1F1F1F;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span> </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:
minor-bidi;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR">تتداخل
فيها السوق مع الدولة، والإعلام مع السياسة، والربح مع النفوذ. ويكشف هذا الواقع
عن تناقض جوهري مع الخطاب الرسمي لما يسمى اقتصاد السوق الحر، الذي يفترض تكافؤ
الفرص، و"حرية المبادرة"، وتعدد الفاعلين الاقتصاديين. فبدل سوق مفتوحة
تتيح للجميع المنافسة، نجد منظومة تغلق تدريجيا أمام الداخلين الجدد، وتُحتكر فيها
الموارد ورؤوس الأموال ووسائل التأثير من قبل أقلية قادرة على حماية امتيازاتها
عبر النفوذ السياسي واللوبيات والتشريعات المصممة على المقاس. وهكذا تتحول حرية
التملك من مبدأ نظري متاح للجميع إلى امتياز فعلي محصور في من يمتلك أصلا القوة
والرسملة، لتغدو «الحرية الاقتصادية» شعارا إيديولوجيا أكثر منها واقعا ملموسا</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-hansi-theme-font:minor-bidi;
mso-bidi-theme-font:minor-bidi;color:#1F1F1F;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p>













































</p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-theme-font:minor-bidi;mso-hansi-theme-font:
minor-bidi;mso-bidi-theme-font:minor-bidi"><o:p>&nbsp;</o:p></span></p>
                ', 
      v_sec_economy_id, 
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQ8Z_xYZg6MaVz-jycJMbcbFGq0Z3OwELGhNXr4iCOPw&s=10', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-16T16:22:56.226Z', 
      '2026-08-16T02:51:29.196Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 19: كيف يمكن للدينار الذهبي الإسلامي أن يهدد...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'كيف يمكن للدينار الذهبي الإسلامي أن يهدد هيمنة الدولار؟', 
      '--msv7m3ik', 
      '
                  <span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-fami', 
      '
                  <p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:
&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">في 15 أوت 1971،
أعلن الرئيس الأمريكي ريتشارد نيكسون قرارًا تاريخيًا عُرف بـ“صدمة نيكسون”، أنهى
بموجبه قابلية تحويل الدولار إلى ذهب. لم يكن هذا القرار مجرد إجراء تقني، بل لحظة
فاصلة نقلت العالم من نظام نقدي قائم على معدن ثمين إلى نظام يقوم على الثقة في العملة
واستقرار الطلب العالمي. لفهم ما حدث، يجب العودة إلى نظام بريتون وودز الذي تأسس
سنة 1944، حيث تم الاتفاق على جعل الدولار محور النظام المالي العالمي، مع ربطه
بالذهب بسعر ثابت (35 دولارًا للأونصة)، وربط باقي العملات بالدولار. بهذا الشكل،
أصبح الدولار بمثابة “ذهب قابل للتداول”، بينما احتفظت الولايات المتحدة بالدور
المركزي لأنها الوحيدة القادرة على تحويل العملة إلى ذهب. لكن هذا النظام كان يحمل
في داخله تناقضًا عميقًا. فمن جهة، يحتاج العالم إلى دولارات لتسيير التجارة
الدولية، ومن جهة أخرى، كل دولار إضافي تصدره الولايات المتحدة يجب أن يكون مغطى
نظريًا باحتياطي من الذهب. مع مرور الوقت، خصوصًا خلال ستينات القرن الماضي، بدأت
الولايات المتحدة تنفق بكثافة على حرب فيتنام وبرامجها الاجتماعية، ما أدى إلى عجز
متزايد في ميزانها المالي. هذا العجز تُرجم إلى تدفق كميات كبيرة من الدولارات إلى
الخارج، دون وجود غطاء ذهبي كافٍ. بدأت دول مثل فرنسا تشكك في قدرة الولايات
المتحدة على الوفاء بالتزاماتها، وطلبت تحويل ما لديها من دولارات إلى ذهب، ما أدى
إلى نزيف حقيقي في الاحتياطي الأمريكي. أمام هذا الضغط، قررت واشنطن قطع العلاقة
بين الدولار والذهب بشكل أحادي، لتبدأ مرحلة جديدة: الدولار كعملة ورقية لا تستمد
قيمتها من معدن، بل من الثقة في الدولة التي تصدرها. نظريًا، كان من المفترض أن
يؤدي هذا التحول إلى فقدان الدولار لقيمته، لأن غيابه عن الذهب يعني غياب الضامن
المادي. لكن ما حدث كان العكس تقريبًا. فقد أدركت الولايات المتحدة أنها بحاجة إلى
خلق “طلب هيكلي” دائم على الدولار، أي طلب لا يعتمد فقط على الثقة، بل على ضرورة
اقتصادية عالمية. وهنا ظهرت فكرة استراتيجية بالغة الذكاء: ربط الدولار بالطاقة
بدل الذهب. في قلب هذه الاستراتيجية، نجد الاتفاق الذي أُبرم في السبعينات بين
الولايات المتحدة والمملكة العربية السعودية، أكبر مصدر للنفط في العالم آنذاك. نص
الاتفاق على تقديم حماية أمنية وعسكرية للنظام السعودي، مقابل التزام المملكة ببيع
نفطها حصريًا بالدولار، واستثمار فوائضها المالية داخل الولايات المتحدة. لاحقًا،
انضمت بقية دول أوبك إلى هذا الترتيب بشكل مباشر أو غير مباشر، لتولد بذلك منظومة
“البترودولار”. هذا النظام الجديد غيّر قواعد اللعبة. فبما أن النفط هو عصب
الاقتصاد العالمي، وكل الدول تحتاج إليه، أصبح من الضروري على كل دولة أن تمتلك
احتياطات من الدولار لشراء الطاقة. الدول الصناعية مثل اليابان، أو </span><span lang="AR-AE" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-language:AR-AE">ما يسمى </span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin">الدول النامية مثل تونس، لا يمكنها
شراء النفط بعملاتها المحلية، بل يجب عليها أولًا الحصول على الدولار، إما عبر
التصدير أو عبر الاقتراض. بهذه الطريقة، تحوّل الدولار إلى عملة لا غنى عنها، ليس
بسبب الذهب، بل بسبب الحاجة العالمية للطاقة. لكن الآلية لا تتوقف هنا. الدول
المصدرة للنفط، وعلى رأسها السعودية، تجد نفسها بعد بيع النفط أمام فوائض مالية
ضخمة بالدولار. هذه الأموال لا تبقى مجمدة، بل يتم “إعادة تدويرها” داخل النظام
المالي الأمريكي، في ما يُعرف بـ“</span><span lang="FR" dir="LTR" style="font-size:
12.0pt;line-height:107%">Recyclage des pétrodollars</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:
minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>”. يتم ذلك عبر شراء سندات الخزينة
الأمريكية، الاستثمار في الأسهم، اقتناء العقارات، أو إيداع الأموال في البنوك
الأمريكية. بهذه الطريقة، تعود الدولارات التي خرجت من الولايات المتحدة مقابل
النفط، لتدخل مجددًا إلى اقتصادها، ممولة عجزها المالي. هذا التدفق المستمر لرؤوس
الأموال له أثر حاسم: فهو يسمح للولايات المتحدة بالاقتراض بأسعار فائدة منخفضة.
في الأسواق المالية، عندما يرتفع الطلب على السندات، يرتفع سعرها وينخفض عائدها،
أي الفائدة التي تدفعها الدولة. وبما أن الطلب العالمي على السندات الأمريكية
مرتفع جدًا، فإن واشنطن تستطيع تمويل ديونها بسهولة وبكلفة منخفضة، وهو امتياز لا
تتمتع به أي دولة أخرى بنفس الحجم. هنا تتضح طبيعة الهيمنة الأمريكية. فبينما
تحتاج بقية الدول إلى العمل والتصدير للحصول على الدولار، تستطيع الولايات المتحدة
إصدار عملتها الخاصة لشراء ما تحتاجه من الخارج. صحيح أن هذا لا يعني إمكانية
الطباعة بلا حدود (لأن التضخم يبقى قيدًا حقيقيًا)، لكنه يمنحها هامشًا واسعًا من
الحرية المالية. الأهم من ذلك، أن هذه الهيمنة ليست اقتصادية فقط، بل جيوسياسية
أيضًا.</span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:
&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">بما أن النظام
المالي العالمي يتمحور حول الدولار، فإن جزءًا كبيرًا من المعاملات الدولية—حتى
تلك التي تتم بين أطراف خارج الولايات المتحدة—يمر عبر البنية التحتية المالية
الأمريكية، خاصة عبر بنوك المراسلة في نيويورك، وهو ما يمنح واشنطن نقطة تحكّم
حاسمة. هذا الواقع يضع تلك المعاملات ضمن نطاق القانون الأمريكي، ويتيح للسلطات،
وعلى رأسها مكتب مراقبة الأصول الأجنبية (</span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%">OFAC</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:
minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>)، مراقبتها والتدخل فيها عند الحاجة. من
خلال هذه الآلية، تستطيع الولايات المتحدة فرض عقوبات فعالة عبر عدة أدوات
متكاملة: فهي أولًا تقوم بإدراج دول أو بنوك أو شركات في “القائمة السوداء”، ما
يمنع أي مؤسسة مالية تستخدم الدولار من التعامل معها، وإلا تعرّضت هي نفسها
للعقوبات. كما يمكنها قطع الوصول إلى النظام البنكي بالدولار، وهو ما يعني عمليًا
شلّ القدرة على إجراء تحويلات دولية، لأن معظم التجارة العالمية تعتمد على هذه
العملة. إضافة إلى ذلك، تملك القدرة على تجميد الأصول المقومة بالدولار إذا كانت
مودعة أو تمر عبر النظام الأمريكي، فتجد الدول أو الكيانات نفسها غير قادرة على
استخدام أموالها رغم امتلاكها لها. والأكثر تأثيرًا هو ما يُعرف بالعقوبات
الثانوية، حيث لا تكتفي واشنطن بمعاقبة الطرف المستهدف، بل تهدد أيضًا كل من
يتعامل معه بحرمانه من السوق الأمريكية أو من النظام المالي بالدولار، وهو ما يدفع
الشركات العالمية إلى الانسحاب طوعًا من تلك الأسواق تفاديًا للمخاطر. كما تُعزّز
هذه المنظومة عبر فرض غرامات ضخمة على البنوك المخالفة، ما يجعلها تتبنى سياسات
حذرة جدًا، بل وتتجنب أحيانًا أي معاملات قد تكون محل شك. ويمكن كذلك دعم هذه
الإجراءات بالضغط على شبكات التحويل المالي مثل سويفت لإقصاء دول أو مؤسسات، مما
يزيد من عزلتها. وقد ظهر تأثير هذه الأدوات بوضوح في حالة إيران سنة 2018، حيث
انسحبت شركات أوروبية كبرى من السوق الإيرانية ليس امتثالًا لقوانينها المحلية، بل
خوفًا من فقدان الوصول إلى الدولار والنظام المالي العالمي، وهو ما يبيّن أن هيمنة
الدولار تمنح الولايات المتحدة قدرة فريدة على تحويل عملتها إلى أداة ضغط جيوسياسي
فعالة على مستوى العالم.إضافة إلى ذلك، يساهم هذا النظام في تمويل القوة العسكرية
الأمريكية. فبفضل القدرة على الاقتراض بأسعار منخفضة، يمكن للولايات المتحدة
الحفاظ على إنفاق عسكري ضخم وانتشار عالمي واسع، ما يعزز بدوره الثقة في الدولار
ويغذي حلقة الهيمنة. ورغم قوة هذا النظام، بدأت تظهر في السنوات الأخيرة تحديات
متزايدة. بعض الدول، مثل الصين وروسيا، تحاول تقليص اعتمادها على الدولار، عبر
استخدام عملاتها الوطنية في التجارة الثنائية، خاصة في مجال الطاقة. كما ظهرت
مشاريع لإنشاء أنظمة دفع بديلة. ومع ذلك، يبقى الدولار مهيمنًا، لأن الأسواق
المالية الأمريكية تظل الأكثر عمقًا وسيولة، ولأن الثقة العالمية في المؤسسات
الأمريكية ما تزال قوية نسبيًا.</span><span lang="FR" dir="LTR" style="font-size:
12.0pt;line-height:107%"><o:p></o:p></span></p><p>





</p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:
&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">في هذا السياق
تبرز فكرة اتحاد الدول في العالم الإسلامي في كيان سياسي واقتصادي واحد ليس لمجرد
استعادة لثقل تاريخي، بل كحتمية جيوسياسية لقلب موازين القوى العالمية. ففي ظل
النظام المالي الحالي الذي يرتكز على "البترودولار"، تعاني معظم الدول في
العالم الإسلامي من كونها "أطرافاً" مستهلكة تقع تحت رحمة التقلبات
النقدية الأمريكية. ومع ذلك، فإن اندماج هذه الدول في كتلة موحدة سيعني انتقالها
الفوري من مرحلة "التبعية" إلى دور "المركز" المهيمن، مستندةً
في ذلك إلى سلاحين استراتيجيين: السيادة النقدية المطلقة، والتحكم في الموارد
الحقيقية. ويبدأ ذلك بتحطيم قيد "الدولرة" عبر إصدار عملة موحدة، كالدينار
الذهبي. هذا الدينار لن يكون مجرد ورقة نقدية، بل قيمة مدعومة بمخزونات هائلة من
الذهب والاحتياطيات الطبيعية (النفط، الغاز، والمعادن الأرضية النادرة). إن العودة
إلى قاعدة الذهب يقي العالم الاسلامي من مخاطر انهيار العملة والتضخم المستورد؛ إذ
ستذوب هذه العملات المحلية المنهكة في عملة واحدة صلبة لا يمكن طباعتها من فراغ،
مما ينهي تماماً فجوات التمويل الخارجية ويمنح المسلمين قوة شرائية مستقرة لا
تتآكل عبر الزمن. أما على الصعيد الاستراتيجي، فإن هذا القرار سيوجه ضربة قاضية
لفعالية "العقوبات المالية". فبامتلاك الدولة لنظام مقاصة ودفع إلكتروني
مستقل (بديل لنظام سويفت)، لن تستطيع أي قوة خارجية تجميد أصولها أو عزلها عن
التجارة العالمية. وبدلاً من أن تكون أموال المسلمين رهينة في بنوك نيويورك، سيتم "إعادة
تدوير الثروات داخلياً". فالفواض المالية الضخمة الناتجة عن بيع الطاقة ستلغي
الحاجة لكل القروض الأجنبية، لتمويل مشاريع البنية التحتية العملاقة من جاكرتا إلى
الدار البيضاء، مما يحول الفائض النقدي من وسيلة لدعم العجز الأمريكي إلى وقود
للنهضة الصناعية والتكنولوجية. علاوة على ذلك، ستمتلك الدولة "سلطة تسعير
الطاقة، فبمجرد الإعلان بيع نفطها وغازها حصراً بالدينار الذهبي (البترو-دينار)،
سينهار الطلب الهيكلي القسري على الدولار، وسيُجبر العالم الصناعي على شراء العملة
الذهبية وتخزينها كعملة احتياط أساسية. هذا التحول سيجعل من الدولة "حاكم
الممرات المائية" واللوجستيات العالمية، حيث تسيطر على أهم المضايق البحرية،
مما يمنحها القدرة على فرض شروطها في التجارة الدولية وحماية أمنها الغذائي
والمائي بجيش موحد واقتصاد محصن لا يعترف بالارتهان لإملاءات صندوق النقد أو البنك
الدولي. إن الاتحاد في دولة واحدة يمثل الانتقال من "اقتصاد الفقاعات
والديون" إلى "اقتصاد القيمة الحقيقية". إنه مشروع لضبط النظام
العالمي وإعادة توزيع الثروة بعدلاً، حيث لا تُستمد القوة من مطابع النقد في
واشنطن، بل من باطن الأرض وسواعد الملياري نسمة، مما ينهي قرناً من التبعية ويؤسس
لعصر سيادة شاملة وعادلة.</span><span lang="FR" dir="LTR" style="font-size:12.0pt;
line-height:107%"><o:p></o:p></span></p>
                ', 
      v_sec_economy_id, 
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRAKKSoEuAu0CZJKbR0Wg7n6rbebCrRZIheSRTEEqWrA&s=10', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-16T16:21:51.938Z', 
      '2026-08-16T02:52:35.276Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 20: الدينار التونسي بين حماية البنك المركزي ...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الدينار التونسي بين حماية البنك المركزي وفرض التعويم', 
      '--msvqdd1a', 
      '
                  
                  <span lang="AR-SA" style=', 
      '
                  
                  <p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif;">تلعب الدولة، عبر بنكها المركزي،
دوراً محورياً في حماية العملة </span><span lang="AR-AE" style="font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif;">المحلية</span><span lang="AR-SA" style="font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif;"> من التقلبات
الحادة. فالأصل أنّ قيمة أي عملة تُحدَّد بقوانين العرض والطلب في سوق الصرف، لكن
أغلب الدول تتدخل بشكل أو بآخر للحفاظ على استقرار عملتها. هناك عدة آليات لهذا
التدخل: من أبرزها ضخ أو سحب العملة الصعبة من الاحتياطي الرسمي لموازنة السوق،
التحكم في نسبة الفائدة للحد من الاقتراض والاستهلاك، فرض قيود على تحويل الأموال
للخارج، ووضع سياسات تجارية تحدّ من الواردات أو تشجع على التصدير. هذه الأدوات
تمثل "خط الدفاع الأول" أمام أي انهيار في قيمة العملة، إذ تسمح للدولة
بالتأثير في السوق وتقليل الضغط على النقد المحلي</span><span dir="LTR" style="font-size: 1.1rem;"></span><span dir="LTR" style="font-size: 1.1rem;"></span><span lang="FR" dir="LTR" style="font-size: 12pt; font-family: &quot;Times New Roman&quot;, serif;"><span dir="LTR"></span><span dir="LTR"></span>.</span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">في تونس، كان البنك المركزي يلعب هذا
الدور بوضوح قبل سنة 2016. فالدولة لم تكن تترك العملة المحلية عرضة لقوانين العرض
والطلب وحدها، بل كانت تتدخل بصفة مباشرة لضبط السعر. فعندما يرتفع الطلب على
العملة الصعبة، كان البنك يضخ كميات من اليورو أو الدولار لامتصاص الضغط، وإذا
ارتفع الاستهلاك أو الاستيراد، يقوم بتعديل نسبة الفائدة المديرية للتأثير على حجم
القروض. هذه السياسة مكّنت من الحفاظ على استقرار نسبي في الأسعار وفي قيمة
الدينار. سنة 2010، كان اليورو يعادل 1.9 دينار فقط، والدولار 1.4 دينار، مع تضخم
لم يتجاوز 4 بالمائة، واحتياطي عملة صعبة يغطي نحو 155 يوماً من التوريد</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.</span><span dir="RTL"></span><span dir="RTL"></span><span lang="FR" style="font-size:12.0pt;
font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span> </span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">غير أنّ
توازن هذه المعادلة بدأ ينهار بعد 2011، بفعل اعتماد الدولة على مداخيل هشة
ومتقلبة حيث تراجع إنتاج الفوسفاط بشكل كبير، وانخفضت مداخيل السياحة بفعل
الاضطرابات الأمنية، بينما واصل العجز التجاري التفاقم. كل هذه الضغوط جعلت البنك
المركزي عاجزاً عن الدفاع عن العملة كما في السابق. ففي 2016، لم يعد الاحتياطي
يغطي سوى 90 يوماً من التوريد، بينما تجاوز العجز التجاري 12 مليار دينار، وصعد
التضخم إلى 4.5 بالمائة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">في هذا السياق، جاء قرار التحول إلى
التعويم المدار، أي تحرير نسبي لسعر الصرف مع تدخل محدود عند الحاجة. غير أنّ هذا
القرار لم يكن خياراً سيادياً خالصاً، بل جاء في إطار برنامج إصلاح اقتصادي فرضه
صندوق النقد الدولي كشرط للحصول على قرض بقيمة 2.8 مليار دولار سنة 2016. أحد
الشروط كان مراجعة النظام الأساسي للبنك المركزي لضمان استقلاليته ومنع تمويل
الخزينة، وهو ما قلّص قدرة الدولة على استعمال أدواتها النقدية التقليدية. كما نصت
توصيات الصندوق صراحة على "زيادة مرونة سعر الصرف" أي فتح الباب أمام
التعويم، بدعوى تحسين تنافسية الصادرات والحد من الاختلالات الخارجية</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="RTL"></span><span dir="RTL"></span> فماذا كانت
نتائج هذا التوجه؟<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">أولا: التضخم وانهيار القدرة الشرائية</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><br>
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">إنّ التعويم
يعني أنّ كل عملية توريد تصبح أكثر كلفة، بما أنّ تونس تستورد أكثر من 70٪ من
حاجياتها. فالسلع الأساسية والطاقة والسيارات والأدوية كلها شهدت ارتفاعات حادّة
في الأسعار. إذ ارتفع التضخم من 5.3٪ سنة 2017 إلى 9.1٪ سنة 2023. فعلى سبيل
المثال، ارتفع سعر لتر الزيت المدعّم من 900 مليم إلى 2.4 دينار، وسعر لتر البنزين
من 1.5 دينار سنة 2010 إلى 2.5 دينار سنة 2023. وبالتالي، فإنّ أي تراجع إضافي في
قيمة الدينار ينعكس مباشرة على أسعار السوق، ليكون عامة الناس أوّل من يدفع فاتورة
التعويم</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">ثانيا: تفاقم العجز التجاري والحساب
الجاري</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><br>
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">من المفترض
نظرياً أن يؤدي تراجع قيمة الدينار إلى تشجيع الصادرات، لأنها تصبح أرخص في
الأسواق العالمية. لكن في تونس، يظلّ قطاع التصدير ضعيفاً وغير قادر على تغطية
الواردات الضخمة من المواد الغذائية والطاقة. والنتيجة أنّ العجز التجاري واصل
التوسع، من 12 مليار دينار سنة 2016 إلى أكثر من 25 مليار دينار سنة 2023. أما
الحساب الجاري فقد سجّل نسباً سالبة تجاوزت 10٪ من الناتج المحلي في 2018. وهذا
يثبت أنّ التعويم لم يُحسّن الميزان التجاري، بل كشف هشاشة الاقتصاد المحلي</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">ثالثاً: المديونية الخارجية وخدمة
الدين</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><br>
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">مع انهيار
قيمة الدينار، أصبحت القروض التي تحصلت عليها تونس بالدولار أو اليورو أكثر كلفة.
فقد ارتفع الدين الخارجي من 62٪ من الناتج المحلي سنة 2016 إلى حوالي 80٪ سنة
2023. وأصبحت خدمة الدين تستنزف قرابة 20٪ من مداخيل التصدير. وهكذا أدخل التعويم
المالية العمومية في حلقة مفرغة: كلما تراجع الدينار، زادت كلفة الدين، وكلما
ارتفعت كلفة الدين، ازدادت الحاجة إلى قروض جديدة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.</span><span lang="AR-SA" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">رابعاً: الاحتياطي من العملة الصعبة</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><br>
</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">رغم بعض
التحسن في سنة 2024 (121 يوم توريد) بفضل القروض وتحويلات التونسيين في الخارج،
ظلّ الاحتياطي هشّاً. فقد شهد أوت 2025 تراجعاً جديداً إلى 98 يوم توريد. وهذا
يدلّ على أنّ التحسن كان ظرفياً، وليس نتيجة سياسة نقدية فعالة أو ناجحة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.<o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:
&quot;Times New Roman&quot;;mso-fareast-language:FR">من الناحية النظرية، يُفترض أن يشجّع
التعويم على جذب الاستثمارات الأجنبية وتنشيط الصادرات. غير أنّ الواقع أثبت
العكس، إذ بقي النمو ضعيفاً: حوالي 2٪ في أفضل الحالات بعد 2017، مع انكماش تاريخي
بلغ -8.8٪ سنة 2020. أما البطالة فقد استقرت بين 15 و16٪ دون أي تحسن ملموس. وهذا
دليل إضافي على أنّ التعويم لم يحفّز الاستثمار ولم يسهم في خلق فرص عمل جديدة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;
mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.</span><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="margin-bottom: 0cm; line-height: normal; direction: rtl; unicode-bidi: embed;"><span lang="AR-SA" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-ascii-theme-font:
major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi">قرار
تعويم الدينار لم يكن خياراً سيادياً استراتيجياً، بل خطوة اضطرارية فرضتها الضغوط
الداخلية وشروط صندوق النقد الدولي. الهدف المعلن كان تقليص العجز وتحسين
التنافسية، لكن النتائج جاءت معاكسة: فقد الناس قدرتهم الشرائية، ارتفع التضخم
والمديونية، وتفاقم العجز التجاري. بعض المكاسب الظرفية مثل تحسن الاحتياطي بفضل
القروض أو تحويلات الجالية لا تخفي هشاشة البنية الاقتصادية. النقد الأساسي لهذا
القرار أنّ التعويم لا يحلّ المشاكل البنيوية، بل يؤجلها ويضاعف كلفتها إذا لم
يُرفق بإصلاحات حقيقية في الإنتاج، في التحكم في الاستهلاك وفي تقليص التبعية
للأسواق الخارجية. في النهاية، يمكن القول إن التعويم في تونس لم يكن أداة إصلاح
بقدر ما كان أداة تأجيل للأزمة على حساب عامة الناس.</span><span lang="FR" dir="LTR" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif;mso-ascii-theme-font:
major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:major-bidi"><o:p></o:p></span></p><p>



















</p><p class="MsoNormal"><span lang="FR">&nbsp;</span></p>
                
                ', 
      v_sec_economy_id, 
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb3-Hww-sEUxlRkaTUjgDgwdqGeR8HQrITdj0IGVxdjg&s=10', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-16T16:21:50.906Z', 
      '2026-08-16T02:54:21.732Z'
    )
    ON CONFLICT (slug) DO NOTHING;

    -- Post 21: الضغط الجبائي في تونس: استنزاف الأجراء و...
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at, created_at)
    VALUES (
      'الضغط الجبائي في تونس: استنزاف الأجراء والبديل الإسلامي', 
      '--msv7pguz', 
      '
                  <span lang="AR-SA" style="font-size: 12pt; line-height: 107%; font-fa', 
      '
                  <p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size: 12pt; line-height: 107%; font-family: Arial, sans-serif;">تعتمد ميزانية
الدولة في تونس بشكل هيكلي ومفرط على الجباية كرافد أساسي لتمويل النفقات وتغطية
العجز المالي. ويتأكد هذا من خلال أرقام قانون المالية، حيث تستحوذ المداخيل
الجبائية على الحصة الأكبر بنسبة ناهزت 91% (بقيمة 47.773 مليار دينار) من إجمالي
موارد الميزانية البالغة 52.560 مليار دينار. وتتوزع هذه الإيرادات أساساً بين
الأداء على القيمة المضافة </span><span lang="FR" dir="LTR" style="font-size: 12pt; line-height: 107%;">TVA</span><span dir="RTL" style="font-size: 1.1rem;"></span><span dir="RTL" style="font-size: 1.1rem;"></span><span lang="AR-SA" style="font-size: 12pt; line-height: 107%; font-family: Arial, sans-serif;"><span dir="RTL"></span><span dir="RTL"></span>
كأداة ضريبية رئيسية على الاستهلاك، والضريبة على دخل الأشخاص الطبيعيين </span><span lang="FR" dir="LTR" style="font-size: 12pt; line-height: 107%;">IRPP</span><span dir="RTL" style="font-size: 1.1rem;"></span><span dir="RTL" style="font-size: 1.1rem;"></span><span lang="AR-SA" style="font-size: 12pt; line-height: 107%; font-family: Arial, sans-serif;"><span dir="RTL"></span><span dir="RTL"></span>.
ورغم شمولية النظام الضريبي لكافة الشرائح الاجتماعية، إلا أن العبء الأكبر يقع
اقتصادياً على عاتق الفئات الضعيفة ومحدودي الدخل، وهو ما تؤكده البيانات الصادرة
عن وزارة المالية عبر مسارين:</span></p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>•</span><span dir="LTR"></span><span dir="LTR"></span><span lang="AR-SA" dir="LTR" style="font-size:
12.0pt;line-height:107%;mso-bidi-font-family:Arial"><span dir="LTR"></span><span dir="LTR"></span> </span><span lang="AR-SA" style="font-size:12.0pt;line-height:
107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:
minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">الاقتطاع
المباشر والأجراء: تتحمل فئة الأجراء في القطاعين العام والخاص القسط الأوفر
والنسبة الأعلى من الضريبة على الدخل </span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%">IRPP</span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin">وتتميز هذه الفئة بالشفافية المطلقة
أمام مصالح الجباية، حيث تقتطع الدولة الضرائب مباشرة من الرواتب عبر آلية الخصم
من المورد قبل وصولها لأصحابها، مما يمنعهم من الامتناع عن دفع الضرائب على خلاف
بعض المهن الحرة أو الأنشطة الموازية.</span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>•</span><span dir="LTR"></span><span dir="LTR"></span><span lang="AR-SA" dir="LTR" style="font-size:
12.0pt;line-height:107%;mso-bidi-font-family:Arial"><span dir="LTR"></span><span dir="LTR"></span> </span><span lang="AR-SA" style="font-size:12.0pt;line-height:
107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:
minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">الضرائب
غير المباشرة والاستهلاك: يعتمد النظام الجبائي بشكل مفرط على الأداء على القيمة
المضافة </span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%">TVA</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin"><span dir="RTL"></span><span dir="RTL"></span> والضرائب غير المباشرة.
وتصنف هذه الأدوات اقتصادياً كـضرائب تراجعية لأنها تُفرض بنسب ثابتة على السلع
والاستهلاك بغض النظر عن الحالة المادية للفرد، مما يجعل محدودي الدخل يتحملون
عبئاً اقتطاعياً يفوق بكثير النسبة الفعلية التي يتحملها ميسورو الحال عند شراء
نفس السلع.</span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:
107%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:
&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">يؤدي هذا الجمع
بين الحصار الضريبي على الرواتب والضرائب المتصاعدة على الاستهلاك إلى تآكل مباشر
وعميق للقدرة الشرائية لأصحاب الدخل المحدود. ويضع الثقل الأكبر للتمويل الذاتي
للدولة على كاهل الطبقتين المتوسطة والضعيفة، مما يحول فئة الأجراء بالفعل إلى
الممول الأول للخزينة العامة ومواجهة عجز الموازنة. ولإدراك حجم الضغط الجبائي
الخانق المسلط على الأجراء، يكفي تفكيك الهيكل المالي لراتب موظف في القطاع الخاص
يتقاضى أجراً خاماً قدره 1200 دينار شهرياً. تبدأ رحلة الاستنزاف المالي باقتطاع
آلي لنسبة 9.18% بعنوان المساهمات الاجتماعية لفائدة الصندوق الوطني للضمان
الاجتماعي (</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%"><span dir="LTR"></span><span dir="LTR"></span> (CNSS</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>
بقيمة 110.160 دينار، يليه خصم مباشر من المورد للضريبة على الدخل (</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:
12.0pt;line-height:107%"><span dir="LTR"></span><span dir="LTR"></span> (IRPP</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin"><span dir="RTL"></span><span dir="RTL"></span> بمبلغ 110 دينار. هذا
الضغط المباشر يجرد الموظف من 220.160 دينار دفعة واحدة قبل أن يلمس مرتبه، ليستقر
أجره الصافي </span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:
107%">Salaire Net)</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin"><span dir="RTL"></span><span dir="RTL"></span>)
عند حدود (979.840) دينار فقط. ولا يتوقف النزيف المالي عند هذا الحد؛ فعندما يخرج
هذا الأجير لتأمين حياته اليومية، يصطدم بـالأداء على القيمة المضافة </span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%">TVA)</span><span dir="RTL"></span><span dir="RTL"></span><span lang="AR-SA" style="font-size:12.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin"><span dir="RTL"></span><span dir="RTL"></span>) بنسبة تصل إلى 19%
محملة على أغلب مشترياته من ملابس، خدمات، محروقات، وبعض المواد الاستهلاكية. تحول
هذه المنظومة الموظف في</span><span lang="AR-SA" style="font-size:12.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin;mso-bidi-language:AR-TN"> </span><span lang="AR-SA" style="font-size:
12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:
Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin">تونس — الذي يصارع لتغطية أساسيات العيش—إلى
ممول دائم ومثقل لـخزينة الدولة رغم هشاشة وضعه المالي. وتبرر السلطة هذه الضرائب
بأنها مقابل التمتع بالمرافق العمومية والخدمات التي توفرها الدولة، غير أن الواقع
اليومي يكشف تدهورًا واضحًا في تلك الخدمات، سواء في قطاع الصحة العمومية، أو
النقل، أو التعليم، حيث يعاني الناس من الاكتظاظ وضعف الجودة وتعطل المرافق الأساسية،
رغم ما يدفعونه من ضرائب مرتفعة.</span><span lang="FR" dir="LTR" style="font-size:
12.0pt;line-height:107%"><o:p></o:p></span></p><p class="MsoNormal" dir="RTL" style="text-align:justify;direction:rtl;unicode-bidi:
embed"><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:
&quot;Arial&quot;,sans-serif;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin">هذه الضرائب
التي تأخذها الدولة هي حرام شرعا وهي أكل لأموال الناس بالباطل فالأصل أن أموال
الناس مصونة، ولا يجوز للدولة أن تفرض الضرائب عليهم من تلقاء نفسها دون دليل
فالشرع نهى عن أن يَفرض السلطان ضريبة على المسلمين بناء على أمر صادر منه، قال
صلى الله عليه وسلم: (لا يدخل الجنة صاحب مكس)، والمكس هو الضريبة التي تؤخذ من
التجار على حدود البلاد، ولكنه يشمل كل ضريبة لقول الرسول صلى الله عليه وسلم: (لا
يحل مال امرئ مسلم إلاّ بطيب نفسه)، وهو عام يشمل الدولة كما يشمل باقي الناس. وما
دام الشرع قد نهى عن أخذ الضريبة فلا يجوز للدولة أن تفرضها على الناس بأمر من عندها.
فالتصور الإسلامي للمال والجباية على أسس مختلفة جذريًا، يقوم على مراعاة الواقع
المعيشي للإنسان قبل مطالبته بأي اقتطاع مالي. </span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">في النظام
الاقتصادي في الإسلام، لا يُنظر إلى الشاب أو الأجير المبتدئ أو متوسط الحال كأداة
جباية لتمويل نفقات الدولة، بل تُحاط مداخيله وروافده المالية بحصانة تشريعية
كاملة حتى يتمكن من تأمين حاجاته الأساسية وحاجات من يعول</span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin">. </span><span lang="AR-SA" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR">فالدولة لا
تجبي المال من الفرد إلا في حالات استثنائية وبصفة مؤقتة ومتي كان هذا الفرد غنيا
له ثروة مستقرة ومتروكة، والزكاة كرافد مالي أساسي للدولة لا تُفرض على الإنسان
إلا بعد بلوغ ماله "النصاب"، وهو الحد الأدنى للغنى والرفاه النسبي،
وبشرط أن يكون المال زائداً تماماً عن متطلبات العيش الأساسية كالمأكل والملبس
والسكن، وأن يظل هذا الفائض مدخراً ومتروكاً تحت حوزة صاحبه لعام كامل دون حاجة إليه،
مما يحول دون تحول منظومة الضرائب إلى حصار مالي يجهض طموح الشباب ويقوض تماسك
الطبقة المتوسطة</span><span dir="LTR"></span><span dir="LTR"></span><span lang="FR" dir="LTR" style="font-size:12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
mso-fareast-font-family:&quot;Times New Roman&quot;;mso-fareast-language:FR"><span dir="LTR"></span><span dir="LTR"></span>.</span><span lang="AR-SA" style="font-size:
12.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;mso-ascii-font-family:
Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin">كما أن موارد الدولة في الإسلام ليست متروكة
للتغيير السنوي بحسب قوانين مالية متقلبة كما هو الحال في الأنظمة الرأسمالية، بل
حدد الشرع أبواب الواردات بوضوح، مثل الزكاة والخراج والجزية والفيء والأموال
الناتجة عن ملكية الدولة والأموال الناتجة عن الملكيات العامة والأموال التي تؤخذ
من الجمارك وهي كافية لإدارة شؤون الناس ورعاية مصالحهم. وبالتالي تكون مداخيل
الدولة قائمة على أحكام شرعية ثابتة، لا على التوسع المستمر في فرض الضرائب على
الناس.</span></p>
                ', 
      v_sec_economy_id, 
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjF-GJonGbBozKdGDcsteJ4Db9wIKKfaDhgFlQijoxhg&s=10', 
      v_user_id, 
      'رئيس التحرير', 
      'published', 
      false, 
      '2026-08-16T16:21:48.915Z', 
      '2026-08-16T02:55:12.540Z'
    )
    ON CONFLICT (slug) DO NOTHING;

END $$;
