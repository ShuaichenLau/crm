package com.bjpowernode.crm.settings.qx.web.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bjpowernode.crm.settings.qx.domain.User;
import com.bjpowernode.crm.settings.qx.service.UserService;
import com.bjpowernode.crm.settings.qx.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

/**
 * Servlet implementation class QxUserEditController
 */
@WebServlet("/settings/qx/user/edit.do")
public class QxUserEditController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("com.bjpowernode.crm.settings.qx.web.controller.QxUserEditController");
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charSet=utf-8");
		String id = request.getParameter("id");
		
		UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
		User u = userService.getById(id);
		
		String lockStatus1 = u.getLockStatus();
		String lockStatusStr = "启用";
		if ("1".equals(lockStatus1)) {
			lockStatusStr = "锁定";
		}
		
		StringBuffer buffer = new StringBuffer();

		buffer.append("{\"id\":\""+u.getId()+"\",\"loginAct\":\""+u.getLoginAct()+"\",\"loginPwd\":\""+u.getLoginPwd()+"\",\"name\":\""+u.getName()+"\",\"deptName\":\""+u.getDeptName()+"\",\"email\":\""+u.getEmail()+"\",\"lockStatus\":\""+u.getLockStatus()+"\",\"allowIps\":\""+u.getAllowIps()+"\",\"expireTime\":\""+u.getExpireTime()+"\",\"createBy\":\""+u.getCreateBy()+"\",\"createTime\":\""+u.getCreateTime()+"\",\"updateBy\":\""+u.getUpdateBy()+"\",\"updateTime\":\""+u.getUpdateTime()+"\",\"lockStatusStr\":\""+lockStatusStr+"\"}");
		
		
		
		PrintWriter pw = response.getWriter();
		pw.print("success");
		pw.close();
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
