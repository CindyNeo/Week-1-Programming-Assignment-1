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


##### Create Plot 4

## Create for Plot 4 - Make sure that it looks OK first before saving it to PNG file

par(mfrow = c(2, 2))

with(data, plot(Date_Time, Global_active_power, ylab = "Global Active Power", xlab = " ", type = "l"))

with(data, plot(Date_Time, Voltage, xlab = "datetime", ylab = "Voltage", type = "l"))

with(data, plot(Date_Time, Sub_metering_1, ylab = "Energy sub metering", xlab = " ", type = "l", col = "black"))
lines(data$Date_Time, data$Sub_metering_2, type = "l", col = "red")
lines(data$Date_Time, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, bty = "n")

with(data, plot(Date_Time, Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "l"))


## Save Plot 4 to a PNG file named "plot4.png"

png(file = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))

with(data, plot(Date_Time, Global_active_power, ylab = "Global Active Power", xlab = " ", type = "l"))

with(data, plot(Date_Time, Voltage, xlab = "datetime", ylab = "Voltage", type = "l"))

with(data, plot(Date_Time, Sub_metering_1, ylab = "Energy sub metering", xlab = " ", type = "l", col = "black"))
lines(data$Date_Time, data$Sub_metering_2, type = "l", col = "red")
lines(data$Date_Time, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, bty = "n")

with(data, plot(Date_Time, Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "l"))

dev.off()
