//
//  SoundSensorTableViewController.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import UIKit
import SwiftUI

class SoundSensorTableViewController: UITableViewController {
    var soundReadings = [SoundSensor]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(fetchSoundSensorData), userInfo: nil, repeats: true)
    }

    @objc func fetchSoundSensorData() {
        guard let url = URL(string: "http://localhost:8000/sound") else {
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
                let soundSensorPT = try JSONDecoder().decode(SoundSensorPT.self, from: data)
                DispatchQueue.main.async {
                    self.actualizarTablaCon(soundSensorPT)
                }
            } catch {
                print("Error al decodificar el JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func actualizarTablaCon(_ newReading: SoundSensorPT) {
        let reading = SoundSensor(value: String(newReading.value), timeStamp: Date())
        soundReadings.insert(reading, at: 0)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundReadings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundSensor", for: indexPath)

        let reading = soundReadings[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(reading.value)"
        content.secondaryText = "\(reading.timeStamp)"
        cell.contentConfiguration = content

        return cell
    }

    @IBSegueAction func openSoundSensorChart(_ coder: NSCoder) -> UIViewController? {
        let soundDataArray = soundReadings.map {
            SoundSensorInfo(value: Double($0.value) ?? 0.0, timeStamp: $0.timeStamp)
        }
        return UIHostingController(coder: coder, rootView: SoundSensorChartSwiftUIView(soundReadings: soundDataArray))
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
