import { LightningElement, api, wire } from 'lwc';
import getRecipeDetails from "@salesforce/apex/RecipesController.getRecipeDetails";

export default class RecipeDetails extends LightningElement {
  @api recipeId;
  selectedRecipe;

  @wire(getRecipeDetails, { inRecipeId: "$recipeId"})
  wiredRecipe({ error, data }) {
    if (data) {
      console.log(data)
      this.selectedRecipe = data;
    } else if (error) {
      console.error(error);
    }
  }

  handleBackToRecipes() {
    const backToRecipesEvent = new CustomEvent("backtorecipes");
    this.dispatchEvent(backToRecipesEvent);
  }
}