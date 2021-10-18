/*
 * Visualization.js
 *
 * This script is intended as a library that contains data and functions 
 * related to visualization and raster rendering.
 */
 
var layerStyles = [
  { 'class' : 9, 'type' : 'Water', 'color' : 'blue' },
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

exports.habitat = { min: 0, max: 3, palette: ['blue', 'yellow', 'orange', 'red'] };
exports.rainfall =  { min: 1091, max: 3112, palette: ['#ffffcc','#a1dab4','#41b6c4','#2c7fb8','#253494'] };
exports.trainingPalette = { min: 0, max: 8, palette: ['blue', 'darkgreen', 'green', 'darkseagreen', 'wheat', 'linen', 'brown', 'red', 'black'] };

exports.temperature = {
min: 19.1,  max: 36.1,
palette: [
  '040274', '040281', '0502a3', '0502b8', '0502ce', '0502e6',
  '0602ff', '235cb1', '307ef3', '269db1', '30c8e2', '32d3ef',
  '3be285', '3ff38f', '86e26f', '3ae237', 'b5e22e', 'd6e21f',
  'fff705', 'ffd611', 'ffb613', 'ff8b13', 'ff6e08', 'ff500d',
  'ff0000', 'de0101', 'c21301', 'a71001', '911003'
],
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
