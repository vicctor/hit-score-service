/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.hitscoreservice.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pl.devservices.hitscoreservice.model.Player;
import pl.devservices.hitscoreservice.server.GamesRepository;
import pl.devservices.server.exceptions.PlayerAlreadyExists;

/**
 *
 * @author artur
 */
public class RegisterPlayerServlet extends HttpServlet {


    /** Method called by the client
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            GamesRepository repo = new GamesRepository();
            final String gameToken = request.getParameter("gameToken");
            final String playerName = request.getParameter("playerName");
            Player instance = repo.createNewPlayer(gameToken,playerName);
            out.print(instance.getId());
        } catch (PlayerAlreadyExists ex) {
            out.println("ERROR: player already exists");
            response.sendError(406, "Player already exists");
        } catch (Exception ex) {
            Logger.getLogger(RegisterPlayerServlet.class.getName()).log(Level.SEVERE, null, ex);            
            throw new ServletException(ex);
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
