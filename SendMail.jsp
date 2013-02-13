 <%@ page import="java.util.*" %>
 <%@ page import="javax.mail.*" %>
 <%@ page import="javax.mail.internet.*" %>
 <%@ page import="javax.activation.*" %>
 <%@ page import="java.util.regex.*"%> 
  <%
		String host = "your server";
	    String from = "your email";
		String to = "to who sent the email"; // you can write also many string with writing the email for example String general = "youremail@domain" and then String to = "" to = general 
		String plainPart = "";
		String htmlPart = "";
        String title  = "";
        String name  = "";
		String surname = "";
		String company = "";
		String email = "";
		String phone = "";
		String EmailMessage = "";
		String form1 = request.getParameter("contact-form"); // take a parameter from an hidden field so in this way if you have more form with different parameter you can still use this form
		String removeDoubleQuotesName = "";
		boolean sessionDebug = false;
		boolean b1 = true;
	    boolean b2 = true;
	    boolean b3 = true;
	    boolean b4 = true;
		boolean b5 = true;
		boolean b6 = true;
	    Properties props = System.getProperties();
		props.put("mail.host", host);
		props.put("mail.transport.protocol", "smtp");
		Session mailSession = Session.getDefaultInstance(props, null);
		mailSession.setDebug(sessionDebug);
		Message msg = new MimeMessage(mailSession);
		
	   if (form1 != null) // in this way if you have more form with different parameter you can still use this form
	   {
	     	EmailMessage = request.getParameter("msg");
        title = request.getParameter("title");
        name = request.getParameter("name");
	      surname = request.getParameter("surname");
        company = request.getParameter("company");
		    email = request.getParameter("email");
        phone = request.getParameter("phone");
		if (name != "")
		{
			 Pattern pt1=Pattern.compile("(\\S+[^\\\\'>%;<\\\\+\\x22\\x27/()]{2,}$)");
			 removeDoubleQuotesName = name.replaceAll("\"", "\\\\\"");
		   name = removeDoubleQuotesName;
			 Matcher mt1=pt1.matcher(name); 
		   b1=mt1.matches(); 
		}
		if (surname != "")
		{
		  Pattern pt2=Pattern.compile("(\\S+[^\\\\'>%;<\\\\+\\x22\\x27/()]{2,}$)"); // regex that this string is not only 2 letters and don't start with a space
		  Matcher mt2=pt2.matcher(surname); 
      b2=mt2.matches(); 
		}
		if (EmailMessage != "")
		{
		  Pattern pt3=Pattern.compile("(\\S+[^\\\\'>%;<\\\\+\\x22\\x27/()]{2,}$)"); // regex that this string is not only 2 letters and don't start with a space
		  Matcher mt3=pt3.matcher(EmailMessage); 
      b3=mt3.matches(); 
		}
        
		if (company != "")
		{
	  	Pattern pt3=Pattern.compile("(\\S+[^\\\\'>%;<\\\\+\\x22\\x27/()]{2,}$)"); // regex that this string is not only 2 letters and don't start with a space 
		  Matcher mt3=pt3.matcher(company); 
      b4=mt3.matches(); 
		}
	    if (email != "")
		{
		  Pattern pt=Pattern.compile("([_A-Za-z0-9-]+)(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})");  // regex about the email
		  Matcher mt=pt.matcher(email); 
      b5=mt.matches(); 
		}
		if (phone != "")  { 
		  Pattern pt=Pattern.compile("[^\\S][0-9\\s+]$"); // regex che mi controlla che questo campo è solo numerico
		  Matcher mt=pt.matcher(phone); 
      b6=mt.matches(); 
		}
		if (b1 == false || b2 == false || b3 == false || b5 == false || name == "" || surname == "" || email == "" || EmailMessage == "") // checking the field can be optimize probably
		{
		out.println("<p><strong>An error has occurred</strong></p><p>Please check the following mandatory fields.</p>");
			if (b1 == false)
				{
				out.println("<p><strong>Please enter a valid Name</strong></p>");
				}
			if (b2 == false)
				{
				out.println("<p><strong>Please enter a valid Surname name</strong></p>");
				}
			if (b5 == false)
				{
				out.println("<p><strong>Please enter a valid email address </strong></p>");
				}
			if (b4 == false) 
				{
				out.println("<p><strong>Please enter a valid company name</strong></p>");
				}	
			if (b3 == false) 
				{
				out.println("<p><strong>Please enter a valid Message</strong></p>");
				}
			if (b6 == false) 
				{
				out.println("<p><strong>Please enter a valid phone number</strong></p>");
				}	
			if (name == "") 
			{
			out.println("<p><strong>Please enter a Name</strong></p>");
			}
			if (surname == "" ) {
			out.println("<p><strong>Please enter a valid Surname</strong></p>");
			}
			if (EmailMessage =="")
			{
			out.println("<p><strong>Please write a message</strong></p>");
			}
			if (email == "") 
			{
			out.println("<p><strong>Please enter an email address</strong></p>");
			}	
			out.println("<p><a href='/'>Back to the homepage</a></p>");
		}else 
		{
		out.println("<p><strong>Thank you</strong></p><p>Your question has been submitted.<br/><a href='/'>Back to Home page</a></p>");
		to = general;
		msg.setSubject("insert your subject");
	  plainPart = "E-Mail: "+ email +"Name: "+ title + " " + name + " " + surname + "Company: "+ company +"Telephone: "+ phone +"Message: "+ EmailMessage;
		htmlPart = "<b>E-Mail:</b> "+ email + "<br />"
		+"<b>Name:</b> "+ title + " " + name + " " + surname +"<br />"
		+"<b>Company:</b> "+ company + "<br />"
		+"<b>Telephone:</b> "+ phone + "<br />"
		+"<p><b>Message: </b>"+  EmailMessage + "</p>";
		msg.setFrom(new InternetAddress(from));
		InternetAddress[] toAddress = {new InternetAddress(to)};
		msg.setRecipients(Message.RecipientType.TO, toAddress);
		InternetAddress[] bccAddress = {new InternetAddress(bccMail)};
		msg.setRecipients(Message.RecipientType.BCC, bccAddress);
		msg.setSentDate(new Date());
		Multipart mp = new MimeMultipart("alternative"); // Enabled HTML and TEXT format
		MimeBodyPart text = new MimeBodyPart();
		MimeBodyPart html = new MimeBodyPart();
		text.setText(plainPart);
		html.setContent(htmlPart, "text/html");
		mp.addBodyPart(text); // TEXT ADDED			
		mp.addBodyPart(html); // HTML ADDED
		msg.setContent(mp);
		Transport.send(msg);		
		}
		}
%>

