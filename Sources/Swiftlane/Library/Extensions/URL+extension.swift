//
//  URL.swift
//  Swiftlane
//
//  Created by Khoa on 17/02/2022.
//

import Foundation

extension URL {
    func ensuringExtension(_ ext: String) -> URL {
        guard pathExtension != ext else { return self }

        var url = self
        url.deletePathExtension()
        url.appendPathExtension(ext)
        return url
    }
}
