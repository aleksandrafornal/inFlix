import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import MOVIE_POSTER_FIELD from '@salesforce/schema/Movie__c.Poster__c';

export default class MoviePoster extends LightningElement {
    @api recordId;
    moviePosterUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [MOVIE_POSTER_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.moviePosterUrl = data.fields.Poster__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}