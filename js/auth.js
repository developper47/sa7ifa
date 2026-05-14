/**
 * auth.js — Supabase Authentication & Profiles
 * Transitioned from LocalStorage to Supabase Auth
 * [LOCAL BYPASS ENABLED FOR ADMIN]
 */

import { supabase } from './supabase.js';

const MOCK_ADMIN_EMAIL = 'admin@magazine.com';
const MOCK_ADMIN_PASS = 'admin123';
const MOCK_SESSION_KEY = 'magazine_mock_session';

/**
 * Sign up a new user and create their profile.
 */
export async function signUp(name, email, password) {
  try {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: name } }
    });
    if (error) throw error;
    return { success: true, user: data.user };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

/**
 * Sign in existing user with local admin bypass
 */
export async function signIn(email, password) {
  // --- LOCAL BYPASS START ---
  if (email === MOCK_ADMIN_EMAIL && password === MOCK_ADMIN_PASS) {
    const mockUser = {
      id: '00000000-0000-0000-0000-000000000000', // Valid UUID format
      email: MOCK_ADMIN_EMAIL,
      name: 'أحمد المدير',
      role: 'admin'
    };
    localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(mockUser));
    return { success: true, user: mockUser };
  }
  // --- LOCAL BYPASS END ---

  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });
    if (error) throw error;
    return { success: true, user: data.user };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

/**
 * Sign out current user
 */
export async function signOut() {
  localStorage.removeItem(MOCK_SESSION_KEY);
  try {
    await supabase.auth.signOut();
  } catch (error) {
    console.error("Sign out error:", error.message);
  }
  localStorage.removeItem('magazine_session');
}

/**
 * Get current authenticated user session
 */
export async function getCurrentUser() {
  // Check mock session first
  const mockSession = localStorage.getItem(MOCK_SESSION_KEY);
  if (mockSession) {
    return JSON.parse(mockSession);
  }

  try {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return null;

    // Fetch role from profile
    const { data: profile } = await supabase
      .from('profiles')
      .select('role, name')
      .eq('id', user.id)
      .single();

    return {
      id: user.id,
      email: user.email,
      name: profile?.name || user.user_metadata?.full_name || 'مستخدم',
      role: profile?.role || 'user'
    };
  } catch (error) {
    console.warn("Supabase session fetch failed:", error.message);
    return null;
  }
}

/**
 * Check if the provided user object is an admin
 */
export function isAdmin(user) {
  return user && user.role === 'admin';
}
