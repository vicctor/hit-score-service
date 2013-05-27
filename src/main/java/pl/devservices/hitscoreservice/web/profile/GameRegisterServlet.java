/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.hitscoreservice.web.profile;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pl.devservices.hitscoreservice.model.Game;
import pl.devservices.hitscoreservice.server.GamesRepository;

/**
 *
 * @author artur
 */
public class GameRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            UserService userService = UserServiceFactory.getUserService();
            
            
            Game game = new Game();
            game.setGameName(req.getParameter("gameName"));
            game.setWebPage(req.getParameter("webPage"));
            game.setOwnerEmail(userService.getCurrentUser().getEmail());
            
            
            GamesRepository games = new GamesRepository();
            games.createGame(game);


            resp.sendRedirect("show-games.jsp");
        } catch (Exception ex) {
            resp.sendRedirect("server-error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("show-games.jsp");
    }
}
