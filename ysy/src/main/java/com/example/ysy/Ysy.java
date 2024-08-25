package com.example.ysy;

import com.example.zsy.Zsy;

public class Ysy {

    private String id;

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    @Override
    public String toString() {
        System.out.println("YSYを表示");
        System.out.println(new Zsy());
        return super.toString();
    }
}
