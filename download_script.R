# written to run periodically (every 5 minutes) using cron on ubuntu server

setwd("/home")
if(!dir.exists("images")){ 
  dir.create("images")
}
url <- "http://www.verkehrsinfos.ulm.de/webcam/b10-S/current.jpg"
# Add Date and Time of Download to Image Name  
path <- paste("images/", gsub(" ", "_", toString(Sys.time())), ".jpg", sep = "")
download.file(url, destfile = path)