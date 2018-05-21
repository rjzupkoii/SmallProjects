#!/usr/local/bin/rscript

# WARNING This will run slow if you use values < 0.01

suppressPackageStartupMessages(library('ggtern'))
library('reshape2')

# Change in enthalpy of reaction in kJ
REACTION <- -8397.47

analysis <- function() {
	# Set up the parameters of the experiment
	range <- seq(0.0, 1.0, by = 0.01)
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
	results <- head(results, -1)
		
	# Label the columes
	colnames(results) <- c('KNO3', 'C7H4O', 'S', 'Enthalpy')
		
	# Write the results and return it for plotting
	write.csv(results, 'results.csv', row.names = F)
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
	working['kno3', 'mols'] <- (kno3 * 100) / 101.1032
	working['c7h4o', 'mols'] <- (c7h4o * 100) / 104.1061
	working['s', 'mols'] <- (s * 100) / 32.065
	
	# Find the limiting reactant
	working['kno3', 'limiting'] <- working['kno3', 'mols'] / 74
	working['c7h4o', 'limiting'] <- working['c7h4o', 'mols'] / 16
	working['s', 'limiting'] <- working['s', 'mols'] / 30
	
	# Find the change in enthalpy per reactant
	working['kno3', 'enthalpy'] <- (REACTION / 74) * working['kno3', 'mols']
	working['c7h4o', 'enthalpy'] <- (REACTION / 16) * working['c7h4o', 'mols']
	working['s', 'enthalpy'] <- (REACTION / 30) * working['s', 'mols']
	
	# Find the change of enthalphy for the limiting reactant
	limiting <- which.min(working[,'limiting'])
	enthalpy <- working[limiting, 'enthalpy']
	return(enthalpy)		
}

plot <- function() {	
	df <- read.csv(file = "results.csv", header = T)
	points <- known()
	
	ggtern(df, aes(KNO3, C7H4O, S, value = Enthalpy), aes(x, y, z)) +
			geom_point(aes(fill = Enthalpy), size = 2, stroke = 0, shape = 21) + 
			scale_fill_gradient(low = "red",high = "yellow", guide = F) + 
			scale_color_gradient(low = "red",high = "yellow", guide = F) +
			
#			geom_point(data = points, color = "black", shape = 21) +
						
			theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
			theme_rgbw() + 
			theme_nogrid() +
			theme_legend_position('topleft') +
		
			guides(fill = guide_colorbar(order=1), alpha= guide_legend(order=2), color="none") + 			
		
			labs(title = "Theoretical Black Powder Performance", fill = "Limiting Enthalpy (kJ)",
				xarrow = "Percent Saltpeter",
				yarrow = "Percent Charcoal",
				zarrow = "Percent Sulfur")
	ggsave('plot.png')
}

known <- function() {
	# Gunpowder, blasting powder, sodium nitrate blasting powder, French war powder, Congreve rockets  
	KNO3 = c(0.75, 0.7, 0.4, 0.75, 0.624)
	C7H4O = c(0.15, 0.14, 0.3, 0.125, 0.232)
	S = c(0.10, 0.16, 0.3, 0.125, 0.144)
	Enthalpy = c(0.0)
	df = data.frame(KNO3, C7H4O, S, Enthalpy)
	return(df)
}

analysis()
#plot()