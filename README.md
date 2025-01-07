# Auction Platform API

A Ruby on Rails-based auction platform API where users can create and manage auctions, and place bids automatically. This API provides the ability to create auctions, place bids, and manage notifications.

---

## Table of Contents

1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Environment Setup](#environment-setup)
6. [Database Setup](#database-setup)
7. [Running the Application](#running-the-application)
8. [Testing with RSpec](#testing-with-rspec)
9. [RSpec Testing Result](#rspec-testing-result)
10. [API Endpoints](#api-endpoints)
11. [Design Patterns](#design-patterns)
12. [Database Entity Diagram](#database-entity-diagram)
13. [Auction Platform API Documentation](#auction-platform-api-documentation)

---

## Overview

The Auction Platform API allows users to create and manage auctions, bid on items, and place auto-bids with predefined amounts. It features the ability to send notifications for bid updates, auction creations, and other events.

The API is built using **Ruby on Rails** and employs various design patterns to ensure scalability, maintainability, and performance. It is designed to be easily extendable for future features.

---

## Getting Started

To get started with this project, follow the steps below to install the application, set up the environment, and run the application locally.

---

## Prerequisites

Before setting up the project, ensure you have the following installed:

- Ruby (version 3.0.4)
- Rails (version 7.1.5)
- Mysql (for production and testing)

---

## Installation

Follow these steps to set up the project on your local machine:
### 1. Clone the Repository

First, clone the repository to your local machine by running the following command:

git clone [https://github.com/davidraja17/auction_system.git](https://github.com/davidraja17/auction_system.git)
cd auction_system

 ### 2. Install Dependencies

 bundle install

 ### 3. Set up the environment variables

 Create a .env file in the root of the project to configure environment variables. You can base it on the .env.example file provided in the project.

---

 ## Environment Setup

 Make sure to set the necessary environment variables. Create a .env file at the root of the project with the following:
 
 DATABASE_URL=mysql://your_db_user:your_db_password@localhost:5432/auction_platform_development
SECRET_KEY_BASE=your_secret_key_base

Replace the values with your own credentials.

---

## Database Setup

After setting up the environment, run the following command to set up the database:

rails db:create
rails db:migrate

---

## Running the Application

Start the Rails server:

rails s

The application will be available at http://localhost:3000.

---

## Testing with RSpec

Install RSpec

If you haven’t installed RSpec, run:

bundle exec rails generate rspec:install

Running Tests:

bundle exec rspec

---

## RSpec Testing Result

<img width="1512" alt="Screenshot 2025-01-07 at 6 18 00 PM" src="https://github.com/user-attachments/assets/b0a50017-97bd-44ec-925f-9f6b5921f947" />


---

## API Endpoints

Here are the available API endpoints:

### Auctions:

Fetch all auctions -- GET /api/v1/auctions

Create a new auction -- POST /api/v1/auctions

Fetch a specific auction -- GET /api/v1/auctions/:id

Update a specific auction -- PUT /api/v1/auctions/:id

Delete a specific auction -- DELETE /api/v1/auctions/:id

### AutoBids:
Create a new auto bid -- POST /api/v1/auto_bids

### Users:
Register a new user -- POST /api/v1/users

Log in as a user -- POST /api/v1/login

---


## Design Patterns

This project follows several design patterns to maintain scalability and efficiency:

### 1. Singleton Pattern
We’ve implemented the Singleton pattern in the AuctionCloseJob to ensure that only one job exists for a specific auction and manages the auction closing process.

### 2. Observer Pattern
Used for handling notifications. Whenever an auction is updated, it triggers notifications to interested users, making the notification system reactive to auction changes.

### 3. Factory Method Pattern
Used in the creation of bids and auto-bids. By abstracting the bid creation logic into a method, we ensure that different types of bids can be handled in a uniform manner.

### 4. Strategy Pattern
The bidding strategy used for placing auto bids is managed by this pattern. Different bidding strategies (e.g., automatic increments, bid capping) can be implemented easily by switching between strategy objects.

---

## Database Entity Diagram

This section represents the relationships between the models used in the auction system.

### Entities and Relationships

#### **User**
- **Attributes**: 
  - `id` (primary key)
  - `name` (string)
  - `email` (string, unique)
  - `password_digest` (string)
  - `created_at` (datetime)
  - `updated_at` (datetime)
- **Associations**:
  - **has_many**: `auctions` (foreign_key: `seller_id`)
  - **has_many**: `bids` (foreign_key: `buyer_id`)
  - **has_many**: `auto_bids`
  - **has_many**: `notifications`
- **Validations**:
  - `name`, `email` must be present
  - `email` must be unique

#### **Auction**
- **Attributes**:
  - `id` (primary key)
  - `title` (string)
  - `description` (text)
  - `starting_price` (decimal)
  - `msp` (decimal)
  - `duration` (integer)
  - `ends_at` (datetime)
  - `status` (integer, enum: `active`, `closed`)
  - `user_id` (foreign_key: references `users` table as seller)
  - `winner_id` (foreign_key: references `users` table as winner, optional)
  - `created_at` (datetime)
  - `updated_at` (datetime)
- **Associations**:
  - **belongs_to**: `user` (foreign_key: `user_id`, seller)
  - **belongs_to**: `winner` (foreign_key: `winner_id`, optional)
  - **has_many**: `bids`, dependent: :destroy
  - **has_many**: `auto_bids`, dependent: :destroy
- **Validations**:
  - `title`, `description`, `starting_price`, `msp`, `duration`, `ends_at` must be present
  - Custom validation: `duration` must be greater than zero

#### **Bid**
- **Attributes**:
  - `id` (primary key)
  - `amount` (decimal)
  - `auction_id` (foreign_key: references `auctions` table)
  - `buyer_id` (foreign_key: references `users` table)
  - `created_at` (datetime)
  - `updated_at` (datetime)
- **Associations**:
  - **belongs_to**: `auction`
  - **belongs_to**: `buyer` (User)
- **Validations**:
  - `amount` must be greater than zero
- **Methods**:
  - `valid_bid?`: Checks if the bid amount is higher than the current highest bid

#### **AutoBid**
- **Attributes**:
  - `id` (primary key)
  - `max_amount` (decimal)
  - `auction_id` (foreign_key: references `auctions` table)
  - `buyer_id` (foreign_key: references `users` table)
  - `created_at` (datetime)
  - `updated_at` (datetime)
- **Associations**:
  - **belongs_to**: `auction`
  - **belongs_to**: `buyer` (User)
- **Validations**:
  - `max_amount`, `auction_id`, `buyer_id` must be present
  - `max_amount` must be greater than zero
  - Custom validation: `max_amount` must be higher than the current highest bid of the auction

#### **Notification**
- **Attributes**:
  - `id` (primary key)
  - `user_id` (foreign_key: references `users` table)
  - `message` (string)
  - `created_at` (datetime)
  - `updated_at` (datetime)
- **Associations**:
  - **belongs_to**: `user`
- **Validations**:
  - `user_id`, `message` must be present

---

# Auction Platform API Documentation

## Table of Contents

- [1. Auctions](#1-auctions)
  - [1.1. Create Auction](#11-create-auction)
  - [1.2. Update Auction](#12-update-auction)
  - [1.3. Get All Auctions](#13-get-all-auctions)
- [2. AutoBids](#2-autobids)
  - [2.1. Create AutoBid](#21-create-autobid)
  - [2.2. Get AutoBids for Auction](#22-get-autobids-for-auction)

---

## 1. Auctions

### 1.1. Create Auction
**Endpoint**:
POST /api/v1/auctions


**Description**:
Create a new auction in the system.

**Request Parameters**:
None.

**Request Body**:

| Parameter          | Type      | Description                               |
|--------------------|-----------|-------------------------------------------|
| title              | string    | Title of the auction (Required)          |
| description        | string    | Description of the auction (Required)    |
| starting_price     | decimal   | Starting price of the auction (Required) |
| msp                | decimal   | Minimum Selling Price (Required)         |
| duration           | integer   | Duration of the auction in hours (Required) |
| ends_at            | datetime  | Date and time when the auction ends (Required) |

**Response**:

| Code | Description                             |
|------|-----------------------------------------|
| 201  | Successfully created the auction       |
| 422  | Validation error (missing fields, etc.)|
| 500  | Internal server error                  |

**Sample Request**:
json
{
  "auction": {
    "title": "Auction 2",
    "description": "Auction description",
    "starting_price": 200,
    "msp": 300,
    "duration": 48,
    "ends_at": "2023-01-15T00:00:00Z"
  }
}


**Sample Response**:

{
  "id": 2,
  "title": "Auction 2",
  "description": "Auction description",
  "starting_price": 200,
  "msp": 300,
  "duration": 48,
  "ends_at": "2023-01-15T00:00:00Z",
  "created_at": "2022-12-10T15:00:00Z",
  "updated_at": "2022-12-10T15:00:00Z"
}

### 1.2. Update Auction
Endpoint:
PUT /api/v1/auctions/:id


**Description**:
Update the details of an existing auction.

**Request Parameters**:

| Parameter | Type | Description                              |
|-----------|------|------------------------------------------|
| id        | int  | Auction primary key ID to update (Required) |

**Request Body**:

| Parameter          | Type      | Description                               |
|--------------------|-----------|-------------------------------------------|
| title              | string    | (Optional) New title of the auction      |
| description        | string    | (Optional) New description of the auction|
| starting_price     | decimal   | (Optional) New starting price            |
| msp                | decimal   | (Optional) New minimum selling price     |
| duration           | integer   | (Optional) New duration in hours         |
| ends_at            | datetime  | (Optional) New end date and time         |

**Response**:

| Code | Description                                  |
|------|----------------------------------------------|
| 200  | Successfully updated the auction            |
| 422  | Validation error (invalid fields, etc.)     |
| 404  | Auction not found                           |

**Sample Request**:
json
{
  "title": "Auction 2 Updated",
  "starting_price": 250
}

### 1.3. Get All Auctions
**Endpoint**:

GET /api/v1/auctions


**Description**:
Retrieve a list of all auctions.

**Request Parameters**:
- No request parameters are required.

**Response**:

| Code | Description                            |
|------|----------------------------------------|
| 200  | Successfully retrieved the list of auctions |

**Sample Response**:
json

{    "id": 1,    "title": "Auction 1",    "description": "Auction description",    "starting_price": 100,    "msp": 150,    "duration": 48,    "ends_at": "2023-01-12T00:00:00Z",    "created_at": "2022-12-01T15:00:00Z",    "updated_at": "2022-12-02T15:00:00Z"  },  {    "id": 2,    "title": "Auction 2",    "description": "Auction description",    "starting_price": 200,    "msp": 250,    "duration": 72,    "ends_at": "2023-01-14T00:00:00Z",    "created_at": "2022-12-05T15:00:00Z",    "updated_at": "2022-12-06T15:00:00Z"  }









