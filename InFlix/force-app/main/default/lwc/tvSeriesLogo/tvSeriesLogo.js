import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import TV_SERIES_LOGO_FIELD from '@salesforce/schema/TV_Series__c.Logo__c';

export default class TvSeriesLogo extends LightningElement {
    @api recordId;
    tvSeriesLogoUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [TV_SERIES_LOGO_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.tvSeriesLogoUrl = data.fields.Logo__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}