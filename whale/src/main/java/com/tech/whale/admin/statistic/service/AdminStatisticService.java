package com.tech.whale.admin.statistic.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminStatisticIDao;
import com.tech.whale.admin.dto.AdminUserDataDto;
import com.tech.whale.admin.service.AdminServiceInter;

@Service
public class AdminStatisticService implements AdminServiceInter{

	@Autowired
    private AdminStatisticIDao adminStatisticIDao;
	
	@Override
	public void execute(Model model) {
		
		List<AdminUserDataDto> dataList = adminStatisticIDao.reportStatistic();
		// 데이터 가공 후 x축 레이블과 y축 데이터로 분리
        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();
        
        for (AdminUserDataDto data : dataList) {
            labels.add(data.getLabel());
            values.add(data.getValue());
        }
        
        model.addAttribute("dataList", dataList);
        model.addAttribute("labels", labels);
        model.addAttribute("values", values);
        
	}

}
