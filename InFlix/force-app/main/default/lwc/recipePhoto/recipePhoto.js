import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import RECIPE_PHOTO_FIELD from '@salesforce/schema/Recipe__c.Photo__c';

export default class RecipePhoto extends LightningElement {
    @api recordId;
    recipePhotoUrl;

    @wire(getRecord, { recordId: "$recordId", fields: [RECIPE_PHOTO_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            console.log(data)
            this.recipePhotoUrl = data.fields.Photo__c.value;
        } else if (error) {
            console.error(error);
        }
    }
}