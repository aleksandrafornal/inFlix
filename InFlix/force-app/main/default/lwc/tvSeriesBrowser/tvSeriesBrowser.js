import { LightningElement, wire } from 'lwc';
import getAllTVSeries from "@salesforce/apex/TVSeriesController.getAllTVSeries";
import getAllSeasonsBySeriesId from "@salesforce/apex/TVSeriesController.getAllSeasons";
import getAllEpisodesBySeasonId from "@salesforce/apex/TVSeriesController.getAllEpisodes";
import SeasonName from "@salesforce/label/c.Season_Name";
import SeasonNoOfEpisodes from "@salesforce/label/c.Season_Number_of_Episodes";
import EpisodeName from "@salesforce/label/c.Episode_Name";
import EpisodeLength from "@salesforce/label/c.Episode_Length";

export default class TvSeriesBrowser extends LightningElement {
  step = "tvSeries";
  tvSeries;
  seasons;
  episodes;
  selectedTVSeriesId;
  selectedSeasonId;
  selectedEpisodeId;

  seasonsColumns = [
    { label: SeasonName, fieldName: "name", type: "text" },
    { label: SeasonNoOfEpisodes, fieldName: "noOfEpisodes", type: "number" }
  ];

  episodesColumns = [
    { label: EpisodeName, fieldName: "name", type: "text" },
    { label: EpisodeLength, fieldName: "length", type: "number" }
  ];

  @wire(getAllTVSeries)
  wiredTVSeries({ error, data }) {
    if (data) {
      this.tvSeries = data.map((series) => ({
        title: series.Name,
        id: series.Id,
        logo: series.Logo__c
      }));
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getAllSeasonsBySeriesId, { inTVSeriesId: "$selectedTVSeriesId" })
  wiredSeasons({ error, data }) {
    if (data) {
      this.seasons = data.map((season) => ({
        name: season.Name,
        id: season.Id,
        noOfEpisodes: season.Number_of_episodes__c
      }));
    } else if (error) {
      console.error(error);
    }
  }

  @wire(getAllEpisodesBySeasonId, { inSeasonId: "$selectedSeasonId" })
  wiredEpisodes({ error, data }) {
    if (data) {
      this.episodes = data.map((episode) => ({
        name: episode.Name,
        id: episode.Id,
        length: episode.Length_min__c
      }));
    } else if (error) {
      console.error(error);
    }
  }

  get stepEqualsTVSeries() {
    return this.step === "tvSeries";
  }

  get stepEqualsSeasons() {
    return this.step === "seasons";
  }

  get stepEqualsEpisodes() {
    return this.step === "episodes";
  }

  get stepEqualsEpisodeDetails() {
    return this.step === "episodeDetails";
  }

  handleTVSeriesSelection(event) {
    this.selectedTVSeriesId = event.detail;
    this.step = "seasons";
  }

  handleSeasonSelection(event) {
    this.selectedSeasonId = event.detail?.selectedRows[0]?.id;
    this.step = "episodes";
  }

  handleEpisodeSelection(event) {
    this.selectedEpisodeId = event.detail?.selectedRows[0]?.id;
    this.step = "episodeDetails";
  }

  handleBackToTVSeries() {
    this.step = "tvSeries";
  }

  handleBackToSeasons() {
    this.step = "seasons";
  }

  handleBackToEpisodes() {
    this.step = "episodes";
  }
}