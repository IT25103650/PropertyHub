package com.realestate.models;

public class Admin extends User{
    private String permissionLevel;

    public Admin(){
        setRole("ADMIN");
    }
}
