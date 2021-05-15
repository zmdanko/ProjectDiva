package com.zybe.service;

import com.zybe.customEnum.ResponseEnum;
import com.zybe.exception.CustomException;
import com.zybe.mapper.DivaMapper;
import com.zybe.pojo.Diva;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Stream;

@Service
@RefreshScope
public class DivaService {
    @Autowired
    private DivaMapper divaMapper;

    @Value("${properties.random-length}")
    double RANDOM_LENGTH;

    public List<Diva> selectAll() {
        return divaMapper.selectAll();
    }

    public Long insert(Diva diva) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
        int ramdomNum = getRandomNum();
        Long id = Long.parseLong(simpleDateFormat.format(new Date()) + ramdomNum);
        diva.setId(id);
        divaMapper.insertSelective(diva);
        return id;
    }

    private int getRandomNum() {
        if (RANDOM_LENGTH > 4) {
            throw new CustomException(ResponseEnum.ARGS_ERROR, "properties.random-length maximum is 4 ");
        }
        int randomNum = (int) ((Math.random() + 1) * Math.pow(10, RANDOM_LENGTH - 1));
        return randomNum;
    }

    public void update(Diva diva) {
        divaMapper.updateByPrimaryKeySelective(diva);
    }

    public void delete(Diva diva) {
        divaMapper.deleteByPrimaryKey(diva);
    }
}
