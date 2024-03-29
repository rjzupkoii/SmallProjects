/*
 * Project.js
 *
 * Main entry point for the GEOG883 term project. This script uses Landsat 8
 * imagery to generate malaria risk rasters based upon land classification
 * and ecological characteristics.
 */

// Import relevant scripts and data
var visual = require('users/rzupko/GEOG883:Imports/Visualization');
var processing = require('users/rzupko/GEOG883:Imports/Processing');

// Filter the USGS Landsat 8 Level 2, Collection 2, Tier 1 collection to the 
// selected image for the proof of concept (125, 50, 2020-01-22); an 
// alternative cloud-free image is (125, 51, 2014-01-05)
var image = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filter(ee.Filter.and(
    ee.Filter.eq('WRS_PATH', 125),
    ee.Filter.eq('WRS_ROW', 50)))
  .filterDate('2020-01-21', '2020-01-23').first();
var results = processing.process(image);

// By adding the Landsat and malaria results to image collections we have a 
// hook for future projects to use additional images additional images can
// be appended to the collection via:
//
// landsat = landsat.merge(ee.ImageCollection.fromImages([image]));
// malaria = malaria.merge(ee.ImageCollection.fromImages([results]));
var landsat = ee.ImageCollection.fromImages([image]);
var malaria = ee.ImageCollection.fromImages([results]);

// Visualize and export the results of the proof of concept
visualize(landsat, malaria, false);
queueExports(results);

function queueExports(results) {
  // Land cover classification, this must be it's own image since it's 
  // classified data
  Export.image.toDrive({
    image: results.select('landcover'),
    description: 'EE_Classified_LS8_Export',
    folder: 'Earth Engine',
    scale: 30,
    region: results.geometry()
  });  

  // Inputs for the habitat classification, this could  be a single image but
  // for processing in ArcGIS it is a bit easier to have each band as an image  
  Export.image.toDrive({
    image: results.select('annual_rainfall'),
    description: 'EE_AnnualRainfall_CHIRPS_Export',
    folder: 'Earth Engine',
    scale: 5566,
    region: results.geometry()
  });
  Export.image.toDrive({
    image: results.select('mean_temperature'),
    description: 'EE_MeanTemperature_MODIS_Export',
    folder: 'Earth Engine',
    scale: 1000,
    region: results.geometry()
  });
  Export.image.toDrive({
    image: results.select('temperature_bounds'),
    description: 'EE_TemperatureBounds_Export',
    folder: 'Earth Engine',
    scale: 1000,
    region: results.geometry()
  });  
  
  // Final malaria risk products
  Export.image.toDrive({
    image: results.select('habitat'),
    description: 'EE_Habitat_Export',
    folder: 'Earth Engine',
    scale: 30,
    region: results.geometry()
  }); 
  Export.image.toDrive({
    image: results.select('risk'),
    description: 'EE_Risk_Export',
    folder: 'Earth Engine',
    scale: 30,
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