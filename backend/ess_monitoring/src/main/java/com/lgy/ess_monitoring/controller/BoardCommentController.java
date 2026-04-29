package com.lgy.ess_monitoring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lgy.ess_monitoring.dto.BoardCommentDTO;
import com.lgy.ess_monitoring.service.BoardCommentService;

import lombok.extern.slf4j.Slf4j;

/**
 * 문의게시판 댓글 Controller
 *
 * 역할:
 * - 문의게시판 상세 페이지에서 관리자 답변 등록 요청을 처리한다.
 * - 일반 회원은 댓글을 작성할 수 없고, 사이트 관리자만 작성 가능하게 제한한다.
 */

@Controller
@Slf4j
public class BoardCommentController {
	
	/**
     * 문의게시판 댓글 Service
     *
     * 역할:
     * - 댓글 등록 / 삭제 / 목록 조회 기능을 Service 계층으로 위임한다.
     */
	@Autowired
	private BoardCommentService commentService;
	
	/**
     * 관리자 댓글 등록
     *
     * 요청 URL:
     * - /comment_write
     *
     * 호출 방식:
     * - board_content_view.jsp에서 Ajax로 호출
     *
     * 처리 흐름:
     * 1. 로그인 여부 확인
     * 2. 관리자 권한 확인
     * 3. 댓글 내용 빈 값 확인
     * 4. BoardCommentDTO 생성
     * 5. board_comment 테이블에 댓글 등록
     */
	
    @ResponseBody
    @RequestMapping("/comment_write")
    public String commentWrite(@RequestParam("board_no") int board_no,
                               @RequestParam("comment_content") String comment_content,
                               HttpSession session) {

        log.info("@# comment_write()");
        log.info("@# board_no => " + board_no);
        log.info("@# comment_content => " + comment_content);

        // 1. 세션에서 로그인한 회원 번호 가져오기
        // 로그인하지 않은 경우 null이 들어온다.
        Integer member_id = (Integer) session.getAttribute("member_id");

        // 2. 세션에서 회원 유형 가져오기
        // 예: ADMIN, USER, COMPANY, 관리자 등
        String user_type = (String) session.getAttribute("user_type");

        log.info("@# member_id => " + member_id);
        log.info("@# user_type => " + user_type);

        // 3. 로그인 여부 체크
        if (member_id == null) {
            log.info("@# 댓글 등록 실패: 로그인 필요");
            return "login_required";
        }

        // 4. 관리자 여부 체크
        // 현재는 user_type이 ADMIN 또는 관리자일 때만 댓글 등록 허용
        // DB에 저장된 관리자 값이 다르면 이 조건을 맞춰서 수정해야 한다.
        if (!"ADMIN".equals(user_type) && !"관리자".equals(user_type)) {
            log.info("@# 댓글 등록 실패: 관리자 권한 없음");
            return "not_admin";
        }

        // 5. 댓글 내용 빈 값 체크
        if (comment_content == null || comment_content.trim().equals("")) {
            log.info("@# 댓글 등록 실패: 댓글 내용 없음");
            return "empty";
        }

        // 6. 댓글 DTO 생성
        BoardCommentDTO dto = new BoardCommentDTO();

        // 어떤 게시글에 달린 댓글인지 저장
        dto.setBoard_no(board_no);

        // 댓글 작성자는 현재 로그인한 관리자 회원 번호
        dto.setMember_id(member_id);

        // 앞뒤 공백 제거 후 댓글 내용 저장
        dto.setComment_content(comment_content.trim());

        log.info("@# insert comment dto => " + dto);

        // 7. 댓글 등록 처리
        commentService.insertComment(dto);

        log.info("@# 댓글 등록 성공");

        return "success";
    }
    
    /**
     * 관리자 댓글 수정
     *
     * 요청 URL:
     * - /comment_modify
     *
     * 호출 방식:
     * - board_content_view.jsp에서 Ajax로 호출
     *
     * 처리 흐름:
     * 1. 로그인 여부 확인
     * 2. 관리자 권한 확인
     * 3. 댓글 내용 빈 값 확인
     * 4. 댓글 번호와 수정 내용을 DTO에 담기
     * 5. board_comment 테이블 수정
     */
    @ResponseBody
    @RequestMapping("/comment_modify")
    public String commentModify(@RequestParam("comment_id") int comment_id,
                                @RequestParam("comment_content") String comment_content,
                                HttpSession session) {

        log.info("@# comment_modify()");
        log.info("@# comment_id => " + comment_id);
        log.info("@# comment_content => " + comment_content);

        // 로그인 회원 번호
        Integer member_id = (Integer) session.getAttribute("member_id");

        // 회원 유형
        String user_type = (String) session.getAttribute("user_type");

        log.info("@# member_id => " + member_id);
        log.info("@# user_type => " + user_type);

        // 1. 로그인 여부 체크
        if (member_id == null) {
            log.info("@# 댓글 수정 실패: 로그인 필요");
            return "login_required";
        }

        // 2. 관리자 여부 체크
        if (!"ADMIN".equals(user_type) && !"관리자".equals(user_type)) {
            log.info("@# 댓글 수정 실패: 관리자 권한 없음");
            return "not_admin";
        }

        // 3. 댓글 내용 빈 값 체크
        if (comment_content == null || comment_content.trim().equals("")) {
            log.info("@# 댓글 수정 실패: 댓글 내용 없음");
            return "empty";
        }

        // 4. 수정할 댓글 DTO 생성
        BoardCommentDTO dto = new BoardCommentDTO();

        // 수정 대상 댓글 번호
        dto.setComment_id(comment_id);

        // 수정할 댓글 내용
        dto.setComment_content(comment_content.trim());

        log.info("@# update comment dto => " + dto);

        // 5. 댓글 수정 처리
        commentService.updateComment(dto);

        log.info("@# 댓글 수정 성공");

        return "success";
    }
    
    /**
     * 관리자 댓글 삭제
     *
     * 요청 URL:
     * - /comment_delete
     *
     * 호출 방식:
     * - board_content_view.jsp에서 Ajax로 호출
     *
     * 처리 흐름:
     * 1. 로그인 여부 확인
     * 2. 관리자 권한 확인
     * 3. 댓글 번호를 DTO에 담기
     * 4. board_comment 테이블에서 삭제
     */
    @ResponseBody
    @RequestMapping("/comment_delete")
    public String commentDelete(@RequestParam("comment_id") int comment_id,
                                HttpSession session) {

        log.info("@# comment_delete()");
        log.info("@# comment_id => " + comment_id);

        // 로그인 회원 번호
        Integer member_id = (Integer) session.getAttribute("member_id");

        // 회원 유형
        String user_type = (String) session.getAttribute("user_type");

        log.info("@# member_id => " + member_id);
        log.info("@# user_type => " + user_type);

        // 1. 로그인 여부 체크
        if (member_id == null) {
            log.info("@# 댓글 삭제 실패: 로그인 필요");
            return "login_required";
        }

        // 2. 관리자 여부 체크
        if (!"ADMIN".equals(user_type) && !"관리자".equals(user_type)) {
            log.info("@# 댓글 삭제 실패: 관리자 권한 없음");
            return "not_admin";
        }

        // 3. 삭제할 댓글 DTO 생성
        BoardCommentDTO dto = new BoardCommentDTO();

        // 삭제 대상 댓글 번호
        dto.setComment_id(comment_id);

        log.info("@# delete comment dto => " + dto);

        // 4. 댓글 삭제 처리
        commentService.deleteComment(dto);

        log.info("@# 댓글 삭제 성공");

        return "success";
    }
}
