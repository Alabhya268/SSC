<!-- Images -->

![App logo](https://github.com/Alabhya268/SSC/blob/master/assets/logos/launcher_icon.png?raw=true)

SSC app is made for an organisation to easily keep track of all orders and payment along with their status. In app users have different level of access to information that are allowed by admin according to their roles.

## Features

- **Security:** Only the user that have been approved by admin can login into the app or web portal.

- **Information Control:** Admin can change user access to information according to their role.

- **Role based authentication:** This app has 3 different roles Admin, Accountant, Sales with different level of information access.

- **Notifications:** When a new order, payment, party is added or any modification are made in existing data, Push notification are sent to users according to their roles on mobile app.

## Roles and privileges

- ### **Parties**

  - Admin and account can add parties for any products while sales user can only add a party if allowed by the admin. Party limit is set by users when party is added and only admin can update it afterwards.

- ### **Orders and payments**

  - Admin and account can add, modify orders and payment for all products and parties. Sales user can only add orders but can not change their status to approved.

- ### **Orders and payments**

  - Admin and account can add, modify orders and payment for all products and parties. Sales user can only add orders but can not change their status to approved.

- ### **Members ection**

  - Members section is visible only to admin. In this section admin can approve, disapproved user and control the information access by changing their roles. Admin can also change the list products to control what kind of parties sales user has access to furthermore admin can view total number of approved orders by different users.

- ### **Sales section**

  - Sales section is visible only to admin. In this section admin can view how many approved orders have been placed.
  - Admin also has access to DateRange controller to check orders in certain time.

- ### **Products section**
  - Products section is visible only to admin. In this section admin can add and delete the products.

## Installation instructions

- Installing SSC app is really simple. Just download the sample apk from [here]() and install it on your android device.
- To use the web version visit [here](https://ssq-chq.firebaseapp.com/#/).

## To build and Run on your local machine

1. Install and setup flutter on your local device from [here](https://flutter.dev/docs/get-started/install).
2. Once flutter is installed, Clone this repo.
3. Run android emulator from android studio.
4. Open terminal in directory of this cloned repo.
5. Run the following commands:

```bash
  flutter clean
```

```bash
  flutter pub get
```

```bash
  flutter run lib/main.dart
```

6. Congrats, you have sucessfully compiled and ran this project on your android emulator. If you want to compile and run web version, run following commands.

```bash
   flutter config --enable-web
```

```bash
  flutter run lib/main.dart
```

- Note
  - Android studio, android sdk and android emulator is required to be install prior to these steps.

## Images

![Markdown Logo](https://github.com/Alabhya268/SSC/blob/master/assets/screenshots/mobile1.png?raw=true)
![Markdown Logo](https://github.com/Alabhya268/SSC/blob/master/assets/screenshots/mobile2.png?raw=true)
![Markdown Logo](https://github.com/Alabhya268/SSC/blob/master/assets/screenshots/web1.png?raw=true)
![Markdown Logo](https://github.com/Alabhya268/SSC/blob/master/assets/screenshots/web2.png?raw=true)
