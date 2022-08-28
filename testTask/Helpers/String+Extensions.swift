//
//  String+Extensions.swift
//  testTask
//
//  Created by Александр Катков on 27.08.2022.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
