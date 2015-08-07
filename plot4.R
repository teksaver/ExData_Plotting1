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


##Code for plot 4

#add datetime column for automatic days labelling
elecData$datetime<-as.POSIXct(paste(elecData$Date, elecData$Time), format="%Y-%m-%d %H:%M:%S")
#open png graphic device
png("plot4.png", width = 480, height = 480, units = "px")
#make sure labels are in english on Ubuntu
Sys.setlocale("LC_TIME", "en_US.UTF-8")

#page with 4 graphs
par(mfrow=c(2,2))

#top-left : same as graph 2 without "kilowatts"
with(elecData,plot(datetime,Global_active_power,type="l",xlab="",ylab="Global Active Power"))
#top-right : voltage instead of Gap, x legend is "datetime"
with(elecData,plot(datetime,Voltage,type="l",ylab="Voltage"))

#bottom-left: same as graph 3 without the box for the legend
with(elecData,plot(datetime,Sub_metering_1,type="n",xlab="",ylab="Energy sub metering"))
lines(elecData$datetime,elecData$Sub_metering_1,col="black")
lines(elecData$datetime,elecData$Sub_metering_2,col="red")
lines(elecData$datetime,elecData$Sub_metering_3,col="blue")
legend('topright','groups',c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c('black','red','blue'), lty=c(1,1,1),bty='n')

#bottom-right: global reactive power
with(elecData,plot(datetime,Global_reactive_power,type="l",ylab="Global Reactive Power(kilowatts)"))

#close device
dev.off()

