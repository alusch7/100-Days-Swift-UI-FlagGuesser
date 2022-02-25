//
//  ContentView.swift
//  FlagGuesser
//
//  Created by Alden Luscher on 2022-02-23.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var dispMessage = ""
    @State private var questionCount = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            questionCount += 1
                            if questionCount != 8 {
                                flagTapped(number)
                            } else {
                                flagTapped(number)
                                gameOver = true
                            }
                        } label: {
                            FlagImage(image: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 450)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .alert(scoreTitle, isPresented:  $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("\(dispMessage)")
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Restart", role: .cancel) {
                questionCount = 0
                score = 0
            }
        } message: {
            Text("Great job! Your score was \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            dispMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            dispMessage = """
            That's the flag of \(countries[number])
            Your score is \(score)
            """
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
