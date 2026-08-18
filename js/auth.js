/**
 * auth.js — Supabase Authentication & Profiles
 * Transitioned from LocalStorage to Supabase Auth
 * [LOCAL BYPASS ENABLED FOR ADMIN]
 */

import { supabase } from './supabase.js?v=3.6';

/**
 * Sign up a new user and create their profile.
 */
export async function signUp(name, email, password, role = 'reader') {
  try {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: name, role: role } }
    });
    if (error) throw error;
    return { success: true, user: data.user };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

/**
 * Sign in existing user
 */
export async function signIn(email, password) {
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
  try {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return null;

    // Fetch role from profile
    const { data: profile } = await supabase
      .from('profiles')
      .select('role, name, is_validated')
      .eq('id', user.id)
      .single();

    return {
      id: user.id,
      email: user.email,
      name: profile?.name || user.user_metadata?.full_name || 'مستخدم',
      role: profile?.role || 'reader',
      is_validated: profile?.is_validated !== false
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

/**
 * Request password reset email
 */
export async function sendPasswordResetEmail(email) {
  try {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: window.location.origin + window.location.pathname,
    });
    if (error) throw error;
    return { success: true, data };
  } catch (error) {
    return { success: false, message: error.message };
  }
}

/**
 * Update user password
 */
export async function updatePassword(newPassword) {
  try {
    const { data, error } = await supabase.auth.updateUser({
      password: newPassword
    });
    if (error) throw error;
    return { success: true, user: data.user };
  } catch (error) {
    return { success: false, message: error.message };
  }
}
