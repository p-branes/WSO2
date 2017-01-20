package com.chakray;

import java.util.ArrayList;
import java.util.Map;

import org.apache.synapse.MessageContext;
import org.apache.synapse.core.axis2.Axis2MessageContext;
import org.apache.synapse.mediators.AbstractMediator;

public class SameNameHeaderMediator extends AbstractMediator {

	private String headerName ;

	public boolean mediate(MessageContext context) {
		
		try {
			System.out.println("SameNameHeaderMediator extracting headers...");

			org.apache.axis2.context.MessageContext msgContext = ((Axis2MessageContext) context)
					.getAxis2MessageContext();

			Map<String, String> excessHeaders = (Map<String, String>) msgContext
					.getProperty("EXCESS_TRANSPORT_HEADERS");

			Map<String, String> transportHeaders = (Map<String, String>) msgContext
					.getProperty("TRANSPORT_HEADERS");

			Object headersObject =  excessHeaders.get(headerName);
			ArrayList<String> headers = (ArrayList<String>)headersObject; 

			for (int i = 0; i < headers.size(); i++) {
				transportHeaders.put(headerName+"_"+i, headers.get(i));
				System.out.println("Added Header -> "+headerName+"_" + i +" : "+headers.get(i));
			}

//			Set<Entry<String, String>> transports = transportHeaders.entrySet();
//			Object transportsObject =  transportHeaders.get(headerName);
//			ArrayList<String> transports = (ArrayList<String>)transportsObject; 
//
//			for (int i = 0; i < transports.size(); i++) {
//				System.out.println("Logging Header -> "+headerName+"_" + i +" : "+transports.get(i));
//			}

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
