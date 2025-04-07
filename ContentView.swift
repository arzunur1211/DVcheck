//
//  ContentView.swift
//  DVcheck
//
//  Created by Aita Macbook on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCountry = "Russia" // Выбор страны
      @State private var birthYear = "" // Год рождения (ввод пользователя)
      @State private var selectedEducation = "High School degree" // Уровень образования
      @State private var lotteryYear = 2025 // Год лотереи (увеличивается после каждой проверки)
      @State private var lotteryResult: String? = nil // Статус выигрыша
      @State private var caseNumber: String? = nil // Case Number (при выигрыше)
      @State private var isChecking = false // Флаг для анимации загрузки
    let countries: [String: String] = [
            "United States": "NA", "Afghanistan": "AS", "Albania": "EU", "Algeria": "AF",
            "Argentina": "SA", "Armenia": "EU", "Australia": "OC", "Azerbaijan": "EU",
            "Bangladesh": "AS", "Belarus": "EU", "Belgium": "EU", "Bhutan": "AS",
            "Bolivia": "SA", "Bosnia and Herzegovina": "EU", "Brazil": "SA", "Bulgaria": "EU",
            "Burkina Faso": "AF", "Burundi": "AF", "Cambodia": "AS", "Cameroon": "AF",
            "Canada": "NA", "Central African Republic": "AF", "Chile": "SA", "China": "AS",
            "Colombia": "SA", "Costa Rica": "NA", "Côte d'Ivoire": "AF", "Croatia": "EU",
            "Cuba": "NA", "Cyprus": "EU", "Czech Republic": "EU", "Denmark": "EU",
            "Dominican Republic": "NA", "Ecuador": "SA", "Egypt": "AF", "El Salvador": "NA",
            "Estonia": "EU", "Ethiopia": "AF", "Fiji": "OC", "Finland": "EU",
            "France": "EU", "Georgia": "EU", "Germany": "EU", "Ghana": "AF",
            "Greece": "EU", "Guatemala": "NA", "Haiti": "NA", "Honduras": "NA",
            "Hungary": "EU", "Iceland": "EU", "India": "AS", "Indonesia": "AS",
            "Iran": "AS", "Iraq": "AS", "Ireland": "EU", "Israel": "EU",
            "Italy": "EU", "Jamaica": "NA", "Japan": "AS", "Jordan": "AS",
            "Kazakhstan": "EU", "Kenya": "AF", "Kuwait": "AS", "Kyrgyzstan": "EU",
            "Laos": "AS", "Latvia": "EU", "Lebanon": "AS", "Libya": "AF",
            "Lithuania": "EU", "Madagascar": "AF", "Malaysia": "AS", "Mali": "AF",
            "Mexico": "NA", "Moldova": "EU", "Mongolia": "AS", "Montenegro": "EU",
            "Morocco": "AF", "Mozambique": "AF", "Myanmar": "AS", "Nepal": "AS",
            "Netherlands": "EU", "New Zealand": "OC", "Nicaragua": "NA", "Niger": "AF",
            "Nigeria": "AF", "North Macedonia": "EU", "Norway": "EU", "Oman": "AS",
            "Pakistan": "AS", "Panama": "NA", "Paraguay": "SA", "Peru": "SA",
            "Philippines": "AS", "Poland": "EU", "Portugal": "EU", "Qatar": "AS",
            "Romania": "EU", "Russia": "EU", "Rwanda": "AF", "Saudi Arabia": "AS",
            "Senegal": "AF", "Serbia": "EU", "Singapore": "AS", "Slovakia": "EU",
            "Slovenia": "EU", "Somalia": "AF", "South Africa": "AF", "South Korea": "AS",
            "Spain": "EU", "Sri Lanka": "AS", "Sudan": "AF", "Sweden": "EU",
            "Switzerland": "EU", "Syria": "AS", "Tajikistan": "EU", "Tanzania": "AF",
            "Thailand": "AS", "Tunisia": "AF", "Turkey": "EU", "Uganda": "AF",
            "Ukraine": "EU", "United Kingdom": "EU", "Uruguay": "SA", "Uzbekistan": "EU",
            "Venezuela": "SA", "Vietnam": "AS", "Yemen": "AS", "Zambia": "AF",
            "Zimbabwe": "AF"
        ]

        // 🔹 Базовые шансы выигрыша по странам
        let winChances: [String: Int] = [
            "United States": 10, "India": 3, "Ukraine": 9, "Russia": 8,
            "Brazil": 10, "Nigeria": 5, "China": 4, "Egypt": 7,
            "Mexico": 8, "Vietnam": 6, "Germany": 12, "France": 11,
            "United Kingdom": 10, "Canada": 15, "Norway": 15,
            "Bangladesh": 3, "Iran": 4, "Pakistan": 5, "Ethiopia": 6,
            "Turkey": 10, "Japan": 14, "Argentina": 11, "South Africa": 9,
            "Australia": 16, "New Zealand": 18, "Sweden": 14, "Spain": 13,
            "Italy": 13, "Netherlands": 12, "Poland": 10, "South Korea": 7
        ]
    let educationLevels = [
           "No High School", "High School degree", "Vocational School",
           "Some University Courses", "University Degree", "Some Graduate Level Courses", "Master’s Degree", "Some Doctorate Level Courses", "Doctorate"
       ]

       var body: some View {
           VStack(spacing: 20) {
               Text("Entrant Status Check")
                   .font(.largeTitle)
                   .bold()
               
               Text("Please enter your details and check your status")
                   .font(.subheadline)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, 20)
               
               TextField("Enter your birth year", text: $birthYear)
                   .keyboardType(.numberPad)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .frame(width: 200)
                   .multilineTextAlignment(.center)
                   .padding()
               
               // Выбор уровня образования
               Picker("Select your education level", selection: $selectedEducation) {
                   ForEach(educationLevels, id: \.self) { level in
                       Text(level)
                   }
               }
               .pickerStyle(MenuPickerStyle())
               .padding(.horizontal, 40)
               
               // Выбор страны
               Picker("Select your country", selection: $selectedCountry) {
                   ForEach(countries.keys.sorted(), id: \.self) { country in
                       Text(country)
                   }
               }
               .pickerStyle(MenuPickerStyle())
               .padding(.horizontal, 40)
               Button(action: checkStatus) {
                               Text("Check Status")
                                   .padding()
                                   .frame(maxWidth: .infinity)
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                                   .font(.headline)
                           }
                           .padding(.horizontal, 40)
                           .disabled(birthYear.isEmpty)
               
               if isChecking {
                               ProgressView("Checking Entry...")
                                   .padding()
                           }

                           // Вывод результата
                           if let result = lotteryResult {
                               VStack {
                                   Text(result)
                                       .font(.headline)
                                       .foregroundColor(result.contains("HAS BEEN SELECTED") ? .green : .red)
                                       .padding()
                                       .multilineTextAlignment(.center)

                                   if let caseNum = caseNumber {
                                       Text("Your Case Number: \(caseNum)")
                                           .font(.title2)
                                           .bold()

                                           .foregroundColor(.blue)
                                           .padding()
                                   }
                               }
                           }
                       }
                       .padding()
                   }
             
                            func checkStatus() {
                                   guard let birthYearInt = Int(birthYear), birthYearInt >= 1900, birthYearInt <= 2024 else {
                                       lotteryResult = "❌ Invalid birth year. Please enter a valid year."
                                       return
                                   }

                                   isChecking = true
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                       var chance = winChances[selectedCountry] ?? 10 // Базовый шанс

                                       // Коррекция шансов в зависимости от возраста
                                       let age = 2025 - birthYearInt
                                       if age < 18 {
                                           chance /= 2  // Если младше 18 лет, шанс в 2 раза ниже
                                       }

                                       // Коррекция шансов по образованию
                                       if selectedEducation == "No High School" {
                                           chance /= 2  // Если нет среднего образования, шанс ниже
                                       } else if selectedEducation == "Master’s Degree" || selectedEducation == "Doctorate" {
                                           chance += 5  // Если высшее образование, шанс выше
                                       }

                                       let isWinner = Int.random(in: 1...100) <= chance

                                       if isWinner {
                                           let regionCode = countries[selectedCountry] ?? "EU"
                                           let randomNumber = Int.random(in: 1000...50000)
                                           caseNumber = "\(lotteryYear)\(regionCode)\(String(format: "%06d", randomNumber))"

                                           lotteryResult = """
                                           ✅ Dear Entrant,
                                           You HAVE BEEN SELECTED for further processing for the Diversity Visa Lottery Program DV-\(lotteryYear).
                                           """
                                       } else {
                                           caseNumber = nil
                                           lotteryResult = """
                                           ❌ Dear Entrant,
                                           Based on the information provided, you HAVE NOT BEEN SELECTED for DV-\(lotteryYear).
                                           Please try again next year.
                                           """
                                       }

                                       lotteryYear += 1
                                       isChecking = false
                                   }
                               }
                           }

                           struct ContentView_Previews: PreviewProvider {
                               static var previews: some View {
                                   ContentView()
                               }
                           }

