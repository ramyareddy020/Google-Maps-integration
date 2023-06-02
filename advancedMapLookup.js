import { LightningElement, track, api } from "lwc";
import placeSearch from "@salesforce/apex/AddressSearchController.placeSearch";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import calculateDirections from '@salesforce/apex/GoogleMapsDirectionsController.calculateDirections';

export default class AdvancedMapLookup extends LightningElement {
  @track errors = [];
  @track originAddress = '';
  @track destinationAddress = '';
  @track searchResults = [];

  directions = {};

  @api notifyViaAlerts = false;
  handleOriginChange(event) {
    this.originAddress = event.target.value;
    
}
handleDestinationChange(event) {
  this.destinationAddress = event.target.value;
}

  handleSearch(event) {
    let searchKey = event.detail.searchTerm;
    console.log("#####" + JSON.stringify(event.detail.searchTerm));
    placeSearch({ searchPhrase: searchKey })
      .then(results => {
        const lookupComponents = this.template.querySelectorAll("c-lookup");
    lookupComponents.forEach(component => {
      component.setSearchResults(results);
    });
      })
      .catch(error => {
        this.notifyUser(
          "Lookup Error",
          "An error occured while searching with the lookup field.",
          "error"
        );
        // eslint-disable-next-line no-console
        console.error("Lookup error", JSON.stringify(error));
        this.errors = [error];
      });
  }
  

  notifyUser(title, message, variant) {
    if (this.notifyViaAlerts) {
      // eslint-disable-next-line no-alert
      alert(`${title}\n${message}`);
    } else {
      const toastEvent = new ShowToastEvent({ title, message, variant });
      this.dispatchEvent(toastEvent);
    }
  }
  
  handleSelectionChange(event) {
    this.errors = [];
    const fieldName = event.target.label;
    const selectedValue = event.target[event.target.selectedIndex].value;
    if (fieldName === 'Origin Address') {
      this.originAddress = selectedValue;
    } else if (fieldName === 'Destination Address') {
      this.destinationAddress = selectedValue;
    }
  }

  checkForErrors() {
    const lookupComponents = this.template.querySelectorAll("c-lookup");
    let hasSelection = false;
  
    lookupComponents.forEach(component => {
      const selection = component.getSelection();
      if (selection.length > 0) {
        hasSelection = true;
      }
    });
  
    if (!hasSelection) {
      this.errors = [
        { message: "You must make a selection before submitting!" },
        { message: "Please make a selection and try again." }
      ];
    } else {
      this.errors = [];
    }
  }

    
showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(event);
}

  handleSubmit() {
   
    this.checkForErrors();
    if (this.errors.length === 0) {
      if (this.originAddress && this.destinationAddress) {
        calculateDirections({ originAddress: this.originAddress, destinationAddress: this.destinationAddress })
            .then(result => {
                this.directions = result;
          
               this.showToast('Success', 'Directions calculated successfully', 'success');
            })
            .catch(error => {
                this.showToast('Error', 'Failed to calculate directions', 'error');
            });
    } else {
        this.showToast('Error', 'Please enter both origin and destination addresses', 'error');
    }
    }
  }
}