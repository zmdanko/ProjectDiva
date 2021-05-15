package com.zybe.controller;

import com.zybe.customEnum.ResponseEnum;
import com.zybe.pojo.Diva;
import com.zybe.service.DivaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RefreshScope
public class DivaController  {
    @Autowired
    private DivaService divaService;

    @Value("${properties.num}")
    private String num;

    @GetMapping("/num")
    public String num(){
        return num;
    }

    @GetMapping("/")
    public List<Diva> selectAll() {
        List<Diva> list = divaService.selectAll();
        return list;
    }

    @PostMapping("/")
    public ResponseEntity<Long> insert(@RequestBody @Valid Diva diva) {
        Long id = divaService.insert(diva);
        return ResponseEntity.status(HttpStatus.CREATED).body(id);
    }

    @PostMapping("/update")
    public ResponseEntity<String> update(@Valid Diva diva) {
        divaService.update(diva);
        return ResponseEntity.status(ResponseEnum.UPDATE_SUCCESS.getStatus()).body(ResponseEnum.UPDATE_SUCCESS.getMessage());
    }

    @PostMapping("/delete")
    public ResponseEntity<String> delete(Diva diva) {
        divaService.delete(diva);
        return ResponseEntity.status(ResponseEnum.DELETE_SUCCESS.getStatus()).body(ResponseEnum.DELETE_SUCCESS.getMessage());
    }
}