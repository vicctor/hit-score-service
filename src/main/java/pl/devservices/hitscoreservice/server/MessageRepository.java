
package pl.devservices.hitscoreservice.server;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.jdo.Extent;
import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;

import pl.devservices.hitscoreservice.model.Message;

public class MessageRepository {

	PersistenceManagerFactory pmfInstance = JDOHelper.getPersistenceManagerFactory("transactions-optional");

	
	public void create(Message message) {
		PersistenceManager pm = pmfInstance.getPersistenceManager();
		try {
		    pm.makePersistent(message);
		} finally {
			pm.close();
		}
	}

	public void deleteById(Long id) {
		PersistenceManager pm = pmfInstance.getPersistenceManager();
		try {
			pm.deletePersistent(pm.getObjectById(Message.class, id));
		} finally {
			pm.close();
		}
	}
}
