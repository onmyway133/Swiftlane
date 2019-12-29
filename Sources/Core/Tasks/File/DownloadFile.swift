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
    public var script: String?

    private var url: URL?
    private var to: String?

    public init(_ closure: (DownloadFile) -> Void = { _ in }) {
        closure(self)
    }
}

extension DownloadFile: Task {
    public func run(workflow: Workflow, completion: @escaping TaskCompletion) {
        guard let url = url, let to = to else {
            completion(.failure(PumaError.invalid))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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

public extension DownloadFile {
    /// Download and save
    /// - Parameters:
    ///   - url: url of remote resource
    ///   - toPath: Full path to destination location. For example /Users/me/Downloads/def.md
    func download(url: URL, to: String) {
        self.url = url
        self.to = to
    }
}

