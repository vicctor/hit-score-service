<%-- 
    Document   : game-register.jsp
    Created on : 2011-07-20, 22:31:49
    Author     : artur
--%>

<%@page import="pl.devservices.hitscoreservice.model.Message"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="pl.devservices.hitscoreservice.server.GamesRepository"%>
<%@page import="pl.devservices.hitscoreservice.model.Game"%>

<%@page import="java.util.Collection"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String gameId = request.getParameter("gameId");
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
    GamesRepository repo = new GamesRepository();
    Collection<Message> messages = repo.getMessages(gameId, 50);
    request.setAttribute("messages", messages);
    int tableTow = 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="/style.css" rel="stylesheet" type="text/css" />
        <title>Game registration</title>
    </head>
    <body>        
        <img src="/images/logo.png"/>
        <div class="main-menu">
            <table>
                <tr>
                    <td><a href="../index.jsp">Home</a></td>
                    <td> <a href="show-games.jsp">My games</a></td>
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Sign out</a></td>
                </tr>            
            </table>
        </div>
        <table class="games-registry">
            <tr>
                <td>
                    <h2>Post message</h2>
                    <form id="post-message-form" action="post-message" method="POST">
                        <table>
                            <tr>
                                <td>Message:</td>
                                <td><input name="text"/></td>
                            </tr>
                        </table>
                        <input name="gameId" type="hidden" value="<%=gameId%>"/>                    
                        <input id="submit" type="submit" value="Post"/>                    
                    </form>

                    <h2>Messages posted to game users:</h2>
                    <table>
                        <thead>
                        <th>ID</th>
                        <th>Created at</th>
                        <th>Message</th>
                        <th>Received</th>
                        <th>Action</th>
                        </thead>
                        <c:forEach var="message" items="${messages}">
                            <c:url var="removeUrl" value="remove-message">
                                <c:param name="id" value="${message.id}"/>
                                <c:param name="gameId" value="<%=gameId%>"/>
                            </c:url>
                            <tr class="<%=tableTow++ % 2 == 0 ? "d0" : "d1"%>">
                                <td><div><c:out value="${message.id}"/></div>        </td>
                                <td><div><c:out value="${message.creationTime}"/></div>        </td>
                                <td><div><c:out value="${message.text}"/></div>        </td>
                                <td><div><c:out value="${message.requestsNumber}"/></div>        </td>
                                <td>
                                    <a href='<c:out value="${removeUrl}"/>' onclick="return confirm('Arey you sure?')">Remove</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>

                </td>
                <td>
                    <!-- Google addsense -->
                    <script type="text/javascript"><!--
                        google_ad_client = "ca-pub-8004213872715692";
                        /* hitscoreservice */
                        google_ad_slot = "8698182040";
                        google_ad_width = 160;
                        google_ad_height = 600;
                        //-->
                    </script>
                    <script type="text/javascript"
                            src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
                    </script>
                    <!-- End of Google Add-sense -->
                </td>
            </tr>
        </table>

    </body>
</html>
