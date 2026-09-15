/* Shared Supabase connection and authentication helpers. */
(function () {
  const SUPABASE_URL = 'https://wjajbkhydgqbeciervpg.supabase.co';
  const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_Cuz9kl7aEnrrOjTjKocsRA_ZglG0PKp';
  const DASHBOARD_SESSION_KEY = 'jason_dashboard_signed_in';

  function getClient() {
    if (!window.supabase) throw new Error('Supabase failed to load. Check your internet connection and try again.');
    if (!window.jasonSupabase) {
      window.jasonSupabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
        auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
      });
    }
    return window.jasonSupabase;
  }

  async function currentUser() {
    const { data, error } = await getClient().auth.getUser();
    if (error) throw error;
    return data.user;
  }

  async function requireUser() {
    const user = await currentUser();
    if (!user) throw new Error('Please sign in to access your dashboard.');
    return user;
  }

  async function sendMagicLink(email) {
    const { error } = await getClient().auth.signInWithOtp({
      email: email,
      options: { emailRedirectTo: window.location.href.split('#')[0] }
    });
    if (error) throw error;
  }

  async function signOut() {
    const { error } = await getClient().auth.signOut();
    if (error) throw error;
  }

  function onAuthChange(callback) {
    return getClient().auth.onAuthStateChange(function (_event, session) {
      callback(session ? session.user : null);
    });
  }

  function isDashboardAuthenticated() {
    return sessionStorage.getItem(DASHBOARD_SESSION_KEY) === 'true';
  }

  function signInToDashboard(password) {
    if (!window.JASON_DASHBOARD_PASSWORD || password !== window.JASON_DASHBOARD_PASSWORD) return false;
    sessionStorage.setItem(DASHBOARD_SESSION_KEY, 'true');
    return true;
  }

  function signOutOfDashboard() {
    sessionStorage.removeItem(DASHBOARD_SESSION_KEY);
  }

  window.JasonSupabase = {
    client: getClient,
    currentUser: currentUser,
    requireUser: requireUser,
    sendMagicLink: sendMagicLink,
    signOut: signOut,
    onAuthChange: onAuthChange,
    isDashboardAuthenticated: isDashboardAuthenticated,
    signInToDashboard: signInToDashboard,
    signOutOfDashboard: signOutOfDashboard
  };
})();
