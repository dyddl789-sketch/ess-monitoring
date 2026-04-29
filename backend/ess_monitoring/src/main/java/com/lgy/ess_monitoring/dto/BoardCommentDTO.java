package com.lgy.ess_monitoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardCommentDTO {
	// 댓글 번호
    private int comment_id;

    // 댓글이 달린 게시글 번호
    private int board_no;

    // 댓글 작성자 회원 번호
    private int member_id;

    // 댓글 작성자 이름
    // board_comment 테이블에는 없지만 ess_member와 join해서 조회할 값
    private String member_name;

    // 댓글 내용
    private String comment_content;

    // 댓글 작성일
    private String created_at;

    // 댓글 수정일
    private String updated_at;
}
