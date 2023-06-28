//
//  ResultView.swift
//  MTG-SQLite
//
//  Created by Dylan Martin on 6/27/23.
//

import SwiftUI

struct ResultView: View {
    let cards: [Card]
    let onBack: () -> Void  

    var body: some View {
        VStack {
            List(cards) { card in
                CardView(card: card)
            }
            .navigationBarTitle("Search Results")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            onBack()
        }) {
            Text("Back")
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(cards: [], onBack: {})
    }
}
