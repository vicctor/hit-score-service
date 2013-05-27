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
public class GameHitScore {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Key id;
    
    private String gameToken;
    
    private String playerName;    
    
    private int level;
     
    private int levelScore;
    
    private Integer levelHits;

    public Key getId() {
        return id;
    }

    public void setId(Key id) {
        this.id = id;
    }

    public String getGameToken() {
        return gameToken;
    }

    public void setGameToken(String gameToken) {
        this.gameToken = gameToken;
    }
        
    
    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public int getLevelScore() {
        return levelScore;
    }

    public void setLevelScore(int levelScore) {
        this.levelScore = levelScore;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Integer getLevelHits() {
        return levelHits;
    }

    public void setLevelHits(Integer levelHits) {
        this.levelHits = levelHits;
    }
    
    
}
