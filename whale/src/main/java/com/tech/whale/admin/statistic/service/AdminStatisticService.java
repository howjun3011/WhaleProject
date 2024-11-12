package com.tech.whale.admin.statistic.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.tech.whale.admin.dao.AdminStatisticIDao;
import com.tech.whale.admin.dto.AdminLVDataDto;
import com.tech.whale.admin.dto.AdminRRDataDto;
import com.tech.whale.admin.service.AdminServiceInter;

@Service
public class AdminStatisticService implements AdminServiceInter{

	@Autowired
    private AdminStatisticIDao adminStatisticIDao;
	
	@Override
	public void execute(Model model) {
		
	}
	
	public void reportStatistic1(Model model) {
		
		List<AdminLVDataDto> dataList = adminStatisticIDao.reportStatistic1();
		// 데이터 가공 후 x축 레이블과 y축 데이터로 분리
		List<String> labels = new ArrayList<>();
		List<Integer> values = new ArrayList<>();
		
		for (AdminLVDataDto data : dataList) {
			labels.add(data.getLabel());
			values.add(data.getValue());
		}
		
		model.addAttribute("reportLabels1", labels);
		model.addAttribute("reportValues1", values);
		
	}
	
	public void reportStatistic2(Model model) {
		
		List<AdminLVDataDto> dataList = adminStatisticIDao.reportStatistic2();
		// 데이터 가공 후 x축 레이블과 y축 데이터로 분리
		List<String> labels = new ArrayList<>();
		List<Integer> values = new ArrayList<>();
		
		for (AdminLVDataDto data : dataList) {
			labels.add(data.getLabel());
			values.add(data.getValue());
		}
		
		model.addAttribute("reportLabels2", labels);
		model.addAttribute("reportValues2", values);
		
	}
	
	public void reportStatistic3(Model model) {
		
		List<AdminRRDataDto> dataList = adminStatisticIDao.reportStatistic3();
		// 데이터 가공 후 x축 레이블과 y축 데이터로 분리
		List<String> target_type = new ArrayList<>();
		List<String> report_result_action = new ArrayList<>();
		List<Integer> action_count = new ArrayList<>();
		
		for (AdminRRDataDto data : dataList) {
			if(data.getTarget_type().equals("feed")) {
				target_type.add("피드");
			}else if(data.getTarget_type().equals("feed_comments")) {
				target_type.add("피드댓글");
			}else if(data.getTarget_type().equals("post")) {
				target_type.add("커뮤");
			}else if(data.getTarget_type().equals("post_comments")) {
				target_type.add("커뮤댓글");
			}else if(data.getTarget_type().equals("message")) {
				target_type.add("메시지");
			}
			if(data.getReport_result_action().equals("-")) {
				report_result_action.add("정상게시물");
			}else if(data.getReport_result_action().equals("작성글 삭제")) {
				report_result_action.add("삭제게시물");
			}
			action_count.add(data.getAction_count());
		}
		
		model.addAttribute("action_count", action_count);
		model.addAttribute("report_result_action", report_result_action);
		model.addAttribute("target_type", target_type);
		
	}

}
