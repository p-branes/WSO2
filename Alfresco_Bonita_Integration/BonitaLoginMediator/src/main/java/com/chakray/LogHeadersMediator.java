package com.chakray;

import java.util.ArrayList;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.synapse.MessageContext;
import org.apache.synapse.core.axis2.Axis2MessageContext;
import org.apache.synapse.mediators.AbstractMediator;

public class LogHeadersMediator extends AbstractMediator {

	private String headerName ;

	public boolean mediate(MessageContext context) {
		
		try {
			System.out.println("LogHeadersMediator extracting headers...");

			org.apache.axis2.context.MessageContext msgContext = ((Axis2MessageContext) context)
					.getAxis2MessageContext();

			Map<String, String> transportHeaders = (Map<String, String>) msgContext
					.getProperty("TRANSPORT_HEADERS");

				
			Object transportsObject =  transportHeaders.get(headerName);
			ArrayList<String> transports = (ArrayList<String>)transportsObject; 

			for (int i = 0; i < transports.size(); i++) {
				System.out.println("Logging Header -> "+headerName+"_" + i +" : "+transports.get(i));
			}

		} catch (Exception e) {
			System.out.println("Exception: " + e);
			handleException("Exception", e, context);
		}

		return true;
	}

	public String getHeaderName() {
		return headerName;
	}

	public void setHeaderName(String headerName) {
		this.headerName = headerName;
	}

}
