//
//  dateFormater.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 03.09.2024.
//

import Foundation

func formatDate(_ dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "HH:mm dd.MM.yy"
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}
