/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.devservices.hitscoreservice.model;

import javax.jdo.annotations.Extension;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

/**Identitty of the single game instance
 *
 * @author artur
 */
@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class Player {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    @Extension(vendorName="datanucleus", key="gae.encoded-pk", value="true")
    private String id;
    
    private String gameId;
    
    private String playerName;

    private Long createTime;
    
    private Long lastUsageTime;
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }    
    
    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Long createTime) {
        this.createTime = createTime;
    }

    public Long getLastUsageTime() {
        return lastUsageTime;
    }

    public void setLastUsageTime(Long lastUsageTime) {
        this.lastUsageTime = lastUsageTime;
    }
}
