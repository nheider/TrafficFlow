# TrafficFlow
R Scripts to periodically download images from a highway photo webcam and to use a pre-trained neural net to count the number of vehicles in each photo to approximate traffic patterns.

It is split of into two scripts right now. One downloads the pictures and the other takes the downloaded images and runs the object detection on them. It is built that way so the download script can be continually running on a (cheap & slow) server and the object detection can be run on a more powerful workstation. 


# Annotated Image 
![alt text](https://raw.githubusercontent.com/nheider/TrafficFlow/main/example.png)

# Observed Traffic Pattern
![alt text](https://raw.githubusercontent.com/nheider/TrafficFlow/main/traffic_pattern.png)


# To do: 
- rewrite in Python and TensorFlow 
- Change pre-trained model or train own model that can bettter differentiate between different types of vehicles 
- use second model / better overall model to count cars based on head-/ tail lights (the script currently doesn't count at night)
- add many more webcams and rewrite so that the vehicles in the image taken can be counted at the time of download  
- run on server and publish the current state of traffic on a website / api 
- write anomaly detection 
