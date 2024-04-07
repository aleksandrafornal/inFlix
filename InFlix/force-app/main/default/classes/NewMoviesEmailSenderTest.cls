/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the NewMoviesEmailSender.
 */
@isTest
public class NewMoviesEmailSenderTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that no email is send during insertion.
     */
    @isTest
    static void shouldNotSendAnyEmailWhenInsertedMoviesListIsNull() {
        Test.startTest();
        NewMoviesEmailSender.handleAfterInsert(null);
        Test.stopTest();
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(0, emailMessages.size(), 'No email should be sent');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that one email is send during insertion.
     */
    @isTest
    static void shouldSendOneEmailIfNewMoviesAreInserted() {
        List<Movie__c> newMovies = new List<Movie__c>();
        for (Integer i = 0; i < 5; i++) {
            newMovies.add(new Movie__c(Name = 'TestMovie' + i));
        }

        Test.startTest();
        insert newMovies;
        Test.stopTest();

        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(1, emailMessages.size(), 'One email message should be saved as an activity.');
    }
}