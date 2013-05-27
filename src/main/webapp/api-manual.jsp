<%-- 
    Document   : api-manual
    Created on : 2011-07-22, 22:17:39
    Author     : artur
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
    request.setAttribute("loggedIn", userService.isUserLoggedIn());
    String home = "https://hitscoreservice.appspot.com";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="/style.css" rel="stylesheet" type="text/css" />
        <title>Hit Score Service - API Manual</title>
    </head>
    <body>
        <img src="images/logo.png"/>
        <div class="main-menu">
            <table class="main-menu">
                <tr>
                    <c:if test="${loggedIn}">
                        <td> <a href="profile/show-games.jsp">My games</a></td>
                        <td><a href="<%=userService.createLogoutURL(thisURL)%>">Logout</a></td>
                    </c:if>
                    <c:if test="${not(loggedIn)}">
                        <td><a href="<%= userService.createLoginURL(thisURL)%>">Sign in</a>
                        </c:if>
                </tr>
            </table>
        </div>

        <h3>Use Game-site API</h3>
        The API is simple web-service based solution. Everythink you should do
        in your game is to call following methods:
        <h4>RegisterPlayer</h4>
        <p>In order to register a new player of your game just call methog RegisterPlayer:
        <p>
            <code><%=home%>/trusted/RegisterPlayer?gameToken=YOUR_GAME_TOKEN&playerName=PLAYERNAME</code>
        </p>

        This method returns single string containing player token e.g
        <code>kjhfsjkdhfksk873skdh</code>
        The playerName parameter is optional. If provided your user will be registered using unique name.
        If given user is already regisered as a player of this game, method finishes with HTTP error code 406.

    </p>

    <h4>NewHitScore</h4>
    <p>Whenever your player reached a new hit-score of game level:
    <p>
        <code><%=home%>/trusted/NewHitScore?playerToken=PLAYER_TOKEN&level=GAME_LEVEL_ID&score=SCORE</code>
    </p>            
    You should just receive HTTP success on this request.
</p>

<h4>GetHitScore</h4>
<p>In order to check out global hit score of the game levels, just call the method:
<pre><%=home%>/trusted/GetHitScore?gameToken=YOUR_GAME_TOKEN</pre>

This method returns hit scores as a list of lines where each line has a syntax:
<code>HIT::=&lt;LEVEL&gt;:&lt;SCORE&gt;&lt;:PLAYERNAME&gt;</code>
</p>

<h3>Game API limitations</h3>
<p>Hit Score API has some limits. First of all we support up to 256 game levels. 
    Levels are enumerated from 0 to 255</p>
</body>
</html>
