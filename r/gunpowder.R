#!/usr/local/bin/rscript

# Change in enthalpy of reaction in kJ
REACTION <- -2632.91

analysis <- function() {
	# Set up the parameters of the experiment
	range <- seq(0.0, 1.0, by = 0.05)
	ndx <- 0
	results <- matrix(, nrow=length(range) ^ 3, ncol=4)
		
	# Find the relevent mass percentages
	for (kno3 in range) {
		for (c7h4o in range) {
			for (s in range) {
				results[ndx, ] <- c(kno3, c7h4o, s, calculate(kno3, c7h4o, s))
				ndx <- ndx + 1
			}
		}
	}
	
	# Remove all of the NOPs
	results <- results[results[,4] != 0,]
	
	# Label the columes
	colnames(results) <- c('KNO3', 'C7H4O', 'S', 'Limiting Enthalpy')
	
	# Write the results
	write.csv(results, 'results.csv')
}

calculate <- function(kno3, c7h4o, s) {
	# Return if the sum is not 1
	if (kno3 + c7h4o + s != 1.0) {
		return(0)	
	}
		
	# Define our working matrix
	working <- matrix(1, nrow=3, ncol=3)
	colnames(working) <- c('mols', 'limiting', 'enthalpy')
	rownames(working) <- c('kno3', 'c7h4o', 's')
		
	# Find the mols of each
	working['kno3', 'mols'] <- kno3 / 101.1032
	working['c7h4o', 'mols'] <- c7h4o / 104.1061
	working['s', 'mols'] <- s / 32.065
	
	# Find the limiting reactant
	working['kno3', 'limiting'] <- working['kno3', 'mols'] / 6
	working['c7h4o', 'limiting'] <- working['c7h4o', 'mols']
	working['s', 'limiting'] <- working['s', 'mols'] / 2
	
	# Find the change in enthalpy per reactant
	working['kno3', 'enthalpy'] <- (REACTION / 6) * working['kno3', 'mols']
	working['c7h4o', 'enthalpy'] <- REACTION * working['c7h4o', 'mols']
	working['s', 'enthalpy'] <- (REACTION / 2) * working['s', 'mols']
	
	# Find the change of enthalphy for the limiting reactant
	limiting <- which.min(working[,'limiting'])
	enthalpy <- working[limiting, 'enthalpy']
	return(enthalpy)		
}

analysis()