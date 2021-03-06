package com.bjpowernode.crm.commons.web.listener;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.bjpowernode.crm.settings.dictionary.domain.DictionaryValue;
import com.bjpowernode.crm.settings.dictionary.service.DictionaryValueService;
import com.bjpowernode.crm.settings.dictionary.service.impl.DictionaryValueServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

/**
 * Application Lifecycle Listener implementation class QuerySourceContextListener
 *
 */
@WebListener
public class QuerySourceContextListener implements ServletContextListener {

    /**
     * Default constructor. 
     */
    public QuerySourceContextListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent sce)  { 
         // TODO Auto-generated method stub
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent sce)  { 
         System.err.println("****com.bjpowernode.crm.commons.web.listener.QuerySourceContextListener");
         DictionaryValueService dictionaryValueService = (DictionaryValueService) ServiceFactory
   				.getService(new DictionaryValueServiceImpl());
   		List<DictionaryValue> sourceList = dictionaryValueService.queryDicValueBygrade("source");
   		ServletContext servletContext = sce.getServletContext();
   		servletContext.setAttribute("sourceList", sourceList);
    }
	
}
