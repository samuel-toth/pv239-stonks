//
//  CSVExporter.swift
//  Stonks
//
//  Created by Samuel Tóth on 03/06/2023.
//

import Foundation
import CodableCSV

class CSVExporter {
    
    static func exportHistoryRecords(records: [PortfolioAssetHistoryRecord]) -> ExportImportFile {
        var rows = [
            ["id", "asset", "change", "transactionDate"]
        ]
        do {
            for item in records {
                let assetId = item.asset?.id
                let assetName = item.asset?.name
                if assetName == nil || assetId == nil {
                    continue
                } else {
                    rows.append([assetId!.uuidString, assetName!, String(item.value), item.createdAt!.ISO8601Format()])
                }
            }
            let string = try CSVWriter.encode(rows: rows, into: String.self)
            return ExportImportFile(initialContent: string)
        } catch {
            fatalError("Unexpected error encoding CSV: \(error)")
        }
    }
}
