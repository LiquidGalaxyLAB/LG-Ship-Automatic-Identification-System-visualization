<p align="center">
  <img src="https://github.com/user-attachments/assets/7ad1095d-7597-4a5e-bd17-493b8b6809b3" alt="app_logo_lg" width="500" />
  <br/>
  <a href="https://github.com/username/repository">
    <img src="https://img.shields.io/badge/platform-Android%20|%20Tablet-lightgrey" alt="Platform" />
  </a>
</p>

## **Table of Contents**

1. [Overview](#overview)
2. [Main Features and Functionalities](#main-features-and-functionalities)
3. [Usage](#usage)
4. [Screenshots](#screenshots)
5. [Enhancements & Future Plans](#enhancements--future-plans)
6. [API Integration](#api-integration)
7. [Installation](#installation)
8. [Contributing](#contributing)
9. [Contact](#contact)

## **Overview**

### **Description**
LG AIS Visualization is a app designed to provide real-time tracking, detailed vessel information, predictive route analysis, and collision risk management. It is optimized for Liquid Galaxy systems, allowing seamless synchronization of maps between the rig and the app. The app can also function standalone, providing maritime insights based on open AIS data from the Norwegian Coastal Administration

### The Importance of Real-Time Maritime Data Visualization

The maritime industry is the backbone of global trade, with over 90% of global trade carried by sea. Ensuring the safety and efficiency of maritime operations is critical, not only for economic reasons but also for environmental protection and the well-being of seafarers.

Recent events, like the catastrophe of the Baltimore Key Bridge collapse after a ship collision, highlight the devastating consequences of accidents at sea. Such incidents can cause significant economic damage, environmental harm, and loss of life.

**Reference:** March 26, 2024 - Baltimore Key Bridge collapses after ship collision (cnn.com)

### **Technology Used**
- **Flutter**
- **Dart**
- **KML (Keyhole Markup Language)**
- **Google Earth Visualization**
- **Google Maps Integration**
- **Machine Learning (K-Nearest Neighbors)**

## Main Features and Functionalities

1. **Real-Time Vessels Tracking::**
   - Streaming the vessels movement 

2. **Vessel Information Display:** 
   - Users can select a vessel to display detailed information such as:
     - Name
     - Country
     - Vessel Type
     - Navigation Details: Speed Over Ground, Course Over Ground, Navigational Status, Rate of Turn, Heading, Last Known Position
     - Vessel Characteristics: Ship Type, Call Sign, Destination, ETA, IMO Number, Draught
     - Physical Dimensions: Dimension A, Dimension B, Dimension C, Dimension D, Ship Length, Ship Width
     - Positioning Details: Position Fixing Device Type, Report Class

3. **Historical Route Playback:** 
   - View past routes and analyze vessel movements.

4. **Future Route Prediction:** 
   - Predict potential future routes using historical data.

5. **Collision Risk Management:** 
   - Users can select any two vessels to calculate the Closest Point of Approach (CPA) and Time to Closest Point of Approach (TCPA). This feature is crucial for collision avoidance.

6. **Region-Specific Vessel Display:** 
   - Users can freely draw a specific region to show the current vessels within it.

7. **Filter Mechanism:** 
   - The app supports filtering based on the type of vessel (up to 70 types with search)

## **Usage**
Here's a guide on how to use the AIS Visualization app, focusing on common tasks and key features:

### 1. **Live Ship Tracking**
- **Overview:** When you open the app, you’ll see a real-time map displaying the current positions of ships in Norwegian waters.
- **How to Use:** Simply launch the app to start tracking. (Make sure you are registered as a client.) A cluster of vessels will appear for better visibility. Select a cluster to open vessel markers and view their details.

### 2. **Detailed Vessel Information**
- **Overview:** The app provides in-depth information about each ship, including its name, type, speed, course, and more.
- **How to Use:** Tap on any ship icon on the map. (The information will appear in the "Visualization" section and will update whenever you select a different vessel. This data is streamed, so changes in vessel information are reflected in real-time.)

### 3. **Historical Vessel Routes**
- **Overview:** This feature allows you to review the past routes of vessels, helping you analyze navigation patterns and behavior over time.
- **How to Use:** Navigate to the "Visualization" section in the vessel tracker timeline panel. Select the start and end dates, then use the media player to play back the routes of the selected vessel.

### 4. **Future Route Prediction**
- **Overview:** The app uses machine learning to predict potential future routes of ships, providing valuable insights for maritime safety.
- **How to Use:** In the same "Visualization" section, find the "Predict Route" panel to view predicted future routes.

### 5. **Collision Risk Management**
- **Overview:** This feature helps in assessing potential collision scenarios by calculating the Closest Point of Approach (CPA) and Time to CPA (TCPA) between two vessels.
- **How to Use:** Go to the "Collision" section, select your vessel and the target vessel, then perform the calculations to assess potential collision risks.

### 6. **Data Processing and Filtering**
- **Overview:** The app handles large volumes of data from the AIS source, which is updated every few minutes and tracks up to 4000 vessels, along with historical data going back two weeks.
- **How to Use:** Data processing is mostly automated. You can manage the data load by selecting specific regions or applying filters from the filter section to ensure smooth performance and accurate visualization.

### 7. **Liquid Galaxy Visualization**
- **Overview:** Make sure you are connected to the Liquid Galaxy rig.
- **How to Use:** Once connected, current vessels will automatically appear spanning the Norwegian region area in a polygon. For each visualization and filter, you can use a button to display the data on Liquid Galaxy. The app is designed to work both standalone and with Liquid Galaxy, supporting various visualizations including playing orbits, tour tracks, collision routes, predictive routes, past route tracks, and synchronization with the app map. The app also integrates balloons for detailed information.

## **Screenshots**
![s1](https://github.com/user-attachments/assets/28e811e4-060b-4a87-bff6-a20ebdf14a43)
About the App
![s2](https://github.com/user-attachments/assets/ca31493f-d658-4847-979c-cf919ffc9568)
Clustering Streamed Vessels
![s3](https://github.com/user-attachments/assets/461b134c-b175-4580-b269-360646aad6ed)
Detailed Vessel Information
![s4](https://github.com/user-attachments/assets/679174a1-2e01-4da2-8446-9f90bbc3cdf3)
Past Route Tracker Timeline
![s5](https://github.com/user-attachments/assets/2b30da37-f806-4cdf-9aa3-ccae96d42916)
Future Route Prediction Fan Chart
![s6](https://github.com/user-attachments/assets/4182c2ee-6b4f-4be0-b26f-06a5d274f227)
Collision Calculations
![s7](https://github.com/user-attachments/assets/23500221-a450-46fe-ae1e-43c62849c7b5)
Region Free Drawing
![s8](https://github.com/user-attachments/assets/aab894e6-625b-47b2-9eab-b7b460ccea22)
Filtering by Types, but with drawing too

## **Enhancements & Future Plans**

### **Enhancements**
1. **Improvement in K-Nearest Neighbors (KNN) Prediction Model:**
   - The current KNN model can be enhanced by fine-tuning the parameters and incorporating more data points to improve the accuracy of predicting future vessel routes. These additional data points can be obtained from the third API in the integration section. However, it's important to note that retrieving more data may slow down the process and occasionally cause interruptions with the API.
    
2. **Exploring Alternative Models for Prediction:**
   - In addition to enhancing the current K-Nearest Neighbors (KNN) model, we plan to explore different machine learning models for vessel route prediction.

3. **Advanced Collision Risk Management:**
   - The collision risk management feature will be further developed to include more sophisticated algorithms that consider additional factors like weather conditions, nearby obstacles, and vessel maneuverability. This enhancement will provide more comprehensive safety measures and alert systems for avoiding potential collisions.

### **Future Plans**
1. **Integration of AIS Messages:**
   - A new feature could be introduced to allow users to view specific AIS messages sent by a vessel through its antenna. By making use of the full range of AIS data, this feature would enable users to monitor communications and gain deeper insights into a vessel's operations and status, providing a more detailed picture of maritime activities.

2. **Enhanced Visualization Options:**
   - Future updates could include more advanced visualization options, such as 3D representations of vessels and dynamic weather overlays. This would provide users with a richer, more immersive experience when tracking and analyzing maritime data.


## **API Integration**

- **[BarentsWatch AIS Live OpenAPI Documentation](https://live.ais.barentswatch.no/index.html#/AIS-Latest/get_v1_latest_combined):** Provides real-time AIS data for vessel tracking. This API is used for retrieving the latest positions and statuses of vessels.
  
- **[BarentsWatch AIS Historic OpenAPI Documentation](https://historic.ais.barentswatch.no/index.html):** This API is used to access vessel tracking data from the past 14 days, as the live API only provides access to the last 24 hours of data.

For both the Live and Historic APIs, you can refer to the [API documentation](https://developer.barentswatch.no/docs/intro). Both APIs require a token, which can be obtained by registering a user client as described in the app.

- **[Additional Data API](https://kystdatahuset.no/ws/swagger/index.html):** Since the 14-day limit may not be sufficient for accurate future route predictions in the KNN model, this API provides access to a larger dataset.


## **Installation**

### **Prerequisites**
- **Requirement 1:** Flutter SDK and Dart
- **Requirement 2:** Liquid Galaxy Rig Setup (Refer to the Liquid Galaxy Lab repository, review YouTube workshop videos, consult the community Wiki, and seek additional support on the LG Discord)
- **Requirement 3:** Tablet Emulator or Physical Tablet (Alternatively, you can use virtual tablet emulators like BlueStacks)

### **Setup**
1. Clone the repository:
    ```bash
    git clone https://github.com/LiquidGalaxyLAB/LG-Ship-Automatic-Identification-System-visualization
    ```
2. Navigate to the project directory:
    ```bash
    cd LG-Ship-Automatic-Identification-System-visualization
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Run the app:
    ```bash
    flutter run
    ```


## **Contributing**

To contribute to the project, you can help by testing the app, reporting issues, or contributing code. Here’s how you can get involved:

### Testing and Reporting Issues:
- **Test the App:** Use the app extensively and report any bugs or performance issues you encounter.
- **Report Issues:** If you find any bugs or have suggestions for improvements, please create a new issue in the repository.

### Code Contributions:
1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a Pull Request: Submit a pull request to the main repository for review.

### You can also contribute by suggesting or working on new features.

We appreciate all forms of contribution and look forward to your involvement!

## **Contact**
- **Name:** Rofayda Bassem ElSayed
- **Email:** rofaydabassem@gmail.com
- **LinkedIn:** [Rofayda Bassem](https://www.linkedin.com/in/rofayda-bassem-03363b1a9/)
- **GitHub:** [Rofaydaaa](https://github.com/rofaydaaa)
