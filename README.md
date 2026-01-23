# 🌲 The BVAR Model for Analyzing CO2 Emissions on Renewable Energy, Economic Growth, and Forest Area

[![DOI](https://img.shields.io/badge/DOI-10.28991%2Fesj--2025--09--03--02-blue)](https://doi.org/10.28991/esj-2025-09-03-02)
[![Journal](https://img.shields.io/badge/Journal-Emerging%20Science%20Journal-purple)](https://ijournalse.org/index.php/ESJ/article/view/2536)
[![Method](https://img.shields.io/badge/Method-Bayesian%20VAR-red)](https://en.wikipedia.org/wiki/Bayesian_vector_autoregression)
[![Status](https://img.shields.io/badge/Status-Published-success)]()

> **Research Paper Implementation:**
> *The BVAR Model for Analyzing CO2 Emissions on Renewable Energy, Economic Growth, and Forest Area*
> Published in **Emerging Science Journal**, Vol. 9, No. 3, 2025.

---

## 📖 Overview

The relationship between environmental degradation, energy consumption, and economic indicators is complex. This study employs a **Bayesian Vector Autoregression (BVAR)** model to analyze the dynamic interaction between:
1.  **CO2 Emissions** (Environmental degradation)
2.  **Renewable Energy Consumption**
3.  **Economic Growth** (GDP)
4.  **Forest Area**

Unlike standard VAR models, the BVAR approach incorporates prior information (priors) to handle over-parameterization and improve forecasting accuracy, especially in datasets with limited time-series observations.

### 🔑 Key Findings

Based on the BVAR model projections and analysis, this study highlights specific trends and policy implications:

* **📈 Future Projections (The Warning):** The model predicts a concerning trend where **CO2 emissions and Economic Growth (GDP)** are set to increase in the coming years, while **Forest Area and Renewable Energy Consumption** are projected to decrease significantly.
* **🌲 Role of Natural Resources:** Forest area is confirmed as a critical natural carbon sink. The decline in forest area due to illegal logging and burning is a major driver of environmental degradation.
* **⚡ Renewable Energy Gap:** While renewable energy is proven to be environmentally friendly, its consumption is projected to decline, contradicting the need for sustainable transition.
* **🏛️ Policy Urgency:** Urgent intervention is required to decouple economic growth from environmental damage, specifically through stricter anti-deforestation laws and aggressive incentives for renewable energy adoption.
---

## 📊 Methodology & Data

### The Model
We utilize the **Minnesota Prior** within the BVAR framework to estimate the coefficients. The analysis includes:
* **Impulse Response Functions (IRF):** To trace the effect of a one-standard-deviation shock to one of the innovations on current and future values of the endogenous variables.

## 📉 Data Source

This study utilizes **annual data** covering the period from **1990 to 2022**. The dataset is compiled from two primary international databases:

* **The World Bank (WDI)**
    * *Variables:* Renewable Energy Consumption, Economic Growth (GDP), and Forest Area.
    * *URL:* [www.worldbank.org](https://www.worldbank.org)

* **EDGAR (Emissions Database for Global Atmospheric Research)**
    * *Variables:* CO2 Emissions.
    * *URL:* [edgar.jrc.ec.europa.eu](https://edgar.jrc.ec.europa.eu/)

---

## 🛠️ Tech Stack

This project is implemented using **R/Python** (Adjust based on your actual code) with the following libraries:

* **Language:** R / Python
* **Libraries:**
    * `BVAR` / `bvarsv` (For Bayesian Modeling)
    * `vars` (For standard VAR comparison)
    * `ggplot2` / `matplotlib` (For plotting IRF and FEVD)
    * `tseries` (For stationarity tests/ADF)

---
