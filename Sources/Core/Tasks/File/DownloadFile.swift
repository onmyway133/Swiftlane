//
//  DownloadFile.swift
//  PumaCore
//
//  Created by khoa on 29/12/2019.
//

import Foundation
import Files

public class DownloadFile {
    public var name: String = "Download file"
    public var isEnabled = true

    private let url: URL
    private var to: String = "."

    public init(remoteURL: URL) {
        url = remoteURL
    }
}

// MARK: - Modifiers

public extension DownloadFile {
    func destination(_ path: String) -> Self {
        to = path
        return self
    }
}

// MARK: - Task

extension DownloadFile: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [to] (data, response, error) in
            guard let data = data else {
                completion(.failure(error ?? PumaError.invalid))
                return
            }

            do {
                try Folder.createFolderIfNeeded(path: to.folderPath())
                try data.write(to: URL(fileURLWithPath: to))
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })

        task.resume()
    }
}
