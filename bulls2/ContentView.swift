//
//  ContentView.swift
//  bulls2
//
//  Created by Lukasz Zajac on 07/12/2020.
//

import SwiftUI

struct ContentView: View {
    
    // Properties
    
    // Colors
    let midnightBlue = Color(red: 0,
                             green: 0.2,
                             blue: 0.4)
    // Game stats
    
    
    // User interface views
    // Stany są to dane wyswietlane w obecnej chwili, które się zmieniają. Stanami w samochodzie są informacje na desce rozdzielczej
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    
    var slider: Int { // stworzenie zmiennej slider aby w kółko nie powtarzac w kodzie długiego kodu
      Int(sliderValue.rounded())
    }
    
    var sliderTargerDifference: Int {
        abs(slider - target) // abs - usuwa znak minus niezaleznie od wyniku dając zawsze wartość dodatnią
    }
    
    @State var score = 0
    @State var round = 1
    
    
    // Methods
    // =======
    
    func pointsForCurrentRound() -> Int {
        let maximumScore = 100
        print("Difference wynosi \(sliderTargerDifference)")
        let points: Int
        if sliderTargerDifference == 0 {
            points = 200
        } else if sliderTargerDifference == 1 {
            points = 150
        } else {
            points = maximumScore - sliderTargerDifference
        }
        return points
    }
    
    func scoringMessage() -> String {
        return "The slider's value is \(self.slider).\n" +
            "The target value is \(target).\n" +
            "You scored \(pointsForCurrentRound()) points this round."
    }
    
    func alertTitle() -> String {
        let title: String
        if sliderTargerDifference == 0 {
            title = "Perfect!"
        } else if sliderTargerDifference < 5 {
            title = "You almost had it!"
            
        } else if sliderTargerDifference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    func startNewGame() {
        resetSliderAndTarget()
        score = 0
        round = 1
    }
    
    func startNewRound() {
        score += self.pointsForCurrentRound()
        round += 1
        resetSliderAndTarget()
    }
    
    func resetSliderAndTarget() {
        target = Int.random(in: 1...100)
        sliderValue = Double.random(in: 1...100)
    }
    
    // VIEW MODIFIERS - stałe elementy wyglądu, DRY. Zapisuj to co sie powtarza w kodzie i sie odwołuj
    // ==============
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.white)
                .modifier(Shadow())
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
        }
    }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.black)
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
                .foregroundColor(Color.black)
        }
    }
    
    // User interface content and layout
    var body: some View {
        NavigationView { // tworzy pasek nawigacji na górze strony, trzeba zakonczyc .navigationViewStyle(StackNavigationViewStyle())
            VStack {
                Spacer().navigationBarTitle("🎯 Bullseye 🎯") // wyswietlanie napisu na pasku nawigacji
                // Target row
                HStack {
                    Text("Put the bullseye as close as you can to:").modifier(LabelStyle()) // zamiast powtarzania kodu dajemy po prostu modifier i sie odnosimy
                    Text("\(target)").modifier(ValueStyle())
                }
                Spacer()
                
                // Slider row
                // TODO: Add views for the slider row here.
                
                HStack {
                    Text("1").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100)
                        .accentColor(Color.green) // zmiana koloru wewnąrz suwaka
                        .animation(.easeOut)
                    Text("100").modifier(LabelStyle())
                }
                Spacer()
                
                // Button row
                Button(action: {
                    print("Button pressed!")
                    alertIsVisible = true
                }) {
                    Text("Hit me!").modifier(ButtonLargeTextStyle())
                }
                .background(Image("ik300x100"))
                        .modifier(Shadow())
                .alert(isPresented: $alertIsVisible) {
            // ALERT
                    Alert(title: Text(alertTitle()),
                          message: Text(scoringMessage()),
                          // zamieniam typ zmiennych double na integer. rounded = zaokrąglenie w gore wartosci i w dół
                          dismissButton: .default(Text("Awesome!")) { // dopiero po kliknięciu w AWESOME wykona sie ponizszy kod
                            startNewRound()
                          })
                }
                Spacer()
                
                // Score row
                // TODO: add views for the score, rounds, and start and info buttons here
                
                HStack {
                    Button(action: {
                        startNewGame()
                    }) {
                        Image("StartOverIcon@2x")
                        /*@START_MENU_TOKEN@*/Text("Start over")/*@END_MENU_TOKEN@*/.modifier(ButtonSmallTextStyle())
                    }
                    .background(Image("ik300x100")
                                    .modifier(Shadow())
                    )
                    Spacer()
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    Spacer()
                    Text("Round").modifier(LabelStyle())
                    Text("\(round)").modifier(ValueStyle())
                    Spacer()
                    NavigationLink(destination: AboutView()) { // przekierowanie z przycisku INFO do AboutView
                        HStack {
                            Image("InfoButton@2x")
                            /*@START_MENU_TOKEN@*/Text("Info")/*@END_MENU_TOKEN@*/.modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("ik300x100")
                                    .modifier(Shadow())
                    )
                }
                .padding(.bottom, 20)
                .accentColor(midnightBlue)
            }
            .onAppear() { // .metoda, która wywołuje funkcje tylko raz przy uruchomieniu programu. teraz dzieki tej metodzie suwak jest odrazu na losowej pozycji zamiast na domyslnym 50
                startNewGame()
            }
            .background(Image("walllx"))
            }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}


// Preview
// =======

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
