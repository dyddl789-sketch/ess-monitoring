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
	
}
