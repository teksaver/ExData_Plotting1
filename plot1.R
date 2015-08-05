#only load data if the object does not exist - avoids downloading and parsing the file if it has already been done in another script
#this code could be in another R file sourced by each plot*.R file, but the asignment asks for 4 R files only!

if(!exists("elecData")){
    #download resource file using curl (Mac/Linux). Remove method="curl" on windows if download fails
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="elecdata.zip", method="curl")

    ""
    #find where the 2880 observations for the 2 days we are interested in (1440 minutes/day) are located in the file
    goodlines<-grep("^((1|2)/2/2007)+",readLines(unz("elecdata.zip", "household_power_consumption.txt")))
    #get column names from the file first line
    noms <- strsplit(readLines(unz("elecdata.zip", "household_power_consumption.txt"),1),";")[[1]]
    #read from file
    elecData <- read.table(unz("elecdata.zip", "household_power_consumption.txt"),sep=";",skip=goodlines[1]-1,nrows=length(goodlines),col.names=noms,na.strings="?")
    #convert in R date format
    elecData$Date <- as.Date(strptime(elecData$Date,format="%d/%m/%Y"))
}

##specific code for plot 1

#open png
png("plot1.png", width = 480, height = 480, units = "px")
#create plot
plot1 <- with(elecData,hist(Global_active_power,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power"))
#close display
dev.off()

