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
    private BoardService boardService;

    @RequestMapping("/board_list")
    public String boardList(Criteria criteria, Model model) {
        List<BoardDTO> boardList = boardService.listWithPaging(criteria);
        int totalCount = boardService.getTotalCount(criteria);

        model.addAttribute("list", boardList);
        model.addAttribute("pageMaker", new PageDTO(totalCount, criteria));

        return "board_list";
    }

    @RequestMapping("/board_write_view")
    public String boardWriteView() {
        return "board_write_view";
    }

    @RequestMapping("/board_write")
    public String boardWrite(@RequestParam HashMap<String, String> params,
                             HttpSession session) {
        Integer memberId = (Integer) session.getAttribute("memberId");

        if (memberId == null) {
            return "redirect:/login_view";
        }

        params.put("memberId", String.valueOf(memberId));
        boardService.write(params);

        return "redirect:/board_list";
    }

    @RequestMapping("/board_content_view")
    public String boardContentView(@RequestParam HashMap<String, String> params,
                                   Model model,
                                   HttpSession session) {
        int boardNo = Integer.parseInt(params.get("boardNo"));

        boardService.increaseHit(boardNo);

        BoardDTO boardDto = boardService.contentView(params);
        Integer loginMemberId = (Integer) session.getAttribute("memberId");

        model.addAttribute("content_view", boardDto);
        model.addAttribute("pageMaker", params);
        model.addAttribute("loginMemberId", loginMemberId);

        return "board_content_view";
    }

    @RequestMapping("/modify")
    public String modify(@RequestParam HashMap<String, String> params,
                         @ModelAttribute("cri") Criteria criteria,
                         RedirectAttributes redirectAttributes,
                         HttpSession session) {
        Integer loginMemberId = (Integer) session.getAttribute("memberId");

        if (loginMemberId == null) {
            return "redirect:/login_view";
        }

        int boardNo = Integer.parseInt(params.get("boardNo"));
        int writerMemberId = boardService.getWriterMemberId(boardNo);

        if (!loginMemberId.equals(writerMemberId)) {
            redirectAttributes.addAttribute("boardNo", boardNo);
            redirectAttributes.addAttribute("pageNum", criteria.getPageNum());
            redirectAttributes.addAttribute("amount", criteria.getAmount());
            redirectAttributes.addAttribute("type", criteria.getType());
            redirectAttributes.addAttribute("keyword", criteria.getKeyword());

            return "redirect:/board_content_view";
        }

        boardService.modify(params);

        redirectAttributes.addAttribute("pageNum", criteria.getPageNum());
        redirectAttributes.addAttribute("amount", criteria.getAmount());
        redirectAttributes.addAttribute("type", criteria.getType());
        redirectAttributes.addAttribute("keyword", criteria.getKeyword());

        return "redirect:/board_list";
    }

    @RequestMapping("/delete")
    public String delete(@RequestParam HashMap<String, String> params,
                         @ModelAttribute("cri") Criteria criteria,
                         RedirectAttributes redirectAttributes,
                         HttpSession session) {
        Integer loginMemberId = (Integer) session.getAttribute("memberId");

        if (loginMemberId == null) {
            return "redirect:/login_view";
        }

        String boardNoText = params.get("boardNo");

        if (boardNoText == null || boardNoText.trim().isEmpty()) {
            throw new RuntimeException("boardNo 없음");
        }

        int boardNo = Integer.parseInt(boardNoText);
        int writerMemberId = boardService.getWriterMemberId(boardNo);

        if (!loginMemberId.equals(writerMemberId)) {
            redirectAttributes.addAttribute("boardNo", boardNo);
            redirectAttributes.addAttribute("pageNum", criteria.getPageNum());
            redirectAttributes.addAttribute("amount", criteria.getAmount());
            redirectAttributes.addAttribute("type", criteria.getType());
            redirectAttributes.addAttribute("keyword", criteria.getKeyword());

            return "redirect:/board_content_view";
        }

        boardService.delete(params);

        redirectAttributes.addAttribute("pageNum", criteria.getPageNum());
        redirectAttributes.addAttribute("amount", criteria.getAmount());
        redirectAttributes.addAttribute("type", criteria.getType());
        redirectAttributes.addAttribute("keyword", criteria.getKeyword());

        return "redirect:/board_list";
    }
}