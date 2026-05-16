package com.realestate.models;

/**
 * Session — manages user identity and role-based navigation for the platform.
 *
 * Shared by all modules: Buyer, Seller, and Admin each call
 * Session.login() to authenticate and Session.getDashboardRedirect()
 * to determine where to send the user after login.
 */
public class Session {

    private String userId;
    private String userName;
    private String userEmail;
    private String userRole;       // "admin" | "seller" | "buyer" | "both"
    private String profileImageUrl;
    private boolean loggedIn;

    public Session() {
        this.loggedIn = false;
    }

    // ─── LOGIN ────────────────────────────────────────────────────────────────

    /**
     * Authenticates a user and populates session state.
     * Called by Buyer.login(), Seller.login(), and Admin.login().
     *
     * @return redirect URL based on user role
     */
    public String login(String userId, String userName, String userEmail,
                        String userRole, String profileImageUrl) {
        this.userId         = userId;
        this.userName       = userName;
        this.userEmail      = userEmail;
        this.userRole       = userRole;
        this.profileImageUrl = profileImageUrl;
        this.loggedIn       = true;
        return getDashboardRedirect();
    }

    /**
     * Role-based redirect after successful login or registration.
     * Admin → /admin-dashboard
     * Seller → /seller-dashboard
     * Buyer/Both → / (home page)
     */
    public String getDashboardRedirect() {
        if (!loggedIn) return "/login";
        switch (userRole.toLowerCase()) {
            case "admin":  return "/admin-dashboard";
            case "seller": return "/seller-dashboard";
            case "buyer":
            case "both":
            default:       return "/";
        }
    }

    // ─── LOGOUT ───────────────────────────────────────────────────────────────

    /**
     * Clears all session attributes. Called by HomeController logout.
     */
    public void logout() {
        this.userId          = null;
        this.userName        = null;
        this.userEmail       = null;
        this.userRole        = null;
        this.profileImageUrl = null;
        this.loggedIn        = false;
    }

    // ─── GUARD HELPERS ────────────────────────────────────────────────────────

    public boolean isLoggedIn()  { return loggedIn; }
    public boolean isAdmin()     { return loggedIn && "admin".equalsIgnoreCase(userRole); }
    public boolean isSeller()    { return loggedIn && ("seller".equalsIgnoreCase(userRole) || "both".equalsIgnoreCase(userRole)); }
    public boolean isBuyer()     { return loggedIn && ("buyer".equalsIgnoreCase(userRole)  || "both".equalsIgnoreCase(userRole)); }

    // ─── GETTERS / SETTERS ────────────────────────────────────────────────────

    public String getUserId()          { return userId; }
    public String getUserName()        { return userName; }
    public String getUserEmail()       { return userEmail; }
    public String getUserRole()        { return userRole; }
    public String getProfileImageUrl() { return profileImageUrl; }

    public void setUserName(String name)          { this.userName = name; }
    public void setUserEmail(String email)         { this.userEmail = email; }
    public void setProfileImageUrl(String imgUrl) { this.profileImageUrl = imgUrl; }
}

