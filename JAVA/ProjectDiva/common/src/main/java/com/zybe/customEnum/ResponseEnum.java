package com.zybe.customEnum;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ResponseEnum {
    UNFOUND_USER(400,"unfound user"),
    DELETE_SUCCESS(201,"delete success"),
    UPDATE_SUCCESS(201,"update success"),
    ARGS_ERROR(400,"ARGS_ERROR");

    private int status;
    private String message;
}
