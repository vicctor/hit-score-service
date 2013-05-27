package pl.devservices.hitscoreservice.server;

import com.google.appengine.api.mail.MailService;
import pl.devservices.server.exceptions.PlayerAlreadyExists;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import pl.devservices.server.exceptions.GameNotFoundException;
import pl.devservices.server.exceptions.CriticalServerError;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import javax.jdo.Extent;
import javax.jdo.JDOHelper;
import javax.jdo.JDOObjectNotFoundException;
import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.jdo.Query;
import pl.devservices.hitscoreservice.model.Game;
import pl.devservices.hitscoreservice.model.GameActivity;
import pl.devservices.hitscoreservice.model.GameHitScore;
import pl.devservices.hitscoreservice.model.Message;
import pl.devservices.hitscoreservice.model.Player;
import pl.devservices.hitscoreservice.model.PlayerScores;
import pl.devservices.hitscoreservice.model.User;

public class GamesRepository {

    static PersistenceManagerFactory pmfInstance = JDOHelper.getPersistenceManagerFactory("transactions-optional");

    public Collection<Game> getAll() {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            List<Game> games = new ArrayList<Game>();
            Extent<Game> extent = pm.getExtent(Game.class, false);
            for (Game game : extent) {
                games.add(game);
            }
            extent.closeAll();

            return games;
        } finally {
            pm.close();
        }
    }

    public void createGame(Game game) {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            pm.makePersistent(game);
            Date date = new Date();
            String base = date.hashCode() + game.getId();
            game.setToken(game.getId() + base.hashCode());
        } finally {
            pm.close();
        }
    }

    public void createUser(User user) {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            pm.makePersistent(user);
        } finally {
            pm.close();
        }
    }

    public void deleteById(Long id) {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            pm.deletePersistent(pm.getObjectById(Game.class, id));
        } finally {
            pm.close();
        }
    }

    public Player createNewPlayer(final String gameToken, final String playerName) throws CriticalServerError, GameNotFoundException, PlayerAlreadyExists {
        Player instance;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {

            Query query = pm.newQuery(Game.class);
            query.setFilter("token == gameToken");
            query.declareParameters("String gameToken");
            Collection<Game> games = (Collection<Game>) query.execute(gameToken);
            if (games.size() > 1) {
                throw new CriticalServerError("Game not unique!!!");
            }
            if (games.size() < 1) {
                throw new GameNotFoundException("Game identified by token " + gameToken + " not found");
            }

            Game game = games.iterator().next();

            Long currentPlayers = game.getPlayers();
            if (currentPlayers == null) {
                currentPlayers = 0L;
            } else {
                currentPlayers++;
            }
            game.setPlayers(currentPlayers);


            Date now = new Date();
            instance = new Player();
            System.out.println("+playername=" + playerName);
            if (playerName != null && playerName.trim().length() > 0) {
                final String playerKey = KeyFactory.createKeyString(Player.class.getSimpleName(), game.getToken() + playerName);
                try {
                    pm.getObjectById(Player.class, playerKey);
                    System.out.println("++");
                    throw new PlayerAlreadyExists();
                } catch (JDOObjectNotFoundException ex) {
                    System.out.println("--");
                    Logger.getAnonymousLogger().info("Creating new user, old one not found");
                }
                instance.setId(playerKey);
            }
            instance.setGameId(game.getId());
            instance.setPlayerName(playerName);
            instance.setCreateTime(now.getTime());
            pm.makePersistent(instance);
        } finally {
            pm.close();
        }
        return instance;
    }

    public Player getGameInstance(final String instanceId) {
        Player instance;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            instance = pm.getObjectById(Player.class, instanceId);
        } finally {
            pm.close();
        }
        return instance;
    }

    public Collection<Game> getUserGames(String email) {
        List<Game> rc = null;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Game.class);
            query.setFilter("ownerEmail == userEmail");
            query.declareParameters("String userEmail");


            Collection<Game> set = (Collection<Game>) query.execute(email);
            rc = new ArrayList<Game>();
            for (Game g : set) {
                rc.add(g);
            }

        } finally {
            pm.close();
        }
        return rc;
    }

    public void removeGame(String email, String id) {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Game.class);
            query.setFilter("ownerEmail == userEmail && id == gameId");
            query.declareParameters("String userEmail, String gameId");
            query.deletePersistentAll(email, id);
        } finally {
            pm.close();
        }
    }

    public void updateHitScore(String playerToken, int level, int score) {

        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Player player = pm.getObjectById(Player.class, playerToken);

            if (player != null) {
                Game game = pm.getObjectById(Game.class, player.getGameId());

                Key key = KeyFactory.createKey(PlayerScores.class.getSimpleName(), game.getId() + "@" + playerToken + ":" + level);

                PlayerScores hit;
                try {
                    hit = pm.getObjectById(PlayerScores.class, key);
                } catch (JDOObjectNotFoundException ex) {
                    hit = new PlayerScores();
                    hit.setId(key);
                    hit.setLevel(level);
                    hit.setLevelScore(score);
                    pm.makePersistent(hit);
                }

                if (hit.getLevelScore() < score) {
                    hit.setLevel(score);
                }

                Key gameHitKey = KeyFactory.createKey(GameHitScore.class.getSimpleName(), game.getId() + ":" + level);
                GameHitScore gameHit;
                try {
                    gameHit = pm.getObjectById(GameHitScore.class, gameHitKey);
                    if (gameHit.getLevelScore() < score) {
                        gameHit.setLevelScore(score);
                        gameHit.setPlayerName(player.getPlayerName());
                    }
                } catch (JDOObjectNotFoundException ex) {
                    gameHit = new GameHitScore();
                    gameHit.setId(gameHitKey);
                    gameHit.setGameToken(game.getToken());
                    gameHit.setLevel(level);
                    gameHit.setLevelScore(score);
                    gameHit.setPlayerName(player.getPlayerName());
                    pm.makePersistent(gameHit);
                }


                if (gameHit.getLevelHits() == null) {
                    gameHit.setLevelHits(0);
                }
                gameHit.setLevelHits(gameHit.getLevelHits() + 1);

                Long levelHits = game.getLevelHits();
                if (levelHits == null) {
                    levelHits = 0L;
                }
                levelHits++;
                game.setLevelHits(levelHits);

                Calendar midnight = Calendar.getInstance();
                midnight.set(Calendar.HOUR, 0);
                midnight.set(Calendar.MINUTE, 0);
                midnight.set(Calendar.SECOND, 0);
                midnight.set(Calendar.MILLISECOND, 0);
                long time = midnight.getTimeInMillis();
                Key gameActivityKey = KeyFactory.createKey(GameActivity.class.getSimpleName(), game.getId() + time);
                GameActivity activity;
                try {
                    activity = pm.getObjectById(GameActivity.class, gameActivityKey);
                    activity.setHits(activity.getHits() + 1);
                } catch (JDOObjectNotFoundException ex) {
                    activity = new GameActivity();
                    activity.setId(gameActivityKey);
                    activity.setHits(1);
                    activity.setGameToken(game.getId());
                    activity.setDate(time);
                    pm.makePersistent(activity);
                }
            }

        } finally {
            pm.close();
        }

    }

    public Collection<GameHitScore> getGameHitScores(String token) {
        List<GameHitScore> hitScores;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(GameHitScore.class);
            query.setFilter("gameToken == token");
            query.declareParameters("String token");
            hitScores = new ArrayList<GameHitScore>();
            for (GameHitScore hs : (Collection<GameHitScore>) query.execute(token)) {
                hitScores.add(hs);
            }
        } finally {
            pm.close();
        }
        return hitScores;
    }

    public Collection<GameActivity> getGameActivity(String token, Calendar since) {
        List<GameActivity> activites;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(GameActivity.class);
            query.setFilter("gameToken == token &&  date > sinceTime");
            query.declareParameters("String token, Long sinceTime");
            activites = new ArrayList<GameActivity>();
            for (GameActivity hs : (Collection<GameActivity>) query.execute(token, since.getTimeInMillis())) {
                activites.add(hs);
            }
        } finally {
            pm.close();
        }
        return activites;
    }

    public boolean isUserGame(final String gameId, final String userEmail) {
        boolean result = false;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Game.class);
            query.setFilter("id == gameToken && ownerEmail == userEmail");
            query.declareParameters("String token, String userEmail");
            result = ((Collection<Game>) query.execute(gameId, userEmail)).size() > 0;
        } finally {
            pm.close();
        }
        return result;
    }

    public Message createMessage(final String gameId, final String text) {
        Message message = null;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            message = new Message();
            message.setText(text);
            message.setGameId(gameId);
            message.setRequestsNumber(0L);
            message.setCreationTime(new Date());
            pm.makePersistent(message);
        } finally {
            pm.close();
        }
        return message;
    }

    public Collection<Message> getMessages(final String gameId, int limit) {
        Collection<Message> result = null;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Message.class);
            query.setFilter("gameId == idFilter");
            query.declareParameters("String idFilter");
            //query.setGrouping("id");
            query.setOrdering("creationTime desc");
            query.setRange(0, limit);
            Collection<Message> col = (Collection<Message>) query.execute(gameId);
            result = new ArrayList<Message>();
            for (Message m : col) {
                result.add(m);
            }
        } finally {
            pm.close();
        }
        return result;
    }

    public Message getMessageById(Long id) {
        Message message = null;
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Message.class);
            query.setFilter("id == idFilter");
            query.declareParameters("String idFilter");
            Collection<Message> col = (Collection<Message>) query.execute(id);
            if (col.size() > 0) {
                message = col.iterator().next();
            }
        } finally {
            pm.close();
        }
        return message;
    }

    public void removeMessage(long id) {
        PersistenceManager pm = pmfInstance.getPersistenceManager();
        try {
            Query query = pm.newQuery(Message.class);
            query.setFilter("id == idFilter");
            query.declareParameters("String idFilter");
            query.deletePersistentAll(id);            
        } finally {
            pm.close();
        }
    }
}
