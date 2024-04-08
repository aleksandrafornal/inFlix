/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 03/04/2024
 * @description This class is responsible for sending email notifications about new TV series.
 */
public class NewTVSeriesEmailSender {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method handles logic after insertion of TV_Series__c records.
     * 
     * @param inNewTVSeries List of TV_Series__c objects to be inserted.
     */
    public static void handleAfterInsert(List<TV_Series__c> inNewTVSeries) {
        if(inNewTVSeries == null){
            return;
        }
        List<Id> newTVSeriesIds = getTVSeriesIds(inNewTVSeries);
        sendEmail(newTVSeriesIds);
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 03/04/2024
     * @description The method sends email notifications about new movies to the specified 
     * recipients.
     * 
     * @param inNewTVSeriesIds List of Ids of Movie__c objects to be inserted.
     */
    @future
    public static void sendEmail (List<Id> inNewTVSeriesIds) {
        Set<String> emailAddresses = new Set<String>();
        
        for(User user : [SELECT Email FROM User WHERE UserRoleId IN (SELECT Id FROM UserRole WHERE Name = 'InFlix Admin')]) {
            emailAddresses.add(user.Email);
        }

        if (inNewTVSeriesIds.size() > 0) {
            List<TV_Series__c> newTVSeries = [SELECT Id, Name, Genres__c, Director__c, Trailer__c
            FROM TV_Series__c WHERE Id IN :inNewTVSeriesIds];
           
            if(!newTVSeries.isEmpty()){                 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('New TV series have been added');
 
                String emailBody = 'Welcome!<br/><br/>New TV series have been added:<br/><br/>';
                for(TV_Series__c tvSeries : newTVSeries){
                    emailBody += 'Id of new TV series: ' + tvSeries.Id + '<br/>';
                    emailBody += 'Title of new TV series: ' + tvSeries.Name + '<br/>';
                    emailBody += 'Genres of new TV series: ' + tvSeries.Genres__c + '<br/>';
                    emailBody += 'Director of new TV series: ' + tvSeries.Director__c + '<br/>';
                    emailBody += 'Trailer for new TV series: ' + tvSeries.Trailer__c + '<br/><br/>';
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
     * @description The method retrieves the Ids of the newly inserted TV_Series__c records.
     * 
     * @param inNewTVSeries List of TV_Series__c objects to be inserted
     * @return List of IDs of newly inserted TV_Series__c records.
     */
    private static List<Id> getTVSeriesIds(List<TV_Series__c> inNewTVSeries){
        List<Id> newTVSeriesIds = new List<Id>();
        for(TV_Series__c newTVSeries : inNewTVSeries){
            newTVSeriesIds.add(newTVSeries.Id);
        }
        return newTVSeriesIds;
    }
}