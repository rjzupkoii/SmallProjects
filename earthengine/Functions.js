/*
 * Functions.js
 *
 * Collection of useful functions for working wth Google Earth Engine.
 */

// Mosaic the supplied collection based upon the field specified.
//
// Inspired by https://gis.stackexchange.com/a/343453
exports.mosaicByDate = function(collection, field) {
    // Get the unqiue dates for the collection
    var dates = collection.toList(collection.size())
      .map(function(image) {
        return ee.Image(image).get(field);
      }).distinct();
  
    // Filter on the unique acquision dates and generate the mosaic
    var mosaic = dates.map(function(date) {
      return collection
        .filter(ee.Filter.eq(field, date))
        .mosaic()
        .set(field, date);
    });
    
    // Return mosaiced image collection
    return ee.ImageCollection(mosaic);
}