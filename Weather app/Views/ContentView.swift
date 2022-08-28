//
//  ContentView.swift
//  Weather app
//
//  Created by Ernest Mihasenko on 19.07.22.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var viewModel = CurrentWeatherViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            weatherInfoView
                .onAppear {
                    viewModel.onAppear()
                }
        }
    }
    
    var weatherInfoView: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    VStack {
                        Text("\(viewModel.temperature)°")
                            .font(.largeTitle)
                        Text(viewModel.status)
                            .font(.title2)
                        Text("\(NSLocalizedString("Humidity:", comment: "")) \(viewModel.humidity)%")
                        Text("\(NSLocalizedString("Wind speed:", comment: "")) \(viewModel.windSpeed) \(NSLocalizedString("m/s", comment: ""))")
                        
                    }
                    ForEach(viewModel.daily, id: \.date) { daily in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.dateString(for: daily))
                                Text(viewModel.weatherString(for: daily))
                                Spacer()
                                Text(viewModel.tempString(for: daily))
                            }
                            Divider()
                        }
                        .padding(.horizontal, 15)
                    }
                }
            }
            .navigationTitle(viewModel.city)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Search", action: { viewModel.presentsSearch = true })
                })
            }
        }
        .textFieldAlert(
            isShowing: $viewModel.presentsSearch,
            text: $viewModel.searchCity,
            title: NSLocalizedString("Search city", comment: ""),
            textfieldTitle: NSLocalizedString("textfieldTitle", comment: ""),
            action: {
                viewModel.refreshWeather()
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
