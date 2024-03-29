#!/bin/bash

link="$1"

#this token doesn't change that often in fact this one has been valid for quite some time
twitter_default_anon_token="AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA"
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36 Edg/95.0.1020.40"

tweetid="${link#*status/}"
tweetid="${tweetid%\?*}"


#get a guest
gtg=$(curl "${link}" \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H "User-Agent: ${useragent}" \
  --compressed | grep "decodeURIComponent(\"gt=" | cut -d ';' -f 2 | cut -d '=' -f 4 )

api_res=$(curl "https://twitter.com/i/api/graphql/NtPJS7yopZTC4lPvb_kVEA/TweetDetail?variables=%7B%22focalTweetId%22%3A%22${tweetid}%22%2C%22with_rux_injections%22%3Afalse%2C%22includePromotedContent%22%3Atrue%2C%22withCommunity%22%3Atrue%2C%22withQuickPromoteEligibilityTweetFields%22%3Afalse%2C%22withTweetQuoteCount%22%3Atrue%2C%22withBirdwatchNotes%22%3Afalse%2C%22withSuperFollowsUserFields%22%3Atrue%2C%22withUserResults%22%3Atrue%2C%22withNftAvatar%22%3Afalse%2C%22withBirdwatchPivots%22%3Afalse%2C%22withReactionsMetadata%22%3Afalse%2C%22withReactionsPerspective%22%3Afalse%2C%22withSuperFollowsTweetFields%22%3Atrue%2C%22withVoice%22%3Atrue%7D" \
  -H 'authority: twitter.com' \
  -H 'x-twitter-client-language: en' \
  -H "authorization: Bearer ${twitter_default_anon_token}" \
  -H 'content-type: application/json' \
  -H "x-guest-token: $gtg" \
  -H 'x-twitter-active-user: yes' \
  -H 'accept: */*' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H "User-Agent: ${useragent}" \
  -H "referer: $link" \
  -H 'accept-language: en-US,en;q=0.9' \
  --compressed)

# echo $api_res > out.json
# api_res=$(cat out.json)

# instrcutions will always be 0
search_obj=$(echo "$api_res" | jq '.data.threaded_conversation_with_injections.instructions[0]')

search_tweet_id="tweet-$tweetid"

for i in  $(echo "$search_obj" | jq -r '.entries | keys | .[]'); do
    cur_tweet_id=$(echo "$search_obj" | jq -r ".entries[$i].entryId")
    echo "searched: $search_tweet_id - current: $cur_tweet_id"
    if [[ "$search_tweet_id" == "$cur_tweet_id" ]] ; then
        #saving tweet content 
        echo "$search_obj" | jq ".entries[$i]" > "$tweetid.json"
        searched_tweet=$(echo "$search_obj" | jq ".entries[$i].content.itemContent.tweet_results.result.legacy.extended_entities")
    fi
done

for i in  $(echo "$searched_tweet" | jq '.media | keys | .[]'); do
    curr_media_type=$(echo "$searched_tweet" | jq ".media[$i].type")
    case $curr_media_type in
	*"photo"*)
		link=$(echo "$searched_tweet" | jq -r ".media[$i].media_url_https")
        wget -c "$link"
        # break
		;;
	*"video"*)
		curr_media_max_bitrate="0"
        curr_media_url=""
        curr_media_variants=$(echo "$searched_tweet" | jq ".media[$i].video_info")
        for j in  $(echo "$curr_media_variants" | jq '.variants | keys | .[]'); do
            curr_media_content_type=$(echo "$curr_media_variants" | jq ".variants[$j].content_type")
            # need to check for content type in order to not encouter missing bitrate errors on xhr
            if [[ *"$curr_media_content_type"* == *"video/mp4"* ]] ; then
                curr_media_bitrate=$(echo "$curr_media_variants" | jq -r ".variants[$j].bitrate")
                # if this video bitrate is higher than we replace the current video in order to get the highest bitrate possible
                if [[ "$curr_media_bitrate" -gt "$curr_media_max_bitrate" ]] ; then
                    echo "$curr_media_bitrate"
                    curr_media_max_bitrate="$curr_media_bitrate"
                    curr_media_url=$(echo "$curr_media_variants" | jq -r ".variants[$j].url")
                fi
            fi
        done
        curr_media_url="${curr_media_url%\?*}"
        wget -c "$curr_media_url"
		# break
		;;
	*"animated_gif"*)
		curr_media_max_bitrate="0"
        curr_media_url=""
        curr_media_variants=$(echo "$searched_tweet" | jq ".media[$i].video_info")
        for j in  $(echo "$curr_media_variants" | jq '.variants | keys | .[]'); do
            curr_media_content_type=$(echo "$curr_media_variants" | jq ".variants[$j].content_type")
            # need to check for content type in order to not encouter missing bitrate errors on xhr
            if [[ *"$curr_media_content_type"* == *"video/mp4"* ]] ; then
                curr_media_bitrate=$(echo "$curr_media_variants" | jq -r ".variants[$j].bitrate")
                # if this video bitrate is higher than we replace the current video in order to get the highest bitrate possible
                if [[ "$curr_media_bitrate" -ge "$curr_media_max_bitrate" ]] ; then
                    echo "$curr_media_bitrate"
                    curr_media_max_bitrate="$curr_media_bitrate"
                    curr_media_url=$(echo "$curr_media_variants" | jq -r ".variants[$j].url")
                fi
            fi
        done
        curr_media_url="${curr_media_url%\?*}"
        wget -c "$curr_media_url"
		# break
		;;
    *)
        echo "this post is a $curr_media_type which is currently not supported. please email me"
        ;;
  esac
done

# echo "$searched_tweet" > media.json
