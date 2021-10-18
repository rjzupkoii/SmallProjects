/*
 * Processing.js
 *
 * This script is intended as a library that contains the functions 
 * needed to perform the actual processing for the imagery.
 */
var features = require('users/rzupko/GEOG883:Imports/Features');

exports.process = function(image) {
  // Note the aoi
  var aoi = image.geometry();
  
  // Load the data needed for classification
  var results = annualRainfall(aoi).rename('annual_rainfall');
  results = results.addBands(meanTemperature(aoi).rename('mean_temperature'));
  results = results.addBands(temperatureBounds(aoi, 11, 28).rename('temperature_bounds')); // Bounds: 11 C <= temperature <= 28 C
  results = results.addBands(classifyLandcover(image).rename('landcover'));
  
  // Perform the habitat classification
  var habitat = habitatClassification({
    aoi: aoi,
    rainfall: results.select('annual_rainfall'),
    temperature: results.select('mean_temperature'),
    bounds: results.select('temperature_bounds'),
    annualRainfall: 1500,
    minimumMeanTemperature: 20
  });
  results = results.addBands(habitat.rename('habitat'));
  
  // Perform the final risk assessment
  var risk = riskAssessment(results.select('landcover'), habitat);
  return results.addBands(risk.rename('risk'));  
};

// Get the mean monthly rainfall from the CHIPS dataset for 2019
function annualRainfall(aoi) {
  var collection = ee.ImageCollection('UCSB-CHG/CHIRPS/PENTAD')
    .filterDate('2019-01-01', '2019-12-31');
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  return collection.reduce(ee.Reducer.sum());
}

// Classify the landcover for the image provided
function classifyLandcover(image) {
  // Load the training data
  var landsat = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
    .filter(ee.Filter.and(
      ee.Filter.eq('WRS_PATH', 125),
      ee.Filter.eq('WRS_ROW', 50)))
    .filterDate('2020-01-21', '2020-01-23');
  var labeled = landsat.first();
  var polygons = features.getFeatures();
  var bands = ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7'];
  
  // Sample the input imagery
  var training = labeled.select(bands).sampleRegions({
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
}

function habitatClassification(inputs) {
  // Setup the variables for the envelopes
  var variables = {
    rainfall: inputs.rainfall, 
    minRainfall: inputs.annualRainfall, 
    temperature: inputs.temperature, 
    minTemp: inputs.minimumMeanTemperature,
    bounds: inputs.bounds};
  
  // Primary habitat is completely within the enviornmetnal envelope
  var primary = ee.Image(0).expression('(rainfall > minRainfall) && (temperature >= minTemp) && (bounds == 0)', variables);
    
  // Secondary is within the envelope for the life expectancy of an active female (43 days)
  var secondary = ee.Image(0).expression('(rainfall > minRainfall) && (temperature >= minTemp) && (bounds < 43)', variables);
    
  // Tertiary is within the envelope for the dormant life expectancy of a female (180 days)
  var tertiary = ee.Image(0).expression('(rainfall > minRainfall) && (temperature >= minTemp) && (bounds < 180)', variables);
  
  // Merge the classifications and return
  var habitat = ee.Image(0).expression('primary + secondary + tertiary', {primary: primary, secondary: secondary, tertiary: tertiary});
  habitat = habitat.rename('Habitat_Classification');
  return habitat.clip(inputs.aoi);
}

// Get the mean temperature from the MOD11A1.006 dataset for 2019
function meanTemperature(aoi) {
  var collection = ee.ImageCollection('MODIS/006/MOD11A1')
    .filterDate('2019-01-01', '2019-12-31');
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  
  // Scaled value in K must be converted to C, result = DN * 0.02 - 273.15
  collection = collection.map(function(image){
    var kelvin = image.select('LST_Day_1km');
    var celsius = ee.Image(0).expression('kelvin * 0.02 - 273.15', {kelvin: kelvin});
    return image.addBands(celsius.rename('LST_Day_1km_celsius'));
  });
  collection = collection.select('LST_Day_1km_celsius');
  
  return collection.reduce(ee.Reducer.mean());
}

function riskAssessment(landcover, habitat) {
  // Generate the 5 km buffer based upon the landcover type
  var buffer = ee.Image(0).expression('landcover >= 20', {landcover: landcover});
  buffer = ee.Image(1).cumulativeCost({
    source: buffer, 
    maxDistance: 5000,
  }).lt(5000);
  var masked = habitat.updateMask(buffer);
  
  // High risk are areas where humans likely live along side mosquitos
  var high = ee.Image(0).expression('(landcover >= 20) && (habitat > 1)', {landcover: landcover, habitat: habitat});
  
  // Moderate risk is mosquito habitat with 5km of humans
  var moderate = ee.Image(0).expression('masked > 1 ? 1 : 0', {masked: masked});      
  
  // Low risk is mosquito habitat
  var low = ee.Image(0).expression('habitat > 1', {habitat: habitat});
  
  // Return categorized risk
  return ee.Image(0).expression('high + moderate + low', {high: high, moderate: moderate, low: low});  
}

// Count the number of days that the temperature is outside the provided bounds for the AOI
function temperatureBounds(aoi, minimum, maximum) {
  var collection = ee.ImageCollection('MODIS/006/MOD11A1')
    .filterDate('2019-01-01', '2019-12-31');
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  
  // Add a band with a count of the days outside of the bounds, minimum <= temp <= maximum
  collection = collection.map(function(image) {
    var kelvin = image.select('LST_Day_1km');
    var celsius = ee.Image(0).expression('kelvin * 0.02 - 273.15', {kelvin: kelvin});
    var count = ee.Image(0).expression('(celsius < 11) || (celsius > 28)', {celsius: celsius});
    return image.addBands(count.rename('Outside_Bounds'));
  });
  collection = collection.select('Outside_Bounds');
  
  // Shouldn't have to clip twice, but not doing so seems to result in zeros outside of the orginal AOI
  collection = collection.map(function(image) {
    return image.clip(aoi);
  });
  
  return collection.reduce(ee.Reducer.sum());  
}