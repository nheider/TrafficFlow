library(platypus)
library(tidyverse)

# set the classifier to the used images
yolo <- yolo3(
  net_h = 480, 
  net_w = 640,
  grayscale = FALSE, # RGB or Grayscale
  n_class = 80, 
  anchors = coco_anchors 
)

# load pretrained weights from the Working Directory  
#available here: https://pjreddie.com/media/files/yolov3.weights
yolo %>% load_darknet_weights("yolov3.weights")

# get all image names in a list to iterate through 
img_paths <- list.files(path="images", pattern="*.jpg", full.names=TRUE, recursive=FALSE)

# loop that takes a single images, uses the classifier and appends the counted vehicles 
# to a datafame with the images date and time 
for(i in 1:length(img_paths)){
  tryCatch({
    imgs <- img_paths[i] %>%
      map(~ {
        image_load(., target_size = c(480, 640), grayscale = FALSE) %>%
          image_to_array() %>%
          `/`(255)
      }) %>%
      abind(along = 4) %>%
      aperm(c(4, 1:3))
    

    id <- str_replace_all(img_paths[i], "images/", "")
    id <- str_replace_all(id, ".jpg", "")
    img_time <- str_split_fixed(id, "_", 2)
    
    preds <- yolo %>% predict(imgs)
    
    boxes <- get_boxes(
      preds = preds, 
      anchors = coco_anchors, 
      labels = coco_labels, 
      obj_threshold = 0.6,  
      nms = TRUE,  
      nms_threshold = 0.6 
    )
    
    vehicles <- as.data.frame(boxes)
    vehicles$id <- id
    vehicles$date <- img_time[1]
    vehicles$time <- img_time[2]
    
    vehicles$n_vehicles <- vehicles %>% 
      nrow() 
    
    vehicles <- vehicles %>% 
      select(-c(1:8))
    
    
    new_row <- vehicles[1,]
    
    if(i == 1){
      vehicle_count <- new_row
    } else {
      vehicle_count <- rbind(vehicle_count, new_row)
    }
    print(i)
    
    # the package outputs an error if no vehicles are detected. 
    # This keeps the loop running and outputs the errors as NAs in the Dataframe 
    # so we can check the source of the issue (happens mostly at night)
   }, error=function(e){
    print("error")
    error_row <- new_row
    error_row$date <- img_time[1]
    error_row$time <- img_time[2]
    error_row$n_vehicles <- NA
    vehicle_count <<- rbind(vehicle_count, error_row)
  })
}

