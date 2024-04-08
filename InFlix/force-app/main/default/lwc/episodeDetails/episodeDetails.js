import { LightningElement, api, wire } from 'lwc';
import getEpisodeDetails from "@salesforce/apex/TVSeriesController.getEpisodeDetails";

export default class EpisodeDetails extends LightningElement {
  @api episodeId;
  selectedEpisode;
  showSuccessMessage = false;
  showErrorMessage = false;

  @wire(getEpisodeDetails, { inEpisodeId: "$episodeId" })
  wiredEpisode({ error, data }) {
    if (data) {
      console.log(data)
      this.selectedEpisode = data;
    } else if (error) {
      console.error(error);
    }
  }

  handleBackToEpisodes() {
    const backToEpisodesEvent = new CustomEvent("backtoepisodes");
    this.dispatchEvent(backToEpisodesEvent);
  }

  handleSuccess() {
    this.showSuccessMessage = true;
  }

  handleError() {
    this.showErrorMessage = true;
  }

  get combinedTitle() {
    if (this.selectedEpisode) {
        if (this.selectedEpisode.Title__c){
            return `${this.selectedEpisode.Name} ${this.selectedEpisode.Title__c}`;
        }
        return `${this.selectedEpisode.Name}`;
    }
    return '';
  }
}