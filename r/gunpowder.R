#!/usr/local/bin/rscript

OUTPUT_DIR <- 'results'

analysis <- function() {
	
	range <- seq(0, 100, by = 0.1)
	ndx <- 0
	results <- matrix(, nrow=length(range) * 3, ncol=4)
		
	# Find the relevent mass percentages
	for (kno3 in range) {
		for (c7h4o in range) {
			for (s in range) {
				results[ndx, ] <- c(kno3, c7h4o, s, calculate(kno3, c7h4o, s))
				ndx <- ndx + 1
			}
		}
	}
}

calculate <- function(kno3, c7h4o, s) {
	if (kno3 + c7h4o + s != 100) {
		return(0)	
	}
	
	# TODO Update this with the relevent calculations
	return(1)
}

dir.create(OUTPUT_DIR, showWarnings = FALSE)
analysis()