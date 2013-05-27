/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.server.exceptions;

/**
 *
 * @author artur
 */
public class GameNotFoundException extends Exception {

    public GameNotFoundException(String string) {
        super(string);
    }
    
}
