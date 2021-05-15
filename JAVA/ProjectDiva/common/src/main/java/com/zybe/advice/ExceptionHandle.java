package com.zybe.advice;

import com.zybe.exception.CustomException;
import com.zybe.exception.Message;
import org.springframework.beans.TypeMismatchException;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.lang.reflect.Field;

@ControllerAdvice
public class ExceptionHandle {
    String POJO_PACKAGE = "com.zybe.pojo.";

    @ExceptionHandler(CustomException.class)
    private ResponseEntity<String> exceptionHandler(CustomException e) {
        return ResponseEntity.status(e.getStatus()).body(e.getMessage());
    }

    @ExceptionHandler(BindException.class)
    private ResponseEntity<String> exceptionHandler(BindException e) throws NoSuchFieldException, ClassNotFoundException {
        String message = "|";
        for (ObjectError objectError : e.getBindingResult().getAllErrors()) {
            //if the type of error is TypeMismatchException,use the @Message to specify error message
            if (objectError.contains(TypeMismatchException.class)) {
                message += getMessage(objectError);
                continue;
            }
            message += objectError.getDefaultMessage()+"|";
        }
        return ResponseEntity.badRequest().body(message);
    }

    private String initial2UpperCase(String s) {
        char[] cs = s.toCharArray();
        cs[0] -= 32;
        return String.valueOf(cs);
    }

    // get the @Message's value for the filed
    private String getMessage(ObjectError objectError) throws ClassNotFoundException, NoSuchFieldException {
        Class<?> aClass = Class.forName(POJO_PACKAGE + initial2UpperCase(objectError.getObjectName()));
        Field declaredField = aClass.getDeclaredField(((FieldError) objectError).getField());
        if (declaredField.isAnnotationPresent(Message.class)) {
            return declaredField.getAnnotation(Message.class).value()+"|";
        }
        return "";
    }
}
