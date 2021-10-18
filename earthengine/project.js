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
var landsat = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
  .filter(ee.Filter.and(
    ee.Filter.eq('WRS_PATH', 125),
    ee.Filter.eq('WRS_ROW', 50)))
  .filterDate('2020-01-21', '2020-01-23');
var image = landsat.first();
var aoi = image.geometry();

// Center the map and show the imagery
Map.centerObject(landsat, 8);
Map.addLayer(landsat, visual.landsatRGB, 'Landsat 8 (RGB, 4-3-2)');

// Load and display the annual rainfall
var annualRainfall = processing.annualRainfall(aoi);
Map.addLayer(annualRainfall, visual.rainfall, 'Annual Precipitation (mm)');

// Load and display the mean temperature
var meanTemperature = processing.meanTemperature(aoi);
Map.addLayer(meanTemperature, visual.temperature, 'Mean Land Surface Temperature (C)');

// Classify the Landsat image render it
var classified = processing.classifyLandcover(image);
Map.addLayer(classified, visual.trainingPalette, 'Land Use Classification');

function queueExports() {
  Export.image.toDrive({
    image: classified,
    description: 'EE_Classified_LS8_Export',
    folder: 'Earth Engine',
    region: landsat.geometry()
  });
  Export.image.toDrive({
    image: annualRainfall,
    description: 'EE_AnnualRainfall_CHIRPS_Export',
    folder: 'Earth Engine',
    region: annualRainfall.geometry()
  });
  Export.image.toDrive({
    image: meanTemperature,
    description: 'EE_MeanTemperature_MODIS_Export',
    folder: 'Earth Engine',
    region: meanTemperature.geometry()
  });
}