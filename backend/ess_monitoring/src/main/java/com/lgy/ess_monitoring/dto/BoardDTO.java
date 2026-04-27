package com.lgy.ess_monitoring.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDTO {
    private int board_no;
    private int member_id;
    private String board_title;
    private int board_hit;
    private String board_content;
    private Timestamp created_at;
    private Timestamp updated_at;

    // ess_member 조인용
    private String member_name;
}