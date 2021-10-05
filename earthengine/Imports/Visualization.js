/*
 * Visualization.js
 *
 * This script is intended as a library that contains data and functions 
 * related to visualization and raster rendering.
 */
 
var layerStyles = [
    { 'class' : 0, 'type' : 'Water', 'color' : 'blue' },
    { 'class' : 1, 'type' : 'Forest', 'color' : 'darkgreen' },
    { 'class' : 2, 'type' : 'Vegetation', 'color' : 'green' },
    { 'class' : 3, 'type' : 'Vegetation / Scrub', 'color' : 'darkseagreen' },  
    { 'class' : 4, 'type' : 'Agricultural', 'color' : 'wheat' },
    { 'class' : 5, 'type' : 'Agricultural - Fallow', 'color' : 'linen' },
    { 'class' : 6, 'type' : 'Barren', 'color' : 'brown' },
    { 'class' : 7, 'type' : 'Development', 'color' : 'red' },
    { 'class' : 8, 'type' : 'Burned / Fire', 'color' : 'black' },
  ];
  
  exports.landsatRGB = { bands: ['SR_B4', 'SR_B3', 'SR_B2'], min: 6983, max: 13309 };
  exports.landsatCIR = { bands: ['SR_B5', 'SR_B4', 'SR_B3'], min: 8095, max: 19581 };
  
  exports.trainingPalette = { min: 0, max: 8,
    palette: ['blue', 'darkgreen', 'green', 'darkseagreen', 'wheat', 'linen', 'brown', 'red', 'black'],
  };
  
  /* Adds a layer to the map for each of the training data polygon categories defined. */
  exports.addTrainingPolygons = function(polygons) {
    layerStyles.forEach(function(item) {
      styleTraining(polygons, item.class, item.type, item.color);  
    });
  }
  
  function styleTraining(collection, value, label, color) {
    var items = collection.filter(ee.Filter.eq('class', value));
    items = items.style(color);
    Map.addLayer(items, {}, 'Training - ' + label);
  }
  