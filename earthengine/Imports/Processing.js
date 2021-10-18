/*
 * Processing.js
 *
 * This script is intended as a library that contains the functions 
 * needed to perform the actual processing for the imagery.
 */
var features = require('users/rzupko/GEOG883:Imports/Features');

// Classify the landcover for the image provided
exports.classifyLandcover = function(image) {
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
  
  // Classify and return the results
  return image.select(bands).classify(classifier);
};

// Get the annual rainfall from the CHIPS dataset for 2019
exports.annualRainfall = function(aoi) {
  var collection = ee.ImageCollection('UCSB-CHG/CHIRPS/PENTAD')
    .filterDate('2019-01-01', '2019-12-31');
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  return collection.reduce(ee.Reducer.sum());
};

// Get the mean temperature from the MOD11A1.006 dataset for 2019
exports.meanTemperature = function(aoi) {
  var collection = ee.ImageCollection('MODIS/006/MOD11A1')
    .filterDate('2019-01-01', '2019-12-31')
    .select('LST_Day_1km');
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  
  // Scaled value in K must be converted to C, result = DN * 0.02 - 273.15
  collection = collection.map(function(image){
    return image.multiply(0.02).subtract(273.15);
  });
  
  return collection.reduce(ee.Reducer.mean());
};