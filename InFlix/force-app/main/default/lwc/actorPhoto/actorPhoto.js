import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ACTOR_PHOTO_FIELD from '@salesforce/schema/Actor__c.Picture__c';

export default class ActorPhoto extends LightningElement {
    //message channel np
    
    @api recordId;
    actorPhotoUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [ACTOR_PHOTO_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.actorPhotoUrl = data.fields.Picture__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}