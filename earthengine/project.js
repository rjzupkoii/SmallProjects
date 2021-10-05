/*
 * Project.js
 *
 * Main entry point for the GEOG883 term project. This script uses Landsat 8
 * imagery to generate malaria risk rasters based upon land classification
 * and ecological characteristics.
 */

// Import relevant scripts and data
var visual = require('users/rzupko/GEOG883:Imports/Visualization');
var features = require('users/rzupko/GEOG883:Imports/Features');

// Filter the USGS Landsat 8 Level 2, Collection 2, Tier 1collection to the selected image
var landsat = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filter(ee.Filter.and(
    ee.Filter.eq('WRS_PATH', 125),
    ee.Filter.eq('WRS_ROW', 50)))
  .filterDate('2020-01-21', '2020-01-23');
var image = landsat.first();

// Center the map and show the imagery
Map.centerObject(landsat, 8);
Map.addLayer(landsat, visual.landsatRGB, 'Landsat 8 (CIR, 5-4-3)');

// Load the training data
var polygons = features.getFeatures();
var bands = ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7'];

// Sample the input imagery
var training = image.select(bands).sampleRegions({
  collection: polygons,
  properties: ['class'],
  scale: 30
});

// Make a SVM classifier and train it
var classifier = ee.Classifier.libsvm().train({
  features: training,
  classProperty: 'class',
  inputProperties: bands
});

// Classify the Landsat image render it
var classified = image.select(bands).classify(classifier);
Map.addLayer(classified, visual.trainingPalette, 'Land Use Classification');

// Queue the Google Drive exports
Export.image.toDrive({
  image: classified,
  description: 'EE_Classified_LS8_Export',
  folder: 'Earth Engine',
  scale: 30,
  region: landsat.geometry()
});
Export.image.toDrive({
  image: image,
  description: 'EE_LS8_Export',
  folder: 'Earth Engine',
  scale: 30,
  region: landsat.geometry()
});