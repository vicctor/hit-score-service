<%-- 
    Document   : game-register.jsp
    Created on : 2011-07-20, 22:31:49
    Author     : artur
--%>

<%@page import="pl.devservices.hitscoreservice.model.GameHitScore"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="pl.devservices.hitscoreservice.model.GameActivity"%>
<%@page import="java.util.Calendar"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="pl.devservices.hitscoreservice.server.GamesRepository"%>
<%@page import="pl.devservices.hitscoreservice.model.Game"%>

<%@page import="java.util.Collection"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String gameToken = request.getParameter("gameToken");
    String gameId = request.getParameter("gameId");
    String monthsString = request.getParameter("months");
    if (monthsString == null) {
        monthsString = "1";
    }
    int months = Integer.parseInt(monthsString);
    UserService userService = UserServiceFactory.getUserService();
    String thisURL = request.getRequestURI();
    GamesRepository repo = new GamesRepository();
    if (!repo.isUserGame(gameToken, userService.getCurrentUser().getEmail())) {
        response.sendRedirect("not-user-game.jsp");
    }
    Calendar since = Calendar.getInstance();
    since.add(Calendar.MONTH, -months);
    Collection<GameActivity> gameActivity = repo.getGameActivity(gameId, since);

    int size = gameActivity.size();
    Object rows[][];
    if (size > 0) {
        rows = new Object[size][2];
        int i = 0;
        for (GameActivity a : gameActivity) {
            Date d = new Date(a.getDate());
            rows[i][0] = new SimpleDateFormat("yyyy/MM/dd").format(d);
            rows[i][1] = a.getHits();
            i++;
        }
    } else {
        rows = new Object[4][2];
        Calendar d = Calendar.getInstance();
        d.add(Calendar.DAY_OF_MONTH, -3);
        for (int i = 0; i < 4; i++) {
            rows[i][0] = new SimpleDateFormat("yyyy/MM/dd").format(d.getTime());
            rows[i][1] = 0;
            d.add(Calendar.DAY_OF_MONTH, 1);
        }
    }
    String gameUsageRows = new Gson().toJson(rows);


    Collection<GameHitScore> gameHitScores = repo.getGameHitScores(gameToken);
    if (gameHitScores.size() > 0) {
        rows = new Object[gameHitScores.size()][2];
        int i = 0;
        for (GameHitScore hs : gameHitScores) {
            rows[i][0] = hs.getLevel();
            rows[i][1] = hs.getLevelHits();
            i++;
        }
    } else {
        rows = new Object[0][2];
    }
    String levelHits = new Gson().toJson(rows);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="/style.css" rel="stylesheet" type="text/css" />
        <title>Game registration</title>

        <!--Load the AJAX API-->
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
    
            // Load the Visualization API and the piechart package.
            google.load('visualization', '1.0', {'packages':['corechart']});
      
            // Set a callback to run when the Google Visualization API is loaded.
            google.setOnLoadCallback(drawChart);
      
            // Callback that creates and populates a data table, 
            // instantiates the pie chart, passes in the data and
            // draws it.
            function drawChart() {

                /* Display game hits chart*/
                {
                    // Create the data table.
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'Date');
                    data.addColumn('number', 'Hits');
                    data.addRows(<%=gameUsageRows%>);
                
                    var chart = new google.visualization.AreaChart(document.getElementById('game-statistics'));
                    chart.draw(data, {width: "100%", height: 240, title: 'Player hits',
                        hAxis: {title: 'Date', titleTextStyle: {color: '#000000'}}
                    });
                }
                
                /* Display levels hits chart*/
                {
                    // Create the data table.
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'Level');
                    data.addColumn('number', 'Hits');
                    var hits = <%=levelHits%>;
                   
                    if (hits.length>0) {
                        data.addRows(hits.length);
                        for (i=0; i<hits.length; i++)  {                    
                            data.setValue(i, 0, ""+hits[i][0]);
                            data.setValue(i, 1, hits[i][1]);
                        }
                    } else {
                        data.addRows(1);                        
                        data.setValue(0, 0, "0");
                        data.setValue(0, 1, 0);
                    }

                
                    var chart = new google.visualization.BarChart(document.getElementById('level-hits-statistig'));
                    chart.draw(data, {width: "100%", height: 240, title: 'Level Hits',
                        vAxis: {title: 'Level', titleTextStyle: {color: 'blue'}}
                    });

                }

            }
        </script>


    </head>
    <body>        
        <img src="/images/logo.png"/>
        <div class="main-menu">
            <table>
                <tr>
                    <td><a href="../index.jsp">Home</a></td>
                    <td><a href="show-games.jsp">My games</a></td>
                    <td><a href="<%=userService.createLogoutURL(thisURL)%>">Sign out</a></td>
                </tr>            
            </table>
        </div>
        <table class="games-registry">
            <tr>
                <td>
                    <h2>Game statistics:</h2>
                    <p>
                        On this page we located some statistics we collected about your game.
                    </p>
                    <h3>Game usage in time</h3>
                    <p>We count every user interaction with this service as a hit.
                        That measn that we cound if user started your game or reache new hit score.
                    </p>
                    <div>
                        <div id="game-statistics"  />                      
                    </div>
                        
                    <h3>Level hits</h3>
                    <p>We count how many users notified a new hit score of the given game level.
                    </p>
                    <div>
                        <div id="level-hits-statistig" />
                    </div>
                    
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
