## for private use only
## no operation guarantee

library(jsonlite)
library(magrittr)

null_to_na <- function(element){
  if(is.null(element)==TRUE){
    element <- NA
  }
  return(element)
}

## 動画IDを指定してそのデータを取得する
youtube <- function(youtube_id,api_key){
  if(is.na(youtube_id)==TRUE){
    row <- data.frame(rep(NA,10))
  }else{
    url = paste('https://www.googleapis.com/youtube/v3/videos?id=',youtube_id,'&key=',api_key,'&part=snippet,contentDetails,statistics,status',sep="")
    json <- fromJSON(url)
    items <- json$items
    contentsDetails <- items$contentDetails
    snippet <- items$snippet
    status <- items$status
    statistics <- items$statistics
    row <- data.frame(id=youtube_id,
                      title=snippet$title %>% null_to_na(),
                      publish=snippet$publishedAt %>% null_to_na(),
                      privacy=status$privacyStatus %>% null_to_na(),
                      upload=status$uploadStatus %>% null_to_na(),
                      viewCount=statistics$viewCount %>% null_to_na(),
                      likeCount=statistics$likeCount %>% null_to_na(),
                      dislikeCount=statistics$dislikeCount %>% null_to_na(),
                      favoriteCount=statistics$favoriteCount %>% null_to_na(),
                      commentCount=statistics$commentCount %>% null_to_na())
    if(length(row)==1){
      row <- data.frame(rep(NA,10))
    }
  }
  return(row)
}

## ユーザーIDを指定して全動画のデータを取得する
get_videos <- function(user,api_key){
  print("retrieving video list...")
  user_url <- paste("https://www.googleapis.com/youtube/v3/channels?part=contentDetails&forUsername=",user,"&key=",api_key,sep="")
  user_json <- fromJSON(user_url)
  play_id <- user_json$items$contentDetails$relatedPlaylists$uploads
  play_url <- paste("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=",play_id,"&maxResults=50&key=",api_key,sep="")
  play_json <- fromJSON(play_url)
  video_id <- play_json$items$snippet$resourceId$videoId
  while(is.null(play_json$nextPageToken)==FALSE){
    play_url <- paste("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=",play_id,"&maxResults=50&key=",api_key,"&pageToken=",play_json$nextPageToken,sep="")
    play_json <- fromJSON(play_url)
    video_id <- c(video_id,play_json$items$snippet$resourceId$videoId)
  }
  print("get video data...")
  youtube_data <- data.frame()
  for(id in video_id){
    row <- youtube(id,api_key)
    youtube_data <- rbind(youtube_data,row)
    print(paste(row$id %>% as.character,row$title %>% as.character()))
    Sys.sleep(0.001)
  }
  youtube_data <- youtube_data[,c("id","publish","title","viewCount","likeCount","dislikeCount","commentCount")]
  youtube_data$viewCount <- as.numeric(as.character(youtube_data$viewCount))
  youtube_data$likeCount <- as.numeric(as.character(youtube_data$likeCount))
  youtube_data$dislikeCount <- as.numeric(as.character(youtube_data$dislikeCount))
  youtube_data$commentCount <- as.numeric(as.character(youtube_data$commentCount))
  return(youtube_data)
}