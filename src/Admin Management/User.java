package com.realestate.platform.AdminManagement;

public abstract class User {
    private String userId;
    private String name;
    private String email;
    private String password;
    private  String role;

    public User(){
    }

    public User(String puserId,String pname,String pemail,String ppassword,String prole){
        this.userId = puserId;
        this.name = pname;
        this.email = pemail;
        this.password = ppassword;
        this.role = prole;
    }

    public void setUserId(String puserId) {
        this.userId = puserId;
    }

    public void setName(String pname) {
        this.name = pname;
    }

    public void setEmail(String pemail) {
        this.email=pemail;
    }

    public void setPassword(String ppassword) {
        this.password = ppassword;
    }

    public void setRole(String prole) {
        this.role = prole;
    }

    public String getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

}
