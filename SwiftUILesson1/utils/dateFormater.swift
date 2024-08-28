//
//  dateFormater.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 19.08.2024.
//

import Foundation

func hoursSincePublished(_ dateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    guard let publishedDate = isoFormatter.date(from: dateString) else {
        return "Unknown time"
    }

    let currentDate = Date()
    let timeInterval = currentDate.timeIntervalSince(publishedDate)

    let hours = Int(timeInterval / 3600) // Перетворення секунд на години
    if hours == 0 {
        return "Less than an hour ago"
    } else if hours == 1 {
        return "1 hour ago"
    } else {
        return "\(hours) hours ago"
    }
}
