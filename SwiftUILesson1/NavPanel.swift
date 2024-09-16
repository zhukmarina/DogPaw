//
//  NavPanel.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 28.08.2024.
//

import SwiftUI

struct NavPanel: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        LazyHStack {
            Button(action: {
                selectedTab = 0
            }) {
                Image(systemName: "dog")
                    .frame(width: 80)
            }
            .overlay(
                selectedTab == 0 ?
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 75, height: 50) :
                nil
            )
            
            Button(action: {
                selectedTab = 1
            }) {
                Image(systemName: "magnifyingglass")
                    .frame(width: 80)
            }
            .overlay(
                selectedTab == 1 ?
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 75, height: 50) :
                nil
            )
            
            Button(action: {
                selectedTab = 2
            }) {
                Image(systemName: "heart")
                    .frame(width: 80)
                    
            }
            .overlay(
                selectedTab == 2 ?
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 75, height: 50) :
                nil
            )
        }
        .background()
        .multilineTextAlignment(.center)
        .frame(width: 250, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 1)
        )
    }
}

struct NavPanel_Previews: PreviewProvider {
    @State static var selectedTab: Int = 0
    
    static var previews: some View {
        NavPanel(selectedTab: $selectedTab)
    }
}
