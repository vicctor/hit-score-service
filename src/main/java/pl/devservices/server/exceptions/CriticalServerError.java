/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.server.exceptions;

/**
 *
 * @author artur
 */
public class CriticalServerError extends Exception {

    public CriticalServerError(String string) {
        super(string);
    }
    
}
