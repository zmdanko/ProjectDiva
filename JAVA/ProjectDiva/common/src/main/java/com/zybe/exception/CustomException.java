package com.zybe.exception;

import com.zybe.customEnum.ResponseEnum;
import lombok.Getter;

@Getter
public class CustomException extends RuntimeException{
    private int status;

    public CustomException(int status, String message){
        super(message);
        this.status=status;
    }

    public CustomException(ResponseEnum responseEnum){
        super(responseEnum.getMessage());
        this.status= responseEnum.getStatus();
    }

    public CustomException(ResponseEnum responseEnum, String s){
        super(responseEnum.getMessage()+"," +
                s);
        this.status= responseEnum.getStatus();
    }
}
