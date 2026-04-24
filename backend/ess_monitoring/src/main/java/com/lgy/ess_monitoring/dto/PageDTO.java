package com.lgy.ess_monitoring.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	//페이지번호가 10개씩 보이게(1~10, 11~20)
	private int startPage;//시작페이지: 1, 11
	private int endPage;// 끝페이지: 10, 20
	private boolean prev, next;
	private int total;
	private Criteria cri;//화면에 출력 갯수
	
//	@Override
//	public String toString() {
//		String toStr = "@#startPage=>"+startPage
//					 + "@#startPage=>"+endPage
//					 + "@# prev=>"+prev 
//					 + "@# next=>"+next 
//					 + "@# total=>"+getTotal()
//					 + "@# cri=>"+getCri();
//		return toStr;
//	}
	public PageDTO(int total, Criteria cri) {
		this.total = total;
		this.cri = cri;
		
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		this.startPage = this.endPage - 9;

//		int realEnd = (int)(Math.ceil(total * 1.0) / cri.getAmount());
		int realEnd = (int)(Math.ceil(total * 1.0 / cri.getAmount()));
		
		if(realEnd <= this.endPage) {
			this.endPage = realEnd;
		}
		
//		1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
		this.prev = this.startPage > 1;
		
//		ex> 10페이지 < 30페이지
		this.next = this.endPage < realEnd;
	}
}
