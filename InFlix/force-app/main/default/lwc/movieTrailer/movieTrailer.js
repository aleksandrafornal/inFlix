import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import MOVIE_TRAILER_FIELD from '@salesforce/schema/Movie__c.Trailer__c';

export default class MovieTrailer extends LightningElement {
    @api recordId;
    movieTrailerUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [MOVIE_TRAILER_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.movieTrailerUrl = data.fields.Trailer__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}