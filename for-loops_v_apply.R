#####################################################################################################
# This script will examine the computational speed of for loops vs. apply.
#
# Matt Grobis | Oct 2017
#####################################################################################################
# 1. Simple calculation: mean(x)

  # Before we start
  replicates <- 100                 # Higher numbers take longer but decrease noise
  n.rows <- seq(2, 1000, by = 10)   # The range in matrix sizes
  
  loop.times <- matrix(NA, nrow = replicates, ncol = length(n.rows))
  apply.times <- matrix(NA, nrow = replicates, ncol = length(n.rows))
  
  #-----------------------------------------------------------------------------------
  # Run the analysis
  for(i in 1:replicates){
    
    for(j in 1:length(n.rows)){
      
      # Create a matrix of random values that matches the dimensions we're testing
      data <- matrix(rnorm(1000 * n.rows[j]), ncol = 1000, nrow = n.rows[j])
      
      # Method 1: for loop
      start.time <- Sys.time()
      for(k in 1:ncol(data)){
        mean(data[, k])
      }
      
      loop.times[i, j] <- difftime(Sys.time(), start.time)
      
      # Method 2: apply
      start.time <- Sys.time()
      apply(data, 2, mean)
      apply.times[i, j] <- difftime(Sys.time(), start.time)
      
      print(paste0("Replicate ", i, "| iteration ", j))
    }
  }
  
  #-----------------------------------------------------------------------------------
  # Prepare for plotting
  size <- n.rows * 1000
  
  # Get the mean times and SE for loops versus apply
  m.loop <- apply(loop.times, 2, mean)
  se.loop <- apply(loop.times, 2, sd) / sqrt(replicates)
  
  m.apply <- apply(apply.times, 2, mean)
  se.apply <- apply(apply.times, 2, sd) / sqrt(replicates)
  
  # For 95% confidence intervals, we'll multiply the standard errors by 1.96
  conf.loop <- se.loop * 1.96
  conf.apply <- se.apply * 1.96
  
  # Create the error envelopes. Note that the x-coordinate is the same
  coord.x <- c(size, size[length(size)], rev(size))
  coord.y.loop <- c(m.loop + conf.loop, 
                    m.loop[length(m.loop)] - conf.loop[length(conf.loop)], 
                    rev(m.loop - conf.loop))
  
  coord.y.apply <- c(m.apply + conf.apply, 
                     m.apply[length(m.apply)] - conf.apply[length(conf.apply)], 
                     rev(m.apply - conf.apply))  
  
  #---------------------------------------------------------------------------------------
  # Plot it
  
  par(oma = c(0, 1, 0, 0))
  
  # 1st: plot the mean loop times
  plot(size, m.loop, type = 'l', ylim = c(min(m.loop - conf.loop), max(m.apply + conf.apply)),
       main = "Time required to find\nmean of each column of a matrix", las = 1,
       xlab = "Size of matrix (N cells)", ylab = NA, cex.axis = 1.2,
       cex.main = 1.6, cex.lab = 1.3, font.lab = 2, font.axis = 2)
  mtext(side = 2, font = 2, cex = 1.3, "Time (s)", outer = T, padj = 0.2)
  
  # Add the error envelope
  polygon(coord.x, coord.y.loop, col = "gray70", border = NA)
  lines(size, m.loop, lwd = 2)
  
  # Add the mean apply times
  lines(size, m.apply, col = "red", lwd = 2)
  polygon(coord.x, coord.y.apply, col = rgb(1, 0.1, 0.1, 0.3), border = NA)
   
  # Add the legend
  par(font = 2)
  legend("topleft", col = 1:2, pch = 19, cex = 1.1, c("For loop", "Apply"), bty = 'n')

######################################################################################################
######################################################################################################
# 2. Complicated calculation: mean(head(sort(x)))
  
  # Before we start
  replicates <- 50                 # Higher numbers take longer but decrease noise
  n.rows <- seq(2, 1000, by = 10)  # The range in matrix sizes
  
  loop.times <- matrix(NA, nrow = replicates, ncol = length(n.rows))
  apply.times <- matrix(NA, nrow = replicates, ncol = length(n.rows))
  
  #-----------------------------------------------------------------------------------
  # Run the analysis
  for(i in 1:replicates){
    
    for(j in 1:length(n.rows)){
      
      # Create a matrix of random values that matches the dimensions we're testing
      data <- matrix(rnorm(1000 * n.rows[j]), ncol = 1000, nrow = n.rows[j])
      
      # Method 1: for loop
      start.time <- Sys.time()
      for(k in 1:ncol(data)){
        mean(head(sort(data[, k])))
      }
      
      loop.times[i, j] <- difftime(Sys.time(), start.time)
      
      # Method 2: apply
      start.time <- Sys.time()
      apply(data, 2, function(x){mean(head(sort((x))))})
      apply.times[i, j] <- difftime(Sys.time(), start.time)
      
      print(paste0("Replicate ", i, "| iteration ", j))
    }
  }

  #-----------------------------------------------------------------------------------
  # Prepare for plotting
  size <- n.rows * 1000
  
  # Get the mean times and SE for loops versus apply
  m.loop <- apply(loop.times, 2, mean)
  se.loop <- apply(loop.times, 2, sd) / sqrt(replicates)
  
  m.apply <- apply(apply.times, 2, mean)
  se.apply <- apply(apply.times, 2, sd) / sqrt(replicates)
  
  # For 95% confidence intervals, we'll multiply the standard errors by 1.96
  conf.loop <- se.loop * 1.96
  conf.apply <- se.apply * 1.96
  
  # Create the error envelopes. Note that the x-coordinate is the same
  coord.x <- c(size, size[length(size)], rev(size))
  coord.y.loop <- c(m.loop + conf.loop, 
                    m.loop[length(m.loop)] - conf.loop[length(conf.loop)], 
                    rev(m.loop - conf.loop))
  
  coord.y.apply <- c(m.apply + conf.apply, 
                     m.apply[length(m.apply)] - conf.apply[length(conf.apply)], 
                     rev(m.apply - conf.apply))  
  
  #---------------------------------------------------------------------------------------
  # Plot it
  
  par(oma = c(0, 1, 0, 0))
  
  # 1st: plot the mean loop times
  plot(size, m.loop, type = 'l', ylim = c(min(m.loop - conf.loop), max(m.apply + conf.apply)),
       main = "Time required to find mean of 6 lowest values\n of each column of a matrix", las = 1,
       xlab = "Size of matrix (N cells)", ylab = NA, cex.axis = 1.2,
       cex.main = 1.6, cex.lab = 1.3, font.lab = 2, font.axis = 2)
  mtext(side = 2, font = 2, cex = 1.3, "Time (s)", outer = T, padj = 0.2)
  
  # Add the error envelope
  polygon(coord.x, coord.y.loop, col = "gray70", border = NA)
  lines(size, m.loop, lwd = 2)
  
  # Add the mean apply times
  lines(size, m.apply, col = "red", lwd = 2)
  polygon(coord.x, coord.y.apply, col = rgb(1, 0.1, 0.1, 0.3), border = NA)
  
  # Add the legend
  par(font = 2)
  legend("topleft", col = 1:2, pch = 19, cex = 1.1, c("For loop", "Apply"), bty = 'n')

########################################################################################################
########################################################################################################
# 3. Comparing mean(head(sort(x))) for small and big matrices
  
  # Before we start
  replicates <- 100                      # Higher numbers take longer but decrease noise
  
  n.rows_small <- seq(2, 200, by = 10)    # The range in matrix sizes
  n.rows_big <- seq(800, 1000, by = 10)   
  
  loop.times_small <- matrix(NA, nrow = replicates, ncol = length(n.rows_small))
  apply.times_small <- matrix(NA, nrow = replicates, ncol = length(n.rows_small))
  
  loop.times_big <- matrix(NA, nrow = replicates, ncol = length(n.rows_big))
  apply.times_big <- matrix(NA, nrow = replicates, ncol = length(n.rows_big))
  
  #-----------------------------------------------------------------------------------
  # Run the analysis
  for(i in 1:replicates){
    
    # Small matrices
    for(j in 1:length(n.rows_small)){
      
      # Create a matrix of random values that matches the dimensions we're testing
      data <- matrix(rnorm(1000 * n.rows_small[j]), ncol = 1000, nrow = n.rows_small[j])
      
      # Method 1: for loop
      start.time <- Sys.time()
      for(k in 1:ncol(data)){
        mean(head(sort(data[, k])))
      }
      
      loop.times_small[i, j] <- difftime(Sys.time(), start.time)
      
      # Method 2: apply
      start.time <- Sys.time()
      apply(data, 2, function(x){mean(head(sort((x))))})
      apply.times_small[i, j] <- difftime(Sys.time(), start.time)
      
    }
    
    #-------------------------------------------------------------------------------
    # Large matrices
    for(j in 1:length(n.rows_big)){
      
      # Create a matrix of random values that matches the dimensions we're testing
      data <- matrix(rnorm(1000 * n.rows_big[j]), ncol = 1000, nrow = n.rows_big[j])
      
      # Method 1: for loop
      start.time <- Sys.time()
      for(k in 1:ncol(data)){
        mean(head(sort(data[, k])))
      }
      
      loop.times_big[i, j] <- difftime(Sys.time(), start.time)
      
      # Method 2: apply
      start.time <- Sys.time()
      apply(data, 2, function(x){mean(head(sort((x))))})
      apply.times_big[i, j] <- difftime(Sys.time(), start.time)
      
      print(paste0("Replicate ", i, "| iteration ", j))
    }
    
  }
  
  #-----------------------------------------------------------------------------------
  # Prepare for plotting
  size_small <- n.rows_small * 1000
  size_big <- n.rows_big * 1000
  
  # Get the mean times and SE for loops versus apply
  m.loop_small <- apply(loop.times_small, 2, mean)
  se.loop_small <- apply(loop.times_small, 2, sd) / sqrt(replicates)
  
  m.loop_big <- apply(loop.times_big, 2, mean)
  se.loop_big <- apply(loop.times_big, 2, sd) / sqrt(replicates)
  
  m.apply_small <- apply(apply.times_small, 2, mean)
  se.apply_small <- apply(apply.times_small, 2, sd) / sqrt(replicates)
  
  m.apply_big <- apply(apply.times_big, 2, mean)
  se.apply_big <- apply(apply.times_big, 2, sd) / sqrt(replicates)
  
  # For 95% confidence intervals, we'll multiply the standard errors by 1.96
  conf.loop_small <- se.loop_small * 1.96
  conf.loop_big <- se.loop_big * 1.96
  
  conf.apply_small <- se.apply_small * 1.96
  conf.apply_big <- se.apply_big * 1.96
  
  # Create the error envelopes. Note that the x-coordinate is the same
  coord.x_small <- c(size_small, size_small[length(size_small)], rev(size_small))
  coord.x_big <- c(size_big, size_big[length(size_big)], rev(size_big))
  
  coord.y.loop_small <- c(m.loop_small + conf.loop_small, 
                          m.loop_small[length(m.loop_small)] - conf.loop_small[length(conf.loop_small)], 
                          rev(m.loop_small - conf.loop_small))
  
  coord.y.loop_big <- c(m.loop_big + conf.loop_big, 
                        m.loop_big[length(m.loop_big)] - conf.loop_big[length(conf.loop_big)], 
                        rev(m.loop_big - conf.loop_big))

  coord.y.apply_small <- c(m.apply_small + conf.apply_small, 
                           m.apply_small[length(m.apply_small)] - conf.apply_small[length(conf.apply_small)], 
                           rev(m.apply_small - conf.apply_small))  
  
  coord.y.apply_big <- c(m.apply_big + conf.apply_big, 
                         m.apply_big[length(m.apply_big)] - conf.apply_big[length(conf.apply_big)], 
                         rev(m.apply_big - conf.apply_big))
  
  #---------------------------------------------------------------------------------------
  # Plot it
  
  par(oma = c(2, 2, 4, 0))
  
  par(mfrow = c(1,2))
  
  # Plot #1: small matrices
  plot(size_small, m.loop_small, type = 'l', 
       ylim = c(min(m.loop_small - conf.loop_small), max(m.apply_small + conf.apply_small)),
       main = "Small matrices", las = 1,
       xlab = "Size of matrix (N cells)", ylab = NA, cex.axis = 1.2,
       cex.main = 1.6, cex.lab = 1.3, font.lab = 2, font.axis = 2)
  
  # Add the error envelope
  polygon(coord.x_small, coord.y.loop_small, col = "gray70", border = NA)
  lines(size_small, m.loop_small, lwd = 2)
  
  # Add the mean apply times
  lines(size_small, m.apply_small, col = "red", lwd = 3)
  polygon(coord.x_small, coord.y.apply_small, col = rgb(1, 0.1, 0.1, 0.3), border = NA)
  
  # Add the legend
  par(font = 2)
  legend("topleft", col = 1:2, pch = 19, cex = 1.1, c("For loop", "Apply"), bty = 'n')
  
  #-------------------------------------------------------------------------------------------
  # Plot #2: big matrices
  plot(size_big, m.loop_big, type = 'l', 
       ylim = c(min(m.loop_big - conf.loop_big), max(m.apply_big + conf.apply_big)),
       main = "Big matrices", las = 1,
       xlab = "Size of matrix (N cells)", ylab = NA, cex.axis = 1.2,
       cex.main = 1.6, cex.lab = 1.3, font.lab = 2, font.axis = 2)
  
  # Add the error envelope
  polygon(coord.x_big, coord.y.loop_big, col = "gray70", border = NA)
  lines(size_big, m.loop_big, lwd = 2)
  
  # Add the mean apply times
  lines(size_big, m.apply_big, col = "red", lwd = 3)
  polygon(coord.x_big, coord.y.apply_big, col = rgb(1, 0.1, 0.1, 0.3), border = NA)
  
  # Add the legend
  par(font = 2)
  legend("topleft", col = 1:2, pch = 19, cex = 1.1, c("For loop", "Apply"), bty = 'n')
  
  # Add the labels
  mtext(outer = T, side = 1, font = 2, cex = 1.5, "Size of matrix (N cells)")
  mtext(outer = T, side = 2, font = 2, cex = 1.5, "Time (s)")
  mtext(outer = T, side = 3, font = 2, cex = 2, 
        "Time required to find mean of 6 lowest values\nof each column of a matrix", padj = 0.3)

