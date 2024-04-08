/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 03/04/2024
 * @description This class is responsible for sending email notifications about new movies.
 */
public class NewMoviesEmailSender{
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method handles logic after insertion of Movie__c records.
     * 
     * @param inNewMovies List of Movie__c objects to be inserted.
     */
    public static void handleAfterInsert(List<Movie__c> inNewMovies) {
        if(inNewMovies == null){
            return;
        }
        List<Id> newMoviesIds = getMoviesIds(inNewMovies);
        sendEmail(newMoviesIds);
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method sends email notifications about new movies to the specified 
     * recipients.
     * 
     * @param inNewMoviesIds List of Ids of Movie__c objects to be inserted.
     */
    @future
    public static void sendEmail (List<Id> inNewMoviesIds) {
        Set<String> emailAddresses = new Set<String>();
        
        for(User user : [SELECT Email FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE Name = 'InFlix Admin')]) {
            emailAddresses.add(user.Email);
        }

        if (inNewMoviesIds.size() > 0) {
            List<Movie__c> newMovies = [SELECT Id, Name, Genres__c, Director__c, Trailer__c
            FROM Movie__c WHERE Id IN :inNewMoviesIds];
           
            if(!newMovies.isEmpty()){                 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('New movies have been added');
 
                String emailBody = 'Welcome!<br/><br/>New movies have been added:<br/><br/>';
                for(Movie__c movie : newMovies){
                    emailBody += 'Id of new movie: ' + movie.Id + '<br/>';
                    emailBody += 'Title of new movie: ' + movie.Name + '<br/>';
                    emailBody += 'Genres of new movie: ' + movie.Genres__c + '<br/>';
                    emailBody += 'Director of new movie: ' + movie.Director__c + '<br/>';
                    emailBody += 'Trailer for new movie: ' + movie.Trailer__c + '<br/><br/>';
                }

                emailBody += 'Have a nice day!';
 
                email.setHtmlBody(emailBody);
                email.setToAddresses(new List<String>(emailAddresses));
 
                try {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    System.debug('Email was sent successfully.');
                } catch (Exception e) {
                    System.debug('There was a problem with sending email: ' + e.getMessage());
                }
            }  
        }
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method retrieves the Ids of the newly inserted Movie__c records.
     * 
     * @param inNewMovies List of Movie__c objects to be inserted
     * @return List of IDs of newly inserted Movie__c records.
     */
    private static List<Id> getMoviesIds(List<Movie__c> inNewMovies){
        List<Id> newMoviesIds = new List<Id>();
        for(Movie__c newMovie : inNewMovies){
            newMoviesIds.add(newMovie.Id);
        }
        return newMoviesIds;
    }
}