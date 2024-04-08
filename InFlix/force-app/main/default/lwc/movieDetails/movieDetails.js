import { LightningElement, api, wire } from 'lwc';
import getMovieDetails from "@salesforce/apex/MovieController.getMovieDetails";

export default class MovieDetails extends LightningElement {
  @api movieId;
  selectedMovie;
  toWatch;
  favorite;
  showSuccessMessage = false;
  showErrorMessage = false;

  @wire(getMovieDetails, { inMovieId: "$movieId"})
  wiredMovie({ error, data }) {
    if (data) {
      console.log(data)
      this.selectedMovie = data;
      this.toWatch = data.To_watch__c;
      this.favorite = data.Favorite__c;
    } else if (error) {
      console.error(error);
    }
  }

  handleBackToMovies() {
    const backToMoviesEvent = new CustomEvent("backtomovies");
    this.dispatchEvent(backToMoviesEvent);
  }

  saveToWatch() {
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  saveFavorite() {
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  handleSuccess() {
    this.showSuccessMessage = true;
  }

  handleError() {
    this.showErrorMessage = true;
  }
}