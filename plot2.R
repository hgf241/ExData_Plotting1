## If the file already exists: don't download again
if (!file.exists("household_power_consumption.txt")) {
    fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "houhousehold_power_consumption.zip")
    unzip("houhousehold_power_consumption.zip")
}

library(data.table)
datahead <- fread("household_power_consumption.txt", na.strings="?", stringsAsFactor=TRUE, nrows=1) ## Read the colnames
datas <- fread("household_power_consumption.txt", na.strings="?", stringsAsFactor=TRUE, skip=66000, nrows=5000)
setnames(datas, colnames(datas), colnames(datahead))  ## Set the colnames
datas <- datas[datas$Date>="1/2/2007" & datas$Date<="2/2/2007",]

library(dplyr)
datas <- mutate(datas, NewDate = (paste(Date, Time)))
#mutate(datas, Date = as.Date(Date, "%d/%m/%Y"))

timestamp <- strptime(datas$NewDate, "%d/%m/%Y %H:%M:%S")
plot(timestamp, datas$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.copy(png, file = "plot2.png", width = 480, height = 480, units = "px", bg = "white")  ## Copy my plot to a PNG file
dev.off()  ## Don't forget to close the PNG device!
