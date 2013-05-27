<%-- 
    Document   : newjsp
    Created on : 2011-07-21, 21:21:36
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
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="/style.css" rel="stylesheet" type="text/css" />

        <title>Hit Score Service</title>
    </head>
    <body>
        <!-- <h1>Hit Score Service</h1> -->
        <img src="images/logo.png"/>
        <div class="main-menu">
            <table class="main-menu">
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

        <table>
            <tr>
                <td>
                    <p>
                        If you are here then probably you are a mobile games developer. 
                        If you plan to share your game players hit score information, then this service is for you.
                    </p>

                    <p>
                    <h3>What is this?</h3>
                    Hit Score Service (HSS) is a free database of hit scores of your game players. 
                    By registering your account, we will give you a free and open space for all games 
                    you created or plan to develope. There are no royalties needed, let just use it.  
                    </p>
                    <h3>See your game usage</h3>
                    <p>
                        You can now easily measure your game players statistic by visiting game statistics page.
                    </p>
                    <p>
                        <img src="/images/game-usage.png"/>
                        <img src="/images/level-hits.png"/>
                    </p>
                    <h3>How to start?</h3>

                    <p>
                        Please visit our <a href="user-guide.jsp">User Guide</a> and learn how easy to create your game account
                    </p>

                    <p>After registered, pleas visit the <a href="api-manual.jsp">HSS API Manual</a> and learn how to 
                        add HSS support to your game
                    </p>
                    <p>
                    <h3>Privacy policy</h3>
                    In fact HSS does not store any fragile data except your e-mail address and players hit scores.
                    Even your e-mail address is used only in case if you register at least one game.
                    If you drop all your games from HSS registry, we forget everything about you. 
                    about you. 
                    </p>



                    <p>
                    <h3>Leave your comment</h3>
                    <p>
                        If you wish to contact me, feel free to twitt <a href="http://twitter.com/share" class="twitter-share-button" data-count="none" data-via="hiberneticus">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
                    </p>
                    <p>Or just post message here</p>
                    <!-- facebook comments -->
                    <div id="fb-root"></div><script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script><fb:comments href="http://hitscoreservice.appspot.com" num_posts="2" width="800" colorscheme="white"></fb:comments>
        </p>        
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
<tr>
    <td>                   
    </td>
</tr>
</table>
<p>
    <img src="http://code.google.com/appengine/images/appengine-silver-120x30.gif"
         alt="Powered by Google App Engine" />
</p>

</body>
</html>
