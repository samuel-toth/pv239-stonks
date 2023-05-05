//
//  CSVFile.swift
//  Stonks
//
//  Created by Martin Koprna on 04/05/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ExportImportFile: FileDocument {
    static var readableContentTypes = [UTType.commaSeparatedText]
    var content = ""
    
    init(initialContent: String = "") {
        content = initialContent
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            content = String(decoding: data, as: UTF8.self)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
