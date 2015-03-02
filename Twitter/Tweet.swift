//
//  Tweet.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/17/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeAgo: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favouritesCount: Int?
    
    init(dictionary: NSDictionary) {
//        println("tweet: \(dictionary)")
        id = dictionary["id"] as? Int
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        favouritesCount = dictionary["favourites_count"] as? Int
        
        if let cas = createdAtString {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString!)
        
            timeAgo = String(Tweet.timeAgoSinceDate(createdAt!, numericDates: true))
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    //  "Time ago" function for Swift (based on MatthewYork's DateTools for Objective-C)
    //  https://gist.github.com/minorbug/468790060810e0d29545
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
        
        if (components.year >= 1) {
            return "\(components.year)y"
        } else if (components.month >= 1) {
            return "\(components.month)m"
        } else if (components.weekOfYear >= 1) {
            return "\(components.weekOfYear)w"
        } else if (components.day >= 1) {
            return "\(components.day)d"
        } else if (components.hour >= 1) {
            return "\(components.hour)h"
        } else if (components.minute >= 1) {
            return "\(components.minute)m"
        } else {
            return "\(components.second)s"
        }
    }
}
