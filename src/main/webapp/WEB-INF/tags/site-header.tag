<%-- 
    Document   : site-header
    Created on : 2011-07-23, 14:44:51
    Author     : artur
--%>

<%@tag import="com.google.appengine.api.users.UserServiceFactory"%>
<%@tag import="com.google.appengine.api.users.UserService"%>
<%@tag description="put the tag description here" pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
    request.setAttribute("loggedIn", userService.isUserLoggedIn());
%>
<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="message"%>

<%-- any content can be specified here e.g.: --%>
<!-- <h1>Hit Score Service</h1> -->
        <img src="images/logo.png"/>
        <table class="manin-menu">
            <tr>

                <c:if test="${loggedIn}">
                    <td> <a href="profile/show-games.jsp">My games</a></td>
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Logout</a></td>
                </c:if>
                <c:if test="${not(loggedIn)}">
                    <td><a href="<%= userService.createLoginURL(thisURL)%>">Sign in</a></p></td>
                </c:if>
    </tr>
</table>