<%-- 
    Document   : game-register.jsp
    Created on : 2011-07-20, 22:31:49
    Author     : artur
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="pl.devservices.hitscoreservice.server.GamesRepository"%>
<%@page import="pl.devservices.hitscoreservice.model.Game"%>

<%@page import="java.util.Collection"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
    GamesRepository repo = new GamesRepository();
    Collection<Game> games = repo.getUserGames(userService.getCurrentUser().getEmail());
    request.setAttribute("games", games);
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
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Sign out</a></td>
                </tr>            
            </table>
        </div>
        <table class="games-registry">
            <tr>
                <td>
                    <h2>Your registered games:</h2>
                    <table>
                        <thead>
                        <th>Game name</th>
                        <th>Players</th>
                        <th>Levels hits</th>
                        <th>API Token</th>
                        <th>Action</th>
                        </thead>
                        <c:forEach var="game" items="${games}">
                            <c:url var="removeUrl" value="remove-game">
                                <c:param name="id" value="${game.id}"/>
                            </c:url>
                            <c:url var="showStatsUrl" value="show-game-stats.jsp">
                                <c:param name="gameToken" value="${game.token}"/>
                                <c:param name="gameId" value="${game.id}"/>
                            </c:url>
                            <c:url var="messagesUrl" value="show-messages.jsp">
                                <c:param name="gameId" value="${game.id}"/>
                            </c:url>
                            <tr class="<%=tableTow++ % 2==0?"d0":"d1"%>">
                                <td><div><c:out value="${game.gameName}"/></div>        </td>
                                <td><div><c:out value="${game.players}"/></div>        </td>
                                <td><div><c:out value="${game.levelHits}"/></div>        </td>
                                <td><div><c:out value="${game.token}"/></div>        </td>
                                <td>
                                    <a href='<c:out value="${removeUrl}"/>' onclick="return confirm('Arey you sure? If you remove your game it will be not possoble to hadle this game scores any more!')")">Remove</a>
                                    <a href='<c:out value="${showStatsUrl}"/>'>Statistics</a>
                                    <a href='<c:out value="${messagesUrl}"/>'>Messages</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>

                    <h2>New Game registration</h2>
                    <form id="new-game-form" action="register-game" method="POST" onsubmit="return this.confirmation.checked">
                        <table>
                            <tr>
                                <td>Game name:</td>
                                <td><input name="gameName"</td>
                            </tr>
                            <tr>
                                <td>Game web-page</td>
                                <td><input name="webPage"</td>
                            </tr>            
                        </table>
                        <input id="submit" type="submit" value="Create" disabled="javascript:this.form.confirmation.checked"/>
                        <input id="confirmation" onchange="this.form.submit.disabled = !this.form.confirmation.checked" type="checkbox" value="false" />I read and understand Terms of Usage statement
                        <div class="warranty">
                        <h3>Terms of Usage</h3>                       
                        <h4>Warranty</h4>                        
                        <div>
                            THE SERVICE IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY. IT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SERVICE IS WITH YOU. SHOULD THE SERVICE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
                            IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW THE AUTHOR WILL BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.                             
                        </div>
                        <h4>Statement</h4>          
                        <div>I understand the Hit Score Service collects a data concerning my user's players. I agree to inform users of my games about collecting user experience information at the Hit Score Service.
I will not distribute information collected at Hit Score Service to anybody. My Google account used to register at Hit Score Service is used by me only and I will not share it with anybody.
                        </div>
                        </div>

                    </form>
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
