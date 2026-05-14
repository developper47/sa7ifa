// ============================================================
// supabase.js — Supabase Client Initialization
// Using CDN-based loading since Node.js is not available
// ============================================================

// --- CONFIGURATION ---
// IMPORTANT: Replace SB_URL with your Supabase Project URL
const SB_URL = "https://boapbwamionuzngkakqg.supabase.co"; 
const SB_KEY = "sb_publishable_Rl34BsM2M5v3_3QMRdSp5Q_Yx5U4uFJ"; // Your publishable key

// Check if variables are set
if (SB_URL === "https://boapbwamionuzngkakqg.supabase.co") {
  console.log("🚀 Supabase is connected to project: ishrakat");
}

/**
 * Initialize Supabase Client
 */
export const supabase = (() => {
  if (!window.supabase) {
    console.error("❌ Supabase SDK not found. Make sure the CDN script is loaded.");
    return null;
  }
  const { createClient } = window.supabase;
  return createClient(SB_URL, SB_KEY);
})();
