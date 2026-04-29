package com.lgy.ess_monitoring.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.EssDeviceDAO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class EssDeviceServiceImpl implements EssDeviceService{
	
	@Autowired
	private SqlSession sqlSession;
	

	@Override
	public void inseretDevice(EssDeviceDTO deviceDTO) {
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
		dao.insertDevice(deviceDTO);
		
	}

	@Override
	public ArrayList<EssDeviceDTO> getDeviceList(int member_id) {
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
		return dao.getDeviceList(member_id);
	}

	@Override
	public int getDeviceCount(int member_id) {
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
		return dao.getDeviceCount(member_id);
	}

	@Override
	public int deleteDevice(int device_id, int member_id) {
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
		
		int result = dao.deleteDevice(device_id, member_id);
		
		return result;
	}

	@Override
	public EssDeviceDTO deviceDetail(int device_id) {
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
		EssDeviceDTO dto = dao.deviceDetail(device_id);
		
		return dto;
	}

	@Override
	public void setMainDevice(int member_id, int device_id) {
		log.info("@# setMainDevice()");
	    log.info("@# member_id => " + member_id);
	    log.info("@# device_id => " + device_id);
	    
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);
	    // 1. 기존 대표 디바이스 전체 해제
	    dao.clearMainDevice(member_id);

	    // 2. 선택한 디바이스를 대표 디바이스로 설정
	    EssDeviceDTO dto = new EssDeviceDTO();
	    dto.setMember_id(member_id);
	    dto.setDevice_id(device_id);

	    dao.setMainDevice(dto);
	}

	@Override
	public EssDeviceDTO getMainDevice(int member_id) {
		log.info("@# getMainDevice()");
        log.info("@# member_id => " + member_id);
        
		EssDeviceDAO dao = sqlSession.getMapper(EssDeviceDAO.class);

        return dao.getMainDevice(member_id);
	}
	
}





