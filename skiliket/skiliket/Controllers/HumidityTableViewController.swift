//
//  HumidityTableViewController.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import UIKit
import SwiftUI

class HumidityTableViewController: UITableViewController {
    var humidities = [Humidity]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(fetchHumidity), userInfo: nil, repeats: true)
    }

    @objc func fetchHumidity() {
        guard let url = URL(string: "http://localhost:8000/humidity") else {
            print("URL inválida")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            // Verificar si hubo un error
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                return
            }

            // Verificar si los datos son nulos
            guard let data = data else {
                print("Los datos son nulos")
                return
            }

            // Imprimir los datos para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Respuesta del servidor: \(jsonString)")
            }

            // Intentar decodificar el JSON
            do {
                let humidityPT = try JSONDecoder().decode(HumidityPT.self, from: data)
                DispatchQueue.main.async {
                    self.actualizarTablaCon(humidityPT)
                }
            } catch {
                print("Error al decodificar el JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func actualizarTablaCon(_ newH: HumidityPT) {
        let h = Humidity(value: String(newH.value), timeStamp: Date())
        humidities.insert(h, at: 0)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return humidities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "humidity", for: indexPath)

        let h = humidities[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(h.value)"
        content.secondaryText = "\(h.timeStamp)"
        cell.contentConfiguration = content

        return cell
    }
    
    
    @IBSegueAction func openHumidityChart(_ coder: NSCoder) -> UIViewController? {
        let humidityDataArray = humidities.map { HumidityInfo(value: Double($0.value) ?? 0.0, timeStamp: $0.timeStamp) }
        return UIHostingController(coder: coder, rootView: HumidityChartSwiftUIView(humidities: humidityDataArray))
    }
}
