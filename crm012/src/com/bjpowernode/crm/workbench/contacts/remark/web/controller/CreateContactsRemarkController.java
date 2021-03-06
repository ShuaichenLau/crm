package com.bjpowernode.crm.workbench.contacts.remark.web.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bjpowernode.crm.settings.qx.user.domain.User;
import com.bjpowernode.crm.utils.DateUtils;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.workbench.contacts.remark.domain.ContactsRemark;
import com.bjpowernode.crm.workbench.contacts.remark.service.ContactRemarkService;
import com.bjpowernode.crm.workbench.contacts.remark.service.impl.ContactRemarkServiceImpl;

/**
 * 创建联系人备注
 * @author LauShuaichen
 * Servlet implementation class CreateContactsRemarkController
 */
@WebServlet("/workbench/contacts/remark/createContactsRemark.do")
public class CreateContactsRemarkController extends HttpServlet {

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("com.bjpowernode.crm.workbench.contacts.remark.web.controller.CreateContactsRemarkController");
		
		//获取参数
		String noteContent = request.getParameter("noteContent");
		String contactsId = request.getParameter("contactsId");
		
		//封装对象
		ContactsRemark contactsRemark = new ContactsRemark();
		
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		contactsRemark.setEditFlag(0);
		contactsRemark.setNoteContent(noteContent);
		contactsRemark.setContactsId(contactsId);
		contactsRemark.setNotePerson(user.getId());
		contactsRemark.setNoteTime(DateUtils.getDate());

		//调用service
		ContactRemarkService contactRemarkService = (ContactRemarkService) ServiceFactory.getService(new ContactRemarkServiceImpl());
		
		int ret = contactRemarkService.CreateContactsRemark(contactsRemark);
		
		Map<String, Object>map = new HashMap<String,Object>();
		
		if (ret > 0) {
			map.put("success", true);
		}else {
			map.put("success", false);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
