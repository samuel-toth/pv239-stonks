//
//  CSVImporter.swift
//  Stonks
//
//  Created by Samuel Tóth on 03/06/2023.
//

import Foundation
import CodableCSV

class CSVImporter {
    
    static func importHistoryRecords(url: URL) throws -> [(UUID, String, Double, Date)] {
        
        let data = try Data(contentsOf: url)
        guard let string = String(data: data, encoding: .utf8) else {
            throw ImportError.invalidData
        }
        
        let result = try CSVReader.decode(input: string)

        var records = [(UUID, String, Double, Date)]()
        
        for row in result[1...] {
            guard row.count >= 4 else {
                throw ImportError.invalidRow
            }
            guard let id = UUID(uuidString: row[0]) else {
                throw ImportError.invalidValue("ID")
            }
            guard let change = Double(row[2]) else {
                throw ImportError.invalidValue("Change")
            }
            let dateFormatter = ISO8601DateFormatter()
            guard let transactionDate = dateFormatter.date(from: row[3]) else {
                throw ImportError.invalidValue("Transaction Date")
            }
            
            records.append((id, row[1], change, transactionDate))
        }
        
        return records
    }
}

enum ImportError: Error {
    case invalidData
    case invalidRow
    case invalidValue(String)
}
