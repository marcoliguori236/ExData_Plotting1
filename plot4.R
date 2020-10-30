library(dplyr)

##Check if data folder exists in current directory and create it if it does not exist
if(!file.exists("./data")){dir.create("./data")}

##Name the location within 'data' folder for the zip file
filename <- "data/dataset.zip"

##Same logic as the first step
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method="curl")
}

##Same logic as the first step
if (!file.exists("./data/household_power_consumption")) { 
  unzip(filename, exdir="./data") 
}

#Read data into a dataframe
df_pwr_consumption <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

#Change all ocurrences of "?" to NA
df_pwr_consumption[df_pwr_consumption=="?"] <- NA

#Change 'Date' and 'Time' to correct data types
pwr_consumption <- df_pwr_consumption %>% mutate(Date = as.Date(Date, "%d/%m/%Y"))

#Obtain only the 2 days that correspond, change columns to numeric type and create new column for plot2
subset <- pwr_consumption %>% subset(Date == "2007-02-01" | Date == "2007-02-02") %>% mutate(Global_active_power = as.numeric(Global_active_power),
                                                                                             Global_reactive_power = as.numeric(Global_reactive_power),
                                                                                             Voltage = as.numeric(Voltage),
                                                                                             Global_intensity = as.numeric(Global_intensity),
                                                                                             Sub_metering_1 = as.numeric(Sub_metering_1),
                                                                                             Sub_metering_2 = as.numeric(Sub_metering_2),
                                                                                             date.time = as.POSIXct(paste(subset$Date, subset$Time), format="%Y-%m-%d %H:%M:%S"))


#Create png graphic file device
png(filename = "plot4.png", width = 480, height = 480, units = "px")

#Set up grid
par(mfrow = c(2,2))

#First graph
with(subset, plot(date.time, Global_active_power, type = "l", xlab = "", ylab="Global Active Power"))

#Second graph
with(subset, plot(date.time, Voltage, type = "l"))

#Third graph
with(subset, plot(date.time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(subset, lines(date.time, Sub_metering_2, type = "l", col = "red"))
with(subset, lines(date.time, Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, bty = "n")

#Fourth graph
with(subset, plot(date.time, Global_reactive_power, type = "l"))


#Close device
dev.off()