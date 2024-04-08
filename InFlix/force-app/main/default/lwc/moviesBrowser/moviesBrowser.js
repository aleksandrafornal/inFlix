import { LightningElement, wire } from 'lwc';
import getAllMovies from "@salesforce/apex/MovieController.getAllMovies";

export default class MoviesBrowser extends LightningElement {
  step = "movies";
  movies;
  selectedMovieId;

  @wire(getAllMovies)
  wiredMovies({ error, data }) {
    if (data) {
      this.movies = data.map((movie) => ({
        title: movie.Name,
        id: movie.Id,
        logo: movie.Poster__c
      }));
    } else if (error) {
      console.error(error);
    }
  }

  get stepEqualsMovies() {
    return this.step === "movies";
  }

  get stepEqualsMovieDetails() {
    return this.step === "movieDetails";
  }

  handleMovieSelection(event) {
    this.selectedMovieId = event.detail;
    this.step = "movieDetails";
  }

  handleBackToMovies() {
    this.step = "movies";
  }
}