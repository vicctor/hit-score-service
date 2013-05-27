<%-- 
    Document   : not-user-game
    Created on : 2011-07-24, 19:34:03
    Author     : artur
--%>

<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="pl.devservices.hitscoreservice.server.GamesRepository"%>
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
        <title>Hit Score Service - error</title>
    </head>
    <body>
        <div class="main-menu">
            <table>
                <tr>
                    <td><a href="show-games.jsp">My Games</a></td>
                    <td><a href="../index.jsp">Home</a></td>                    
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Sign out</a></td>
                </tr>            
            </table>
        </div>
        <div class="error-message">
            <p>
                User has no right for this game toke. 
            </p>
            <p>
                System unautorized access detected. 
            </p>
        </div>
    </body>
</html>
