/**
 * sections.js — Supabase Sections CRUD
 * Manages editorial categories dynamically from the database.
 */

import { supabase } from './supabase.js?v=3.6';

let _sectionsCache = null;

/**
 * Get all active sections (public view). Cached per session.
 */
export async function getSections(forceRefresh = false) {
  if (_sectionsCache && !forceRefresh) return _sectionsCache;

  const { data, error } = await supabase
    .from('sections')
    .select('*')
    .eq('is_active', true)
    .order('display_order', { ascending: true });

  if (error) {
    console.error('Error fetching sections:', error.message);
    return [];
  }
  _sectionsCache = data || [];
  return _sectionsCache;
}

/**
 * Get ALL sections (including inactive) — Admin only.
 */
export async function getAllSections(forceRefresh = false) {
  if (_sectionsCache && !forceRefresh) return _sectionsCache;

  const { data, error } = await supabase
    .from('sections')
    .select('*')
    .order('display_order', { ascending: true });

  if (error) {
    console.error('Error fetching all sections:', error.message);
    return [];
  }
  _sectionsCache = data || [];
  return _sectionsCache;
}

/**
 * Get a single section by slug.
 */
export async function getSectionBySlug(slug) {
  const { data, error } = await supabase
    .from('sections')
    .select('*')
    .eq('slug', slug)
    .maybeSingle();

  if (error) return null;
  return data;
}

/**
 * Create a new section — Admin only.
 */
export async function createSection(section) {
  // Validate unique slug
  const { data: existing } = await supabase
    .from('sections')
    .select('id')
    .eq('slug', section.slug)
    .maybeSingle();

  if (existing) throw new Error(`الرابط "${section.slug}" مستخدم مسبقاً، اختر رابطاً آخر.`);

  const { data, error } = await supabase
    .from('sections')
    .insert([{ ...section, created_at: new Date().toISOString(), updated_at: new Date().toISOString() }])
    .select();

  if (error) throw error;
  _sectionsCache = null; // Invalidate cache
  return data[0];
}

/**
 * Update a section — Admin only.
 */
export async function updateSection(id, updates) {
  // Validate unique slug if slug is being changed
  if (updates.slug) {
    const { data: existing } = await supabase
      .from('sections')
      .select('id')
      .eq('slug', updates.slug)
      .neq('id', id)
      .maybeSingle();

    if (existing) throw new Error(`الرابط "${updates.slug}" مستخدم مسبقاً، اختر رابطاً آخر.`);
  }

  const { data, error } = await supabase
    .from('sections')
    .update({ ...updates, updated_at: new Date().toISOString() })
    .eq('id', id)
    .select();

  if (error) throw error;
  _sectionsCache = null; // Invalidate cache
  return data[0];
}

/**
 * Delete a section — Admin only.
 * Checks for linked posts first.
 */
export async function deleteSection(id, reassignToId = null) {
  // Check for linked posts
  const { count } = await supabase
    .from('posts')
    .select('id', { count: 'exact', head: true })
    .eq('section_id', id);

  if (count > 0) {
    if (!reassignToId) {
      throw new Error(`هذا القسم يحتوي على ${count} مقال. يجب نقل المقالات أو تحديد قسم بديل قبل الحذف.`);
    }
    // Reassign posts to another section
    const { error: reassignErr } = await supabase
      .from('posts')
      .update({ section_id: reassignToId })
      .eq('section_id', id);
    if (reassignErr) throw reassignErr;
  }

  const { error } = await supabase.from('sections').delete().eq('id', id);
  if (error) throw error;
  _sectionsCache = null;
}

/**
 * Toggle section active/inactive — Admin only.
 */
export async function toggleSection(id, isActive) {
  const { data, error } = await supabase
    .from('sections')
    .update({ is_active: isActive, updated_at: new Date().toISOString() })
    .eq('id', id)
    .select();
  if (error) throw error;
  _sectionsCache = null;
  return data[0];
}

/**
 * Reorder sections by updating display_order — Admin only.
 */
export async function reorderSections(orderedIds) {
  const updates = orderedIds.map((id, idx) =>
    supabase.from('sections').update({ display_order: idx + 1 }).eq('id', id)
  );
  await Promise.all(updates);
  _sectionsCache = null;
}

/**
 * Get post count per section — Admin use.
 */
export async function getSectionPostCounts() {
  const { data, error } = await supabase
    .from('posts')
    .select('section_id');

  if (error) return {};
  const counts = {};
  (data || []).forEach(p => {
    counts[p.section_id] = (counts[p.section_id] || 0) + 1;
  });
  return counts;
}
