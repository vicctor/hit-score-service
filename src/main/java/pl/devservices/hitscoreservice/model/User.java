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

/**Regisstry of games in the system
 *
 * @author artur
 */
@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class User {
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    @Extension(vendorName="datanucleus", key="gae.encoded-pk", value="true")
    private String id;
   
    private String webPage;
       
    private String ownerPasswordHash;

   
   

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    

    public String getOwnerPasswordHash() {
        return ownerPasswordHash;
    }

    public void setOwnerPasswordHash(String ownerPasswordHash) {
        this.ownerPasswordHash = ownerPasswordHash;
    }

    public String getWebPage() {
        return webPage;
    }

    public void setWebPage(String webPage) {
        this.webPage = webPage;
    }
       
}
