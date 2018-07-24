#!/usr/local/bin/rscript

# WARNING This will run slow if you use values < 0.01

suppressPackageStartupMessages(library('ggtern'))
library('reshape2')

# Change in enthalpy of reaction in kJ
REACTION <- -13167.55

analysis <- function() {
	# Set up the parameters of the experiment
	range <- seq(0.0, 1.0, by = 0.01)
	ndx <- 0
	data <- matrix(, nrow=length(range) ^ 3, ncol=5)
		
	# Find the relevent mass percentages
	for (kno3 in range) {
		for (c6h2o in range) {
			for (s in range) {
				results <- calculate(kno3, c6h2o, s)
				if (results[1] != 0) { 
					data[ndx, ] <- append(c(kno3, c6h2o, s), results)
					ndx <- ndx + 1
				}
			}
		}
	}
		
	# Remove all of the NOPs
	data <- data[rowSums(is.na(data)) == 0,] 
			
	# Label the columes
	colnames(data) <- c('KNO3', 'C6H2O', 'S', 'Limiting', 'Enthalpy')
	
	# Convert to a data frame and label the limiting reactant
	data <- as.data.frame(data)
	data$Reactant <- factor(data$Limiting, levels = c(1, 2, 3), labels = c("Saltpeter", "Charcoal", "Sulfur"))
	data$Limiting <- NULL
		
	# Write the results and return it for plotting
	write.csv(data, 'results.csv', row.names = F)
}

calculate <- function(kno3, c6h2o, s) {
	
	# Return if the sum is not 1, note the rounding to deal with floating points
	result <- round(kno3 + c6h2o + s, 10)
	if (result != 1.0) {
		return(c(0, 0))	
	}
		
	# Define our working matrix
	working <- matrix(1, nrow=3, ncol=3)
	colnames(working) <- c('mols', 'limiting', 'enthalpy')
	rownames(working) <- c('kno3', 'c6h2o', 's')
		
	# Find the mols of each
	working['kno3', 'mols'] <- (kno3 * 100) / 101.1032
	working['c6h2o', 'mols'] <- (c6h2o * 100) / 90.0794
	working['s', 'mols'] <- (s * 100) / 32.065
	
	# Find the limiting reactant
	working['kno3', 'limiting'] <- working['kno3', 'mols'] / 74
	working['c6h2o', 'limiting'] <- working['c6h2o', 'mols'] / 16
	working['s', 'limiting'] <- working['s', 'mols'] / 30
	
	# Find the change in enthalpy per reactant
	working['kno3', 'enthalpy'] <- (REACTION / 74) * working['kno3', 'mols']
	working['c6h2o', 'enthalpy'] <- (REACTION / 16) * working['c6h2o', 'mols']
	working['s', 'enthalpy'] <- (REACTION / 30) * working['s', 'mols']
	
	# Find the change of enthalphy for the limiting reactant
	limiting <- which.min(working[,'limiting'])
	enthalpy <- working[limiting, 'enthalpy']
	return(c(limiting, enthalpy))		
}

plot <- function() {	
	df <- read.csv(file = "results.csv", header = T)
	points <- known()
	
	# Plot the limiting enthalpy values
	plotEnthalpy(df, "red", "yellow", "enthalpy.png")
	plotEnthalpy(df, "gray0", "gray100", "enthalpy-grayscale.png")
	
	# Plot the constraining reacant
#	plotLimiting(df, "color", "limiting.png")
#	plotLimiting(df, "gray", "limiting-grayscale.png")
}

plotEnthalpy <- function(df, low, high, fileName) {
	ggtern(df, aes(KNO3, C6H2O, S, value = Enthalpy), aes(x, y, z)) +
			geom_point(aes(fill = Enthalpy), size = 2, stroke = 0, shape = 21) + 
			scale_fill_gradient(low = low, high = high, guide = F) + 
			scale_color_gradient(low = low, high = high, guide = F) +
			guides(fill = guide_colorbar(order=1), alpha= guide_legend(order=2), color="none") 			
	
	# Apply the theme color
	if (grepl("gray", low)) {
		last_plot() + theme_classic() + theme_showarrows()
	} else {
		last_plot() + theme_rgbw() 
	}

	last_plot() +
		theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
		theme_nogrid() +
		theme_legend_position('topleft') +
		labs(title = "Theoretical Black Powder Performance", fill = "Limiting Enthalpy (kJ)",
				xarrow = "Percent Saltpeter",
				yarrow = "Percent Charcoal",
				zarrow = "Percent Sulfur")
			
	ggsave(fileName)
}

plotLimiting <- function(df, color, fileName) {
	ggtern(df, aes(KNO3, C6H2O, S, value = Reactant), aes(x, y, z)) +
			geom_point(aes(fill = Reactant), size = 2, stroke = 0, shape = 21) +
			labs(title = "Theoretical Black Powder Performance", fill = "Limiting Reactant",
					xarrow = "Percent Saltpeter",
					yarrow = "Percent Charcoal",
					zarrow = "Percent Sulfur")
	
	# Apply the thme color
	if (grepl("gray", color)) {
		last_plot() +
				theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
				theme_bw() + 
				theme_nogrid() +
				theme_legend_position('topleft')				
	} else {
		last_plot() +
			theme(legend.justification = c(0, 1), legend.position = c(0, 1)) +
			theme_rgbw() + 
			theme_nogrid() +
			theme_legend_position('topleft')
	}
	
	ggsave(fileName)
}

known <- function() {
	# Gunpowder, blasting powder, sodium nitrate blasting powder, French war powder, Congreve rockets  
	KNO3 = c(0.75, 0.7, 0.4, 0.75, 0.624)
	C6H2O = c(0.15, 0.14, 0.3, 0.125, 0.232)
	S = c(0.10, 0.16, 0.3, 0.125, 0.144)
	Enthalpy = c(0.0)
	df = data.frame(KNO3, C6H2O, S, Enthalpy)
	return(df)
}

analysis()
plot()