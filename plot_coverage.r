x_files <- list.files(pattern="*txt")
sample_names <- substr(x_files, 1, nchar(x_files)-10)
sample_names <- paste(substr(sapply(strsplit(sample_names, "_"), "[[", 1), 1, 1), "_",
						sapply(strsplit(sample_names, "_"), "[[", 2), "_",
						sapply(strsplit(sample_names, "_"), "[[", 3), "_",
						sapply(strsplit(sample_names, "_"), "[[", 4), sep="")

coverage_max_to_check <- 60
plot_max <- coverage_max_to_check + 2

output1 <- list()
output2 <- list()
mean_coverage <- c()
for(a in 1:length(x_files)) {
  a_rep <- scan(x_files[a])
  a_output <- c()
  for(b in 1:plot_max) {
    if(b == plot_max) {
      a_output <- c(a_output, length(a_rep[a_rep >= (b - 1)]))
    } else {
      a_output <- c(a_output, length(a_rep[a_rep == (b - 1)]))
    }
  }
  a_output2 <- a_output / sum(a_output)
  output1[[a]] <- a_output
  output2[[a]] <- a_output2
  mean_coverage <- c(mean_coverage, mean(a_rep))
}

rm(a_rep)
save.image("setophaga_coverage.RData")







load("setophaga_coverage.RData")

par(mfrow=c(5,11))
for(a in 1:length(output2)) {
  plot(0:61, output2[[a]], pch=19, cex=0.1, xlab="Coverage", ylab="Proportion S.coronata genome", main=sample_names[a], ylim=c(0,0.3))
  poly.plot <- rbind(cbind(0:61, output2[[a]]), c(61, 0), c(0,0))
  polygon(poly.plot, col="gray")
  abline(v=mean_coverage[a], col="red")
}

mean_coverage_samples <- cbind(sample_names, mean_coverage)

write.table(mean_coverage_samples, "mean_coverage_samples.txt", sep = "\t")
