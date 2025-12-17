//
//  TimelineView.swift
//  Delivery-App
//
//  Created by Mike Gweth Lango on 12/10/25.
//

import SwiftUI

/// Timeline component showing order stages with current stage highlighted
struct TimelineView: View {
    let currentStage: OrderStage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(OrderStage.allCases, id: \.self) { stage in
                HStack(spacing: 12) {
                    // Stage indicator
                    ZStack {
                        Circle()
                            .fill(isStageCompleted(stage) ? Color.green : (isCurrentStage(stage) ? Color.blue : Color.gray.opacity(0.3)))
                            .frame(width: 24, height: 24)
                        
                        if isStageCompleted(stage) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        } else if isCurrentStage(stage) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    // Stage text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stage.displayName)
                            .font(isCurrentStage(stage) ? .headline : .body)
                            .foregroundColor(isCurrentStage(stage) ? .primary : .secondary)
                        
                        if isCurrentStage(stage) && stage != .delivered {
                            Text("In progress")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    /// Checks if a stage is the current stage
    private func isCurrentStage(_ stage: OrderStage) -> Bool {
        stage == currentStage
    }
    
    /// Checks if a stage has been completed (comes before current stage)
    private func isStageCompleted(_ stage: OrderStage) -> Bool {
        let allStages = OrderStage.allCases
        guard let currentIndex = allStages.firstIndex(of: currentStage),
              let stageIndex = allStages.firstIndex(of: stage) else {
            return false
        }
        return stageIndex < currentIndex
    }
}

