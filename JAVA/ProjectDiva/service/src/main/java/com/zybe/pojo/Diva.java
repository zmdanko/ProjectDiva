package com.zybe.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.zybe.exception.Message;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.*;
import java.util.Date;

@Data
@Table(name = "[diva]")
public class Diva{
    @Id
    private Long id;
    @Length(min = 1,max=10,message = "name's length is 1 to 10")
    @JsonProperty(value = "名称")
    private String name;
    @DecimalMax("1000000")
    @JsonProperty("数量")
    private Integer num;
    @Message("date format is yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonProperty("日期")
    private Date date;
}
