//
//  OptionFactory.swift
//  Puma
//
//  Created by khoa on 16/04/2019.
//

import Foundation

public struct OptionFactory {
    public init() {}

    public struct ArchiveOptions {
        public let archivePath: String
        public let exportPath: String
    }
    
    /// Puma/Archives/2019-04-16/TestApp 16-04-2019, 14.31.xcarchive
    /// Puma/Exported/2019-04-16/TestApp 16-04-2019, 14.31
    public func makeArchiveOptions(name: String, date: Date = Date()) -> ArchiveOptions {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH.mm"
        let timeString = timeFormatter.string(from: date)
        
        let makePath: (String, String) -> String = { folder, path in
            return "./Puma/\(folder)/\(dateString)/\(name) \(dateString), \(timeString)\(path)"
        }
        
        return ArchiveOptions(
            archivePath: makePath("Archives", ".xcarchive"),
            exportPath: makePath("Exported", "")
        )
    }
}
