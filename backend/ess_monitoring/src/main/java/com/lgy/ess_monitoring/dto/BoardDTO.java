package com.lgy.ess_monitoring.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDTO {
	private int board_no; // 글 번호
	private String member_id; // 작성자 회원 번호
	private String board_title; // 글 제목
	private int board_hit; // 글 조회수
	private String board_content; // 글 내용
	private Timestamp created_at; // 작성일
	private Timestamp updated_at; // 수정일
	private String member_name; // 조인용으로 생성
}
