# **LG AIS Visualization** ![App Logo](https://raw.githubusercontent.com/LiquidGalaxyLAB/LG-Ship-Automatic-Identification-System-visualization/main/assets/img/full_logos.png/app_logo_noname.png)

[![Platform](https://img.shields.io/badge/platform-Android%20|%20Tablet-lightgrey)](https://github.com/username/repository)


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



## **Screenshots**


## **Enhancements & Future Plans**


## **API Integration**

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
