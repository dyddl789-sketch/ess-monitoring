package com.lgy.ess_monitoring.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.BoardDAO;
import com.lgy.ess_monitoring.dto.BoardDTO;
import com.lgy.ess_monitoring.dto.Criteria;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BoardServiceImpl implements BoardService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<BoardDTO> list() {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		List<BoardDTO> list = dao.list();
		
		return list;
	}
	
	@Override
	public List<BoardDTO> listWithPaging(Criteria cri) {
		log.info("@# Criteria cri=>"+cri);

		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		
		return dao.listWithPaging(cri);
	}
	
	@Override
	public void write(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.write(param);
	}

	@Override
	public BoardDTO contentView(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardDTO dto = dao.contentView(param);
		
		return dto;
	}

	@Override
	public void modify(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.delete(param);
	}

	@Override
	public int getTotalCount(Criteria cri) {
		log.info("@# getTotalCount()");
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		return dao.getTotalCount(cri);
	}


	@Override
	public void increaseHit(int board_no) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.increaseHit(board_no);
	}

	@Override
	public int getWriterMemberId(int boardNo) {
		log.info("@# BoardServiceImpl getWriterMemberId()");		
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		return dao.getWriterMemberId(boardNo);
	}

	

}


















