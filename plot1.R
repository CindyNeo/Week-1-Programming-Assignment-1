## Check if the directory exists

if (!file.exists("Data")) {
    dir.create("Data")
}


## Download the dataset

Url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(Url, destfile = "./Data/household_power_consumption.zip")


## Unzip the dataset

unzip(zipfile = "./Data/household_power_consumption.zip", 
      exdir = "./Data")


## Load the data into R

consumption <- read.table("./Data/household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)
head(consumption)


## Mutate the dataset to have a new column "Date_Time" which combines Date and Time into a single column

Date_Time <- strptime(paste(consumption$Date, consumption$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
consumption <- cbind(consumption, Date_Time)
head(consumption)


## Change all the columns into the correct classes

consumption$Date <- as.Date(consumption$Date, format = "%d/%m/%Y")
consumption$Time <- format(as.POSIXlt(consumption$Time, format = "%H:%M:%S"), "%H:%M:%S")
consumption$Global_active_power <- as.numeric(consumption$Global_active_power)
consumption$Global_reactive_power <- as.numeric(consumption$Global_reactive_power)
consumption$Voltage <- as.numeric(consumption$Voltage)
consumption$Global_intensity <- as.numeric(consumption$Global_intensity)
consumption$Sub_metering_1 <- as.numeric(consumption$Sub_metering_1)
consumption$Sub_metering_2 <- as.numeric(consumption$Sub_metering_2)
consumption$Sub_metering_3 <- as.numeric(consumption$Sub_metering_3)
head(consumption)


## Filter the dataset to include dates from 2007-02-01 and 2007-02-02 only

library(dplyr)

data <- consumption %>%
            filter(between(Date, as.Date("2007-02-01"), as.Date("2007-02-02"))) %>%
            print()


##### Create Plot 1

## Create histogram for Plot 1 - Make sure that it looks OK first before saving it to PNG file

hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")


## Save the histogram to a PNG file named "plot1.png"

png(file = "plot1.png", width = 480, height = 480)
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()
