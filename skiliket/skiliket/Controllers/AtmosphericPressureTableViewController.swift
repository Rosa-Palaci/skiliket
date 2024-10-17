//
//  AtmosphericPressureTableViewController.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import UIKit
import SwiftUI

class AtmosphericPressureTableViewController: UITableViewController {
    var pressures = [AtmosphericPressure]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(fetchAtmosphericPressure), userInfo: nil, repeats: true)
    }

    @objc func fetchAtmosphericPressure() {
        guard let url = URL(string: "http://localhost:8000/wind") else {
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
                let atmosphericPressurePT = try JSONDecoder().decode(AtmosphericPressurePT.self, from: data)
                DispatchQueue.main.async {
                    self.actualizarTablaCon(atmosphericPressurePT)
                }
            } catch {
                print("Error al decodificar el JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func actualizarTablaCon(_ newPressure: AtmosphericPressurePT) {
        let pressure = AtmosphericPressure(value: String(newPressure.value), timeStamp: Date())
        pressures.insert(pressure, at: 0)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pressures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "atmosphericPressure", for: indexPath)

        let pressure = pressures[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(pressure.value)"
        content.secondaryText = "\(pressure.timeStamp)"
        cell.contentConfiguration = content

        return cell
    }

    @IBSegueAction func openAtmosphericPressureChart(_ coder: NSCoder) -> UIViewController? {
        let pressureDataArray = pressures.map {
            AtmosphericPressureInfo(value: Double($0.value) ?? 0.0, timeStamp: $0.timeStamp)
        }
        return UIHostingController(coder: coder, rootView: AtmosphericPressureChartSwiftUIView(pressures: pressureDataArray))
    }
}


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

