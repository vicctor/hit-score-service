/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.hitscoreservice.model;

import com.google.appengine.api.datastore.Key;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

/**
 *
 * @author artur
 */
@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GameActivity {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Key id;
    
    private String gameToken;
    
    private long date;
    
    private int hits;

    public String getGameToken() {
        return gameToken;
    }

    public void setGameToken(String gameToken) {
        this.gameToken = gameToken;
    }    
    
    public long getDate() {
        return date;
    }

    public void setDate(long date) {
        this.date = date;
    }

    public int getHits() {
        return hits;
    }

    public void setHits(int hits) {
        this.hits = hits;
    }

    public Key getId() {
        return id;
    }

    public void setId(Key id) {
        this.id = id;
    }    
}
