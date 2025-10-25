# 💧 IoT-Based Smart Water Quality Monitoring System

## 📖 Overview
The **IoT-Based Smart Water Quality Monitoring System** measures and monitors water parameters including **Turbidity, pH, TDS, NPK levels, Gas presence, and Temperature** using **Arduino** and **ESP32** modules. The data is sent to a **cloud server** and visualized on a **web/mobile dashboard**, enabling real-time water quality monitoring for farmers, environmental agencies, and industries.

---

## 🎯 Problem Statement
Manual water testing is **time-consuming, costly, and prone to errors**. This project automates water quality monitoring by:
- Providing **real-time data** collection and analysis.
- **Reducing manual intervention**.
- **Sending data to cloud** for easy access and decision-making.

---

## ⚙️ Tech Stack

| Component | Technology Used |
|------------|-----------------|
| **Microcontroller** | Arduino Uno / ESP32 |
| **Cloud Platform** | Thingspeak / AWS IoT / Firebase |
| **Sensors** | Turbidity, pH, TDS, NPK, Gas (MQ-series), Temperature |
| **Communication** | Wi-Fi (ESP32) / Serial |
| **Database** | Cloud database (MySQL / Firebase Realtime DB) |
| **Frontend Dashboard** | Web / Mobile App |
| **Language** | C/C++ (Arduino IDE) |

---

## 🧰 Components Required

| Component | Description |
|------------|-------------|
| Arduino Uno / ESP32 | Main controller for data acquisition and transmission. |
| Turbidity Sensor | Measures water clarity (NTU). |
| pH Sensor | Measures acidity/alkalinity. |
| TDS Sensor | Detects total dissolved solids in ppm. |
| NPK Sensor | Measures nitrogen, phosphorus, potassium. |
| MQ Gas Sensor | Detects harmful gases or contamination. |
| Temperature Sensor | Reads water temperature. |
| LCD Display | Displays sensor readings locally. |
| Wi-Fi Module | Sends collected data to cloud. |
| Power Supply | 5V regulated power input. |

---

## 🔌 Circuit Connections (Example: Arduino Uno + ESP32)

| Sensor | Arduino Pin | Description |
|---------|--------------|-------------|
| Turbidity Sensor | A0 | Analog input for turbidity |
| pH Sensor | A1 | Analog input for pH |
| TDS Sensor | A2 | Analog input for TDS |
| NPK Sensor | A3 | Analog input for NPK |
| MQ Gas Sensor | A4 | Detects harmful gases |
| Temperature Sensor | D2 | Digital input |
| ESP32 / ESP8266 | TX/RX | Wi-Fi data transmission |
| LCD Display | D4–D7 | Display output |
| Power | 5V & GND | Common ground & power |

---

## 🧠 Working Principle
1. **Sensor Data Collection**: Each sensor reads its parameter (pH, TDS, Turbidity, etc.).
2. **Data Processing**: Arduino converts analog values to digital, applies calibration.
3. **Data Transmission**: ESP32 uploads processed data to **cloud** via Wi-Fi.
4. **Cloud Storage**: Data is stored for historical tracking and visualization.
5. **Dashboard Visualization**: Displays live values, trends, and alerts.

---

## ☁️ Cloud Workflow
```
[ Sensors ] 
    ↓
[ Arduino / ESP32 ] 
    ↓ (Wi-Fi)
[ Cloud Database (AWS / Firebase / Thingspeak) ] 
    ↓
[ Web / Mobile Dashboard ]
```

---

## 💾 Example Data Format

| Timestamp | Turbidity (NTU) | pH | TDS (ppm) | N (mg/L) | P (mg/L) | K (mg/L) | Gas Level | Temp (°C) | Water Quality |
|------------|-----------------|----|------------|-----------|-----------|-----------|-----------|-------------|----------------|
| 2025-10-25 10:30 | 2.5 | 6.8 | 320 | 12 | 5 | 18 | 50 | 28.5 | Good |
| 2025-10-25 10:45 | 6.9 | 7.2 | 420 | 15 | 8 | 22 | 65 | 29.1 | Moderate |

---

## 📲 Application Use Flow
```
Start → Sensors Initialize → Measure Parameters → Send to Cloud → Display Dashboard
```

---

## 💻 Arduino + ESP32 Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/iot-water-quality.git
cd iot-water-quality
```

### 2. Open Arduino IDE
- Install required libraries:
  - `WiFi.h`
  - `HTTPClient.h`
  - `LiquidCrystal.h`
  - `OneWire.h`
  - `DallasTemperature.h`
  - `ThingSpeak.h`

### 3. Connect Hardware
Connect sensors as per circuit table and verify COM port.

### 4. Update Wi-Fi and Cloud Credentials
```cpp
const char* ssid = "YourWiFiName";
const char* password = "YourWiFiPassword";
const char* server = "https://your-cloud-endpoint/api/";
```

### 5. Upload Code
- Select your board: **Arduino Uno / ESP32**
- Upload the `.ino` file.

### 6. Monitor Serial Output
Check live readings via **Serial Monitor**.

---

## 🧾 Cloud & Dashboard Setup
- **ThingSpeak**: Create channel & API key, link ESP32 HTTP POST.
- **AWS IoT Core**: Create device & topic, upload certificates.
- **Firebase**: Connect via REST API, visualize in Flutter/web app.

---

## 🚨 Alerts & Thresholds
| Parameter | Safe Range | Alert Condition |
|------------|-------------|----------------|
| pH | 6.5 – 8.5 | <6 or >9 |
| TDS | 0 – 500 ppm | >500 |
| Turbidity | 0 – 5 NTU | >5 |
| NPK | Optimal nutrient range | Out of range |
| Gas | <100 ppm | >150 ppm |

Alerts can trigger **buzzers or SMS/email notifications**.

---

## 📈 Dashboard Example
- Real-time readings
- Graphs for each sensor
- Water quality classification
- Historical reports

---
## 📸 Screenshots

Iot Sensors 
![WhatsApp Image 2025-10-25 at 11 53 04_4a9a5d3f](https://github.com/user-attachments/assets/71174ecc-09c3-4921-b45e-c193e024a3c0)
Application Working Dashboard
<img width="726" height="715" alt="image" src="https://github.com/user-attachments/assets/7d8331e1-aaf9-41b1-84dc-755332e355fd" />

## The Working Procedure Video Link ## 
https://youtube.com/shorts/c4t2vuDY0r4?si=7bTsnMxe-LTXeFo6




## 🚀 Future Enhancements
- AI-based contamination detection
- Automated water treatment control (valves/pumps)
- Solar-powered IoT module
- Mobile app integration with Flutter
- Voice-based water quality alerts

---

## 👨‍💻 Contributors
| Name | Role | Description |
|------|------|-------------|
| **S. Chandu** | Lead Developer & IoT Engineer | Designed sensor circuit, coded Arduino + ESP32, integrated cloud APIs. |

---

## 📄 License
This project is licensed under the **MIT License** – see [LICENSE](LICENSE) file for details.

---

## 🧠 Keywords
Arduino, ESP32, IoT, Turbidity, pH, TDS, NPK, Gas Sensor, Water Quality, Real-time Monitoring, Smart Agriculture

