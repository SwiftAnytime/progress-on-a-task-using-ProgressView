//
//  ContentView.swift
//  progress-on-a-task-using-ProgressView
//
//  Created by Etisha Garg on 30/07/24.
//

import SwiftUI

struct Joke: Identifiable, Hashable, Decodable {
    var id: Int
    var setup: String
    var punchline: String
}

struct ContentView: View {
    @State private var jokes: [Joke]?
    @State private var isFetching: Bool = false
    
    var body: some View {
        VStack {
            if isFetching {
                ProgressView("Loading jokes for you")
                    .controlSize(.large)
            } else {
                if let jokes = jokes {
                    List(jokes) { joke in
                        VStack(spacing: 10) {
                            Text(joke.setup)
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text(joke.punchline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                        )
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("No jokes available.")
                }
                Spacer()
                Button(action: refreshJokes) {
                    Text("Refresh")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            fetchJokes()
        }
    }
    
    func fetchJokes() {
        isFetching = true
        let url = URL(string: "https://official-joke-api.appspot.com/jokes/random/5")!
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedJokes = try JSONDecoder().decode([Joke].self, from: data)
                DispatchQueue.main.async {
                    self.jokes = decodedJokes
                    self.isFetching = false
                }
            } catch {
                print("Failed to fetch jokes: \(error)")
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }
        }
    }
    
    func refreshJokes() {
        jokes = nil
        fetchJokes()
    }
}


#Preview {
    ContentView()
}
