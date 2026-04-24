package com.lgy.ess_monitoring.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.lgy.ess_monitoring.dto.BoardDTO;
import com.lgy.ess_monitoring.dto.Criteria;




public interface BoardService {
	public List<BoardDTO> list();// 전체 목록
	public List<BoardDTO> listWithPaging(Criteria cri);// 페이징 목록
	public void write(HashMap<String, String> param);// 글쓰기
	public BoardDTO contentView(HashMap<String, String> param);// 상세보기
	public void modify(HashMap<String, String> param);// 수정
	public void delete(HashMap<String, String> param);// 삭제
	public int getTotalCount(Criteria cri);// 전체 게시글 수
	public void increaseHit(int board_no);// 조회수 증가
	public int getWriterMemberId(int boardNo);

}
