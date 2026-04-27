package com.lgy.ess_monitoring.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.lgy.ess_monitoring.dto.BoardDTO;
import com.lgy.ess_monitoring.dto.Criteria;
import com.lgy.ess_monitoring.dto.PageDTO;
import com.lgy.ess_monitoring.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller  
@Slf4j
public class BoardController {
	@Autowired
	private BoardService service;
	
	@RequestMapping("/board_list")
	public String list(Criteria cri, Model model) {
		log.info("@# board_list()");
		// 현재 페이지 번호, 한 페이지 개수, 검색 조건 확인
		log.info("@# Criteria cri=>"+cri);
		
		List<BoardDTO> list = service.listWithPaging(cri);
		int total = service.getTotalCount(cri);
		
		
		model.addAttribute("list", list);
		model.addAttribute("pageMaker", new PageDTO(total, cri));
		
		return "board_list";
	}
	
	@RequestMapping("/board_write_view")
	public String write_view() {
		log.info("@# board_write_view()");
		
		return "board_write_view";
	}
	
	@RequestMapping("/board_write")
	public String write(@RequestParam HashMap<String, String> param, HttpSession session) {
	    log.info("@# board_write()");
	    log.info("@# param before => " + param);

	    Integer memberId = (Integer)session.getAttribute("member_id");
	    
	 // 로그인 안 되어 있으면 로그인 화면으로 이동
	    if (memberId == null) {
	        log.info("@# memberId is null");
	        return "redirect:/login_view";
	    }
	    
	    param.put("member_id", String.valueOf(memberId));
	    
	    log.info("@# session member_id => " + memberId);
	    log.info("@# param after => " + param);
	    service.write(param);

	    return "redirect:/board_list";
	}

	@RequestMapping("/board_content_view")
	public String content_view(@RequestParam HashMap<String, String> param
								, Model model
								, HttpSession session) {
		
		log.info("@# board_content_view()");
		log.info("@# param => " + param);
		
		// boardNo 파라미터를 꺼내서 int로 변환
	    // 이 값으로 어떤 게시글을 조회할지 결정함
		int boardNo = Integer.parseInt(param.get("board_no"));
		
		//조회수 증가
		service.increaseHit(boardNo);
		
		//게시글 상세 정보 조회
		BoardDTO dto = service.contentView(param);
	    log.info("@# dto => " + dto);
	    
	 // 현재 로그인한 회원의 member_id를 세션에서 꺼냄
	    // 로그인할 때 session.setAttribute("member_id", dto.getMember_id())가 되어 있어야 함
	    Integer loginMemberId = (Integer) session.getAttribute("member_id");
	    
	    //로그인 회원번호 확인
	    log.info("@# loginMemberId=>"+ loginMemberId);
	    
	    //jsp에서 ${content_view.필드명}으로 사용할 게시글 상세 정보 전달
		model.addAttribute("content_view", dto);
		
		//content_view.jsp 에서 pageMaker 를 가지고 페이징 처리
		model.addAttribute("pageMaker", param);
		
		// JSP에서 현재 로그인한 회원번호와 작성자 회원번호를 비교하기 위해 전달
		model.addAttribute("loginMemberId",loginMemberId);
		
		return "board_content_view";
	}
	
	
	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param,
						 @ModelAttribute("cri") Criteria cri,
						 RedirectAttributes rttr,
						 HttpSession session) {
		
		 // modify 메서드가 실행되었는지 확인
		log.info("@# modify()");
		// JSP form에서 넘어온 값 확인
		log.info("@# param=>" + param);
		// 페이징 정보 확인
		log.info("@# cri=>" + cri);
		
		// 1. 현재 로그인한 회원의 member_id를 세션에서 꺼냄
	    Integer loginMemberId = (Integer) session.getAttribute("member_id");

	    // 2. 로그인하지 않은 상태라면 수정 불가
	    if (loginMemberId == null) {
	        log.info("@# loginMemberId is null");

	        // 로그인 화면으로 보냄
	        return "redirect:/login_view";
	    }

	    // 3. 수정하려는 게시글 번호를 가져옴
	    int boardNo = Integer.parseInt(param.get("board_no"));

	    // 4. DB에서 해당 게시글의 작성자 member_id를 조회
	    int writerMemberId = service.getWriterMemberId(boardNo);

	    // 5. 확인용 로그
	    log.info("@# loginMemberId => " + loginMemberId);
	    log.info("@# writerMemberId => " + writerMemberId);

	    // 6. 현재 로그인한 회원과 게시글 작성자가 다르면 수정 차단
	    if (!loginMemberId.equals(writerMemberId)) {
	        log.info("@# 수정 권한 없음");

	        // 다시 상세보기 화면으로 돌아가기 위해 boardNo를 넘김
	        rttr.addAttribute("boardNo", boardNo);

	        // 기존 페이지 정보 유지
	        rttr.addAttribute("pageNum", cri.getPageNum());
	        rttr.addAttribute("amount", cri.getAmount());
	        rttr.addAttribute("type", cri.getType());
	        rttr.addAttribute("keyword", cri.getKeyword());
 
	        // 수정하지 않고 상세보기로 되돌아감
	        return "redirect:/board_content_view";
	    }

	    // 7. 작성자 본인이 맞으면 수정 실행
	    service.modify(param);

	    // 8. 수정 후 목록으로 돌아갈 때 기존 페이지 정보 유지
	    rttr.addAttribute("pageNum", cri.getPageNum());
	    rttr.addAttribute("amount", cri.getAmount());
	    rttr.addAttribute("type", cri.getType());
	    rttr.addAttribute("keyword", cri.getKeyword());

	    // 9. 수정 완료 후 게시판 목록으로 이동
	    return "redirect:/board_list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam HashMap<String, String> param,
	                     @ModelAttribute("cri") Criteria cri,
	                     RedirectAttributes rttr,
	                     HttpSession session) {

	    Integer loginMemberId = (Integer) session.getAttribute("member_id");

	    if (loginMemberId == null) {
	        return "redirect:/login_view";
	    }

	    String boardNoStr = param.get("board_no");

	    if (boardNoStr == null || boardNoStr.equals("")) {
	        throw new RuntimeException("board_no 없음");
	    }

	    int boardNo = Integer.parseInt(boardNoStr);

	    int writerMemberId = service.getWriterMemberId(boardNo);

	    if (!loginMemberId.equals(writerMemberId)) {
	        rttr.addAttribute("board_no", boardNo);
	        rttr.addAttribute("pageNum", cri.getPageNum());
	        rttr.addAttribute("amount", cri.getAmount());
	        rttr.addAttribute("type", cri.getType());
	        rttr.addAttribute("keyword", cri.getKeyword());

	        return "redirect:/board_content_view";
	    }

	    service.delete(param);

	    rttr.addAttribute("pageNum", cri.getPageNum());
	    rttr.addAttribute("amount", cri.getAmount());
	    rttr.addAttribute("type", cri.getType());
	    rttr.addAttribute("keyword", cri.getKeyword());

	    return "redirect:/board_list";
	}
	
}

