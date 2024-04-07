import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import TV_SERIES_TRAILER_FIELD from '@salesforce/schema/TV_Series__c.Trailer__c';

export default class TvSeriesTrailer extends LightningElement {
    @api recordId;
    tvSeriesTrailerUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [TV_SERIES_TRAILER_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.tvSeriesTrailerUrl = data.fields.Trailer__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}