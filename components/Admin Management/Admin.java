package com.realestate.platform.models;

public class Admin extends User{
    private String permissionLevel;

    public Admin(){
        setRole("ADMIN");

    }

    public Admin(String puserId, String pname, String pemail, String ppassword, String ppermissionLevel) {
        super(puserId, pname, pemail, ppassword, "ADMIN");
        this.permissionLevel = ppermissionLevel;
    }
    public String getPermissionLevel(){
        return permissionLevel;
    }
    public void setPermissionLevel(String ppermissionLevel){
        this.permissionLevel=ppermissionLevel;
    }

    @Override
    public String displayDashboard() {
        return "redirect:/admin-dashboard";
    }
}
