<%-- 
    Document   : user-guide.jsp
    Created on : 2011-07-22, 22:26:40
    Author     : artur
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="/style.css" rel="stylesheet" type="text/css" />
        <title>JSP Page</title>
    </head>
    <body>
        <img src="images/logo.png"/>
        <div class="main-menu">
            <table>
                <tr>

                <c:if test="${loggedIn}">
                    <td> <a href="profile/show-games.jsp">My games</a></td>
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Logout</a></td>
                </c:if>
                <c:if test="${not(loggedIn)}">
                    <td><a href="<%= userService.createLoginURL(thisURL)%>">Sign in</a></td>
                </c:if>
                </tr>
            </table>
        </div>
        <h3>Registration</h3>
        <p>In order to start working with Hit Score Service you have to create your Google account.             
            Please click this link to sing-in or create you google eccount:
            <a href="<%= userService.createLoginURL(thisURL)%>">Sign in</a></p>
        <h3>Add game</h3>
        <p>After you registered you will be alowed to create your game entry. To to this, just enter
            the game name and optionaly some advertisement web page in <a href="profile/show-games.jsp">game registration form</a>
            After registering you will receive a Game Token, which is required to identify your game in the storage. 
        </p>
    </body>
</html>
