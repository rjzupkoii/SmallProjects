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
var processing = require('users/rzupko/GEOG883:Imports/Processing');

// Filter the USGS Landsat 8 Level 2, Collection 2, Tier 1collection to the selected image
var image = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filter(ee.Filter.and(
    ee.Filter.eq('WRS_PATH', 125),
    ee.Filter.eq('WRS_ROW', 50)))
  .filterDate('2020-01-21', '2020-01-23').first();
var results = processing.process(image);

var landsat = ee.ImageCollection.fromImages([image]);
var malaria = ee.ImageCollection.fromImages([results]);

image = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filter(ee.Filter.and(
    ee.Filter.eq('WRS_PATH', 125),
    ee.Filter.eq('WRS_ROW', 51)))
  .filterDate('2014-01-04', '2014-01-06').first();
results = processing.process(image);

landsat = landsat.merge(ee.ImageCollection.fromImages([image]));
malaria = malaria.merge(ee.ImageCollection.fromImages([results]));

visualize(landsat, malaria, false);
queueExports(landsat, results);

function queueExports(landsat, results) {
  // Landsat 8 imagery
  Export.image.toDrive({
    image: landsat,
    description: 'EE_LS8_Export',
    folder: 'Earth Engine',
    region: landsat.geometry()
  });    

  // Inputs for the habitat classification
  Export.image.toDrive({
    image: results.select('landcover'),
    description: 'EE_Classified_LS8_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  });  
  Export.image.toDrive({
    image: results.select('annual_rainfall'),
    description: 'EE_AnnualRainfall_CHIRPS_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  });
  Export.image.toDrive({
    image: results.select('mean_temperature'),
    description: 'EE_MeanTemperature_MODIS_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  });
  Export.image.toDrive({
    image: results.select('temperature_bounds'),
    description: 'EE_TemperatureBounds_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  });  
  
  // Final malaria risk products
  Export.image.toDrive({
    image: results.select('habitat'),
    description: 'EE_Habitat_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  }); 
  Export.image.toDrive({
    image: results.select('risk'),
    description: 'EE_Risk_Export',
    folder: 'Earth Engine',
    region: results.geometry()
  });   
}

function visualize(landsat, image, showInputs) {
  Map.centerObject(landsat, 8);
  Map.addLayer(landsat, visual.landsatRGB, 'Landsat 8 (RGB, 4-3-2)');
  Map.addLayer(image.select('habitat'), visual.habitat, 'Habitat (A. dirus)');
  Map.addLayer(image.select('risk'), visual.habitat, 'Malaria Risk');
  
  if (showInputs) {
    Map.addLayer(image.select('landcover'), visual.trainingPalette, 'Land Use Classification');    
    Map.addLayer(image.select('annual_rainfall'), visual.rainfall, 'Annual Precipitation (mm)');
    Map.addLayer(image.select('mean_temperature'), visual.temperature, 'Mean Land Surface Temperature (C)');
    Map.addLayer(image.select('temperature_bounds'), {min: 0, max: 366}, 'Days Outside of Temperature Bounds');
  }
}