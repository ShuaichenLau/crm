package com.bjpowernode.crm.workbench.activity.service.impl;

import java.util.List;
import java.util.Map;

import com.bjpowernode.crm.commons.vo.PaginationVO;
import com.bjpowernode.crm.utils.SqlSessionutils;
import com.bjpowernode.crm.workbench.activity.dao.MarketActivityDao;
import com.bjpowernode.crm.workbench.activity.domain.MarketActivity;
import com.bjpowernode.crm.workbench.activity.service.MarketActivityService;

/**
 * 
 * @author LauShuaichen
 *
 */
public class MarketActivityServiceImpl implements MarketActivityService {

	private MarketActivityDao marketActivityDao = SqlSessionutils.getSession().getMapper(MarketActivityDao.class);

	/**
	 * 市场活动创建
	 */
	@Override
	public int insertCreateMarketActivity(MarketActivity marketActivity) {
		return marketActivityDao.insertCreateMarketActivity(marketActivity);
	}

	/**
	 * 根据条件分页查询市场活动
	 */
	@Override
	public PaginationVO<MarketActivity> queryMarketActivityForPageByCondition(Map<String, Object> map) {
		// 调用dao查询记录列表
		List<MarketActivity> activityList = marketActivityDao.queryMarketActivityForPageByCondition(map);
		// 调用dao查询记录总数
		long totalCount = marketActivityDao.queryTotalCountofMarketActivityByCondition(map);

		// 把activityList和totalCount封装成paginationVO
		PaginationVO<MarketActivity> vo = new PaginationVO<MarketActivity>();
		vo.setDataList(activityList);
		vo.setTotalCount(totalCount);

		return vo;
	}

}
