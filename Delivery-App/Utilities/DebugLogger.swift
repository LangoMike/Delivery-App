//
//  DebugLogger.swift
//  Delivery-App
//
//  Created for debugging purposes
//

import Foundation

/// Simple debug logger that writes NDJSON to file
struct DebugLogger {
    // #region agent log
    static let logPath = "c:\\Users\\Lango\\OneDrive\\Documents\\College\\VT\\Fall 2025\\Mobile Dev\\Final\\Delivery-App-Final\\.cursor\\debug.log"
    
    /// Writes a log entry to the debug log file
    static func log(location: String, message: String, data: [String: Any] = [:], hypothesisId: String? = nil) {
        let logEntry: [String: Any] = [
            "id": "log_\(Int(Date().timeIntervalSince1970 * 1000))_\(UUID().uuidString.prefix(8))",
            "timestamp": Int(Date().timeIntervalSince1970 * 1000),
            "location": location,
            "message": message,
            "data": data,
            "sessionId": "debug-session",
            "runId": "run1",
            "hypothesisId": hypothesisId ?? "A"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: logEntry),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        let fileManager = FileManager.default
        let logURL = URL(fileURLWithPath: logPath)
        
        // Create directory if it doesn't exist
        try? fileManager.createDirectory(at: logURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        
        if let fileHandle = try? FileHandle(forWritingTo: logURL) {
            fileHandle.seekToEndOfFile()
            fileHandle.write((jsonString + "\n").data(using: .utf8)!)
            fileHandle.closeFile()
        } else {
            // Create file if it doesn't exist
            try? (jsonString + "\n").write(to: logURL, atomically: true, encoding: .utf8)
        }
    }
    // #endregion
}

