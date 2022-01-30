package com.example.medic_app.bean;

import com.linktop.constant.IUserProfile;

public class UserProfile implements IUserProfile {

    private final String userId;
    private final int gender;//0 means female; 1 means male.
    private final int age;
    private final int height;
    private final int weight;

    public UserProfile(String userId, int gender, int age, int height, int weight) {
        this.userId = userId;
        this.gender = gender;
        this.age = age;
        this.height = height;
        this.weight = weight;
    }
    @Override
    public String getUserId() {
        return userId;
    }
    @Override
    public int getGender() {
        return gender;
    }
    @Override
    public int getAge() {
        return age;
    }
    @Override
    public int getHeight() {
        return height;
    }
    @Override
    public int getWeight() {
        return weight;
    }
}
