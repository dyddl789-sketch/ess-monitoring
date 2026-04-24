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
	public String write(@RequestParam HashMap<String, String> param) {
	    log.info("@# board_write()");
	    log.info("@# param before => " + param);

	    // 로그인 기능 구현 전 임시 작성자 번호
	    param.put("member_id", "1");

	    log.info("@# param after => " + param);

	    service.write(param);

	    return "redirect:/board_list";
	}

	@RequestMapping("/board_content_view")
	public String content_view(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# board_content_view()");
		
		int boardNo = Integer.parseInt(param.get("boardNo"));
		service.increaseHit(boardNo);
		
		BoardDTO dto = service.contentView(param);
		model.addAttribute("content_view", dto);
//		content_view.jsp 에서 pageMaker 를 가지고 페이징 처리
		model.addAttribute("pageMaker", param);
		
		return "board_content_view";
	}
	
	@RequestMapping("/modify")
//	public String modify(@RequestParam HashMap<String, String> param, Model model) {
//	@ModelAttribute("cri") Criteria cri : Criteria 객체를 cri로 받는다
//	RedirectAttributes rttr : 쿼리 스트링 뒤에 추가
	public String modify(@RequestParam HashMap<String, String> param, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("@# modify()");
		log.info("@# cri=>" + cri);
		
		service.modify(param);
//		페이지 이동시 뒤에 페이지번호, 글 갯수 추가
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:list";
	}
	
	@RequestMapping("/delete")
//	public String delete(@RequestParam HashMap<String, String> param, Model model) {
	public String delete(@RequestParam HashMap<String, String> param, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("@# delete()");
		log.info("@# cri=>" + cri);
		
		service.delete(param);
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		
		return "redirect:list";
	}
	
}















