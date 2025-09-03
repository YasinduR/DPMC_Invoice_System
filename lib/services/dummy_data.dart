// Dummy Data File
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/invoic_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/reference_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/tin_model.dart';

class DummyData {
  static final List<Dealer> _dealers = [
    // COLOMBO REGION
    Dealer(
      accountCode: 'AC2000123301',
      name: 'Perera & Sons Motors',
      surname: 'Perera',
      address: 'No 12, Galle Road',
      city: 'Colombo 03',
      region: 'COLOMBO',
    ),
    Dealer(
      accountCode: 'AC2000123302',
      name: 'Colombo Auto Traders',
      surname: 'Auto Traders',
      address: '110, High Level Road',
      city: 'Nugegoda',
      region: 'COLOMBO',
    ),
    Dealer(
      accountCode: 'AC2000123303',
      name: 'Capital Wheels',
      surname: 'Wheels',
      address: '45, Parliament Road',
      city: 'Rajagiriya',
      region: 'COLOMBO',
    ),
    Dealer(
      accountCode: 'AC2000123304',
      name: 'De Silva Car Sales',
      surname: 'De Silva',
      address: '203, Baseline Road',
      city: 'Colombo 08',
      region: 'COLOMBO',
    ),
    Dealer(
      accountCode: 'AC2000123305',
      name: 'Metro Vehicle Centre',
      surname: 'Metro',
      address: '78, Nawala Road',
      city: 'Nawala',
      region: 'COLOMBO',
    ),

    // MADAPATHA REGION
    Dealer(
      accountCode: 'AC2000123306',
      name: 'Madapatha Car Mart',
      surname: 'Car Mart',
      address: '55, Main Street',
      city: 'Madapatha',
      region: 'MADAPATHA',
    ),
    Dealer(
      accountCode: 'AC2000123307',
      name: 'Jayalath Enterprises',
      surname: 'Jayalath',
      address: '8, Lake Road',
      city: 'Piliyandala',
      region: 'MADAPATHA',
    ),
    Dealer(
      accountCode: 'AC2000123308',
      name: 'Kesbewa Auto Zone',
      surname: 'Auto Zone',
      address: '121, Horana Road',
      city: 'Kesbewa',
      region: 'MADAPATHA',
    ),

    // MATHUGAMA REGION
    Dealer(
      accountCode: 'AC2000123309',
      name: 'Mathugama Motors',
      surname: 'Motors',
      address: '33, Agalawatta Road',
      city: 'Mathugama',
      region: 'MATHUGAMA',
    ),
    Dealer(
      accountCode: 'AC2000123310',
      name: 'Fernando Auto Care',
      surname: 'Fernando',
      address: 'Kalutara Road',
      city: 'Wadduwa',
      region: 'MATHUGAMA',
    ),
    Dealer(
      accountCode: 'AC2000123311',
      name: 'Pasdunrata Traders',
      surname: 'Traders',
      address: 'Neboda Junction',
      city: 'Neboda',
      region: 'MATHUGAMA',
    ),

    // // NEGOMBO REGION
    // Dealer(accountCode: 'AC2000123312', name: 'Lagoon View Auto', surname: 'Lagoon View', address: '99, Colombo Road', city: 'Negombo', region: 'NEGOMBO'),
    // Dealer(accountCode: 'AC2000123313', name: 'Katunayake Airport Sales', surname: 'Airport Sales', address: '4, Airport Avenue', city: 'Katunayake', region: 'NEGOMBO'),
    // Dealer(accountCode: 'AC2000123314', name: 'Coastal Car Centre', surname: 'Coastal', address: '150, Chilaw Road', city: 'Kochchikade', region: 'NEGOMBO'),
    // Dealer(accountCode: 'AC2000123315', name: 'Peiris & Brothers', surname: 'Peiris', address: '67, St. Joseph Street', city: 'Negombo', region: 'NEGOMBO'),

    // // YAKKALA REGION
    // Dealer(accountCode: 'AC2000123316', name: 'Yakkala Junction Motors', surname: 'Motors', address: '2, Kandy Road', city: 'Yakkala', region: 'YAKKALA'),
    // Dealer(accountCode: 'AC2000123317', name: 'Gampaha Auto Hub', surname: 'Auto Hub', address: '18, Ja-Ela Road', city: 'Gampaha', region: 'YAKKALA'),
    // Dealer(accountCode: 'AC2000123318', name: 'Siyane Auto Traders', surname: 'Siyane', address: 'Miriswatta', city: 'Gampaha', region: 'YAKKALA'),
    // Dealer(accountCode: 'AC2000123319', name: 'Ranasinghe Car Sales', surname: 'Ranasinghe', address: 'Radawana Road', city: 'Kirindiwela', region: 'YAKKALA'),

    // DAMBULLA REGION
    Dealer(
      accountCode: 'AC2000123320',
      name: 'Golden Rock Motors',
      surname: 'Golden Rock',
      address: 'Kurunegala Road',
      city: 'Dambulla',
      region: 'DAMBULLA',
    ),
    Dealer(
      accountCode: 'AC2000123321',
      name: 'Rangana Traders',
      surname: 'Rangana',
      address: 'Anuradhapura Road',
      city: 'Dambulla',
      region: 'DAMBULLA',
    ),
    Dealer(
      accountCode: 'AC2000123322',
      name: 'Sigiri Auto Mart',
      surname: 'Sigiri',
      address: 'Kimbissa Junction',
      city: 'Sigiriya',
      region: 'DAMBULLA',
    ),

    // D'KANDIYA REGION (Anuradhapura/Polonnaruwa Area)
    Dealer(
      accountCode: 'AC2000123323',
      name: 'Rajarata Wheels',
      surname: 'Rajarata',
      address: 'Mihintale Road',
      city: 'Anuradhapura',
      region: 'D\'KANDIYA',
    ),
    Dealer(
      accountCode: 'AC2000123324',
      name: 'Polonnaruwa Auto',
      surname: 'Polonnaruwa',
      address: 'Bendiwewa',
      city: 'Polonnaruwa',
      region: 'D\'KANDIYA',
    ),
    Dealer(
      accountCode: 'AC2000123325',
      name: 'Medirigiriya Motors',
      surname: 'Medirigiriya',
      address: 'Main Street',
      city: 'Medirigiriya',
      region: 'D\'KANDIYA',
    ),
    Dealer(
      accountCode: 'AC2000123326',
      name: 'Hingurakgoda Sales',
      surname: 'Sales',
      address: 'Airport Road',
      city: 'Hingurakgoda',
      region: 'D\'KANDIYA',
    ),

    // KANDY REGION
    Dealer(
      accountCode: 'AC2000123327',
      name: 'Kandy Car Sales',
      surname: 'Kandy Sales',
      address: '112, Peradeniya Road',
      city: 'Kandy',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123328',
      name: 'Hill Country Motors',
      surname: 'Hill Country',
      address: '23, William Gopallawa Mawatha',
      city: 'Kandy',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123329',
      name: 'Senkadagala Auto',
      surname: 'Senkadagala',
      address: 'Katugastota Bridge End',
      city: 'Katugastota',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123330',
      name: 'Digana Vehicle Mart',
      surname: 'Vehicle Mart',
      address: 'Victoria Range',
      city: 'Digana',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123331',
      name: 'Mahaweli Auto Traders',
      surname: 'Mahaweli',
      address: 'Gurudeniya',
      city: 'Kandy',
      region: 'KANDY',
    ),

    // KURUNEGALA REGION
    Dealer(
      accountCode: 'AC2000123332',
      name: 'Wayamba Auto Zone',
      surname: 'Wayamba',
      address: '88, Negombo Road',
      city: 'Kurunegala',
      region: 'KURUNEGALA',
    ),
    Dealer(
      accountCode: 'AC2000123333',
      name: 'Rideemaliyadda Motors',
      surname: 'Rideemaliyadda',
      address: 'Kandy Road',
      city: 'Melsiripura',
      region: 'KURUNEGALA',
    ),
    Dealer(
      accountCode: 'AC2000123334',
      name: 'Herath Car Sales',
      surname: 'Herath',
      address: 'Puttalam Road',
      city: 'Wariyapola',
      region: 'KURUNEGALA',
    ),
    Dealer(
      accountCode: 'AC2000123335',
      name: 'Athugala Auto Hub',
      surname: 'Athugala',
      address: 'Dambulla Road',
      city: 'Kurunegala',
      region: 'KURUNEGALA',
    ),

    // AMBALANGODA REGION
    Dealer(
      accountCode: 'AC2000123336',
      name: 'Ambalangoda Motors',
      surname: 'Motors',
      address: 'Galle Road',
      city: 'Ambalangoda',
      region: 'AMBALANGODA',
    ),
    Dealer(
      accountCode: 'AC2000123337',
      name: 'Hikkaduwa Tourist Auto',
      surname: 'Tourist Auto',
      address: 'Wewala',
      city: 'Hikkaduwa',
      region: 'AMBALANGODA',
    ),
    Dealer(
      accountCode: 'AC2000123338',
      name: 'Balapitiya River Motors',
      surname: 'River Motors',
      address: 'Main Street',
      city: 'Balapitiya',
      region: 'AMBALANGODA',
    ),

    // DENIYAYA REGION
    Dealer(
      accountCode: 'AC2000123339',
      name: 'Deniyaya Plantation Motors',
      surname: 'Plantation',
      address: 'Rakwana Road',
      city: 'Deniyaya',
      region: 'DENIYAYA',
    ),
    Dealer(
      accountCode: 'AC2000123340',
      name: 'Morawaka Auto Sales',
      surname: 'Auto Sales',
      address: 'Main Street',
      city: 'Morawaka',
      region: 'DENIYAYA',
    ),

    // GALLE REGION
    Dealer(
      accountCode: 'AC2000123341',
      name: 'Galle Fort Auto',
      surname: 'Galle Fort',
      address: 'Lighthouse Street',
      city: 'Galle',
      region: 'GALLE',
    ),
    Dealer(
      accountCode: 'AC2000123342',
      name: 'Unawatuna Beach Motors',
      surname: 'Beach Motors',
      address: 'Yaddehimulla Road',
      city: 'Unawatuna',
      region: 'GALLE',
    ),
    Dealer(
      accountCode: 'AC2000123343',
      name: 'Karapitiya Auto Traders',
      surname: 'Karapitiya',
      address: 'Hirimbura Road',
      city: 'Galle',
      region: 'GALLE',
    ),
    Dealer(
      accountCode: 'AC2000123344',
      name: 'Richmond Hill Sales',
      surname: 'Richmond',
      address: 'Richmond Hill Road',
      city: 'Galle',
      region: 'GALLE',
    ),

    // MATARA REGION
    Dealer(
      accountCode: 'AC2000123345',
      name: 'Matara City Wheels',
      surname: 'City Wheels',
      address: 'Anagarika Dharmapala Mawatha',
      city: 'Matara',
      region: 'MATARA',
    ),
    Dealer(
      accountCode: 'AC2000123346',
      name: 'Weligama Bay Motors',
      surname: 'Weligama Bay',
      address: 'Galle Road',
      city: 'Weligama',
      region: 'MATARA',
    ),
    Dealer(
      accountCode: 'AC2000123347',
      name: 'Nilwala Auto Mart',
      surname: 'Nilwala',
      address: 'Akuressa Road',
      city: 'Matara',
      region: 'MATARA',
    ),
    Dealer(
      accountCode: 'AC2000123348',
      name: 'Mirissa Auto Sales',
      surname: 'Mirissa',
      address: 'Beach Road',
      city: 'Mirissa',
      region: 'MATARA',
    ),

    // RANNA REGION
    Dealer(
      accountCode: 'AC2000123349',
      name: 'Ranna Rural Motors',
      surname: 'Rural Motors',
      address: 'Weeraketiya Road',
      city: 'Ranna',
      region: 'RANNA',
    ),
    Dealer(
      accountCode: 'AC2000123350',
      name: 'Hambantota Port Auto',
      surname: 'Port Auto',
      address: 'Main Street',
      city: 'Hambantota',
      region: 'RANNA',
    ),
    Dealer(
      accountCode: 'AC2000123351',
      name: 'Tangalle Beach Traders',
      surname: 'Beach Traders',
      address: 'Goyambokka',
      city: 'Tangalle',
      region: 'RANNA',
    ),
    Dealer(
      accountCode: 'AC2000123352',
      name: 'Tissamaharama Auto',
      surname: 'Tissa',
      address: 'Kataragama Road',
      city: 'Tissamaharama',
      region: 'RANNA',
    ),

    // AMPARA REGION
    Dealer(
      accountCode: 'AC2000123353',
      name: 'Ampara City Auto',
      surname: 'Ampara Auto',
      address: 'D.S. Senanayake Street',
      city: 'Ampara',
      region: 'AMPARA',
    ),
    Dealer(
      accountCode: 'AC2000123354',
      name: 'Uhana Motors',
      surname: 'Uhana',
      address: 'Main Road',
      city: 'Uhana',
      region: 'AMPARA',
    ),
    Dealer(
      accountCode: 'AC2000123355',
      name: 'Akkaraipattu Traders',
      surname: 'Traders',
      address: 'Main Street',
      city: 'Akkaraipattu',
      region: 'AMPARA',
    ),

    // BATTICALOA REGION
    Dealer(
      accountCode: 'AC2000123356',
      name: 'Eastern Auto Hub',
      surname: 'Eastern Hub',
      address: '15, Central Road',
      city: 'Batticaloa',
      region: 'BATTICALOA',
    ),
    Dealer(
      accountCode: 'AC2000123357',
      name: 'Kalkudah Beach Motors',
      surname: 'Kalkudah',
      address: 'Pasikudah Road',
      city: 'Kalkudah',
      region: 'BATTICALOA',
    ),
    Dealer(
      accountCode: 'AC2000123358',
      name: 'Kattankudy Sales',
      surname: 'Sales',
      address: 'Main Street',
      city: 'Kattankudy',
      region: 'BATTICALOA',
    ),

    // TRINCOMALEE REGION
    Dealer(
      accountCode: 'AC2000123359',
      name: 'Trinco Auto Mart',
      surname: 'Trinco Mart',
      address: 'Dockyard Road',
      city: 'Trincomalee',
      region: 'TRINCOMALEE',
    ),
    Dealer(
      accountCode: 'AC2000123360',
      name: 'Nilaveli Motors',
      surname: 'Nilaveli',
      address: 'Beach Road',
      city: 'Nilaveli',
      region: 'TRINCOMALEE',
    ),
    Dealer(
      accountCode: 'AC2000123361',
      name: 'Kanthale Sugar Auto',
      surname: 'Sugar Auto',
      address: 'Main Street',
      city: 'Kanthale',
      region: 'TRINCOMALEE',
    ),

    // ANURADHAPURA REGION
    Dealer(
      accountCode: 'AC2000123362',
      name: 'Anuradhapura Sacred Motors',
      surname: 'Sacred Motors',
      address: '210/B, Jaya Mawatha',
      city: 'Anuradhapura',
      region: 'ANURADHAPURA',
    ),
    Dealer(
      accountCode: 'AC2000123363',
      name: 'Nuwarawewa Auto',
      surname: 'Nuwarawewa',
      address: 'New Town',
      city: 'Anuradhapura',
      region: 'ANURADHAPURA',
    ),
    Dealer(
      accountCode: 'AC2000123364',
      name: 'Jayanthi Mawatha Sales',
      surname: 'Sales',
      address: 'Jayanthi Mawatha',
      city: 'Anuradhapura',
      region: 'ANURADHAPURA',
    ),

    // CHILAW REGION
    Dealer(
      accountCode: 'AC2000123365',
      name: 'Chilaw City Traders',
      surname: 'Chilaw Traders',
      address: 'Colombo Road',
      city: 'Chilaw',
      region: 'CHILAW',
    ),
    Dealer(
      accountCode: 'AC2000123366',
      name: 'Puttalam Lagoon Motors',
      surname: 'Puttalam',
      address: 'Kurunegala Road',
      city: 'Puttalam',
      region: 'CHILAW',
    ),
    Dealer(
      accountCode: 'AC2000123367',
      name: 'Wennappuwa Auto',
      surname: 'Wennappuwa',
      address: 'Main Street',
      city: 'Wennappuwa',
      region: 'CHILAW',
    ),
    Dealer(
      accountCode: 'AC2000123368',
      name: 'Dankotuwa Motors',
      surname: 'Dankotuwa',
      address: 'Negombo Road',
      city: 'Dankotuwa',
      region: 'CHILAW',
    ),

    // JAFFNA REGION
    Dealer(
      accountCode: 'AC2000123369',
      name: 'Northern Wheels',
      surname: 'Northern',
      address: '50, Stanley Road',
      city: 'Jaffna',
      region: 'JAFFNA',
    ),
    Dealer(
      accountCode: 'AC2000123370',
      name: 'Point Pedro Auto',
      surname: 'Point Pedro',
      address: 'Main Street',
      city: 'Point Pedro',
      region: 'JAFFNA',
    ),
    Dealer(
      accountCode: 'AC2000123371',
      name: 'Nallur Kovil Traders',
      surname: 'Nallur',
      address: 'Kovil Road',
      city: 'Nallur',
      region: 'JAFFNA',
    ),
    Dealer(
      accountCode: 'AC2000123372',
      name: 'Yarlpanam Motors',
      surname: 'Yarlpanam',
      address: 'KKS Road',
      city: 'Jaffna',
      region: 'JAFFNA',
    ),

    // VAVUNIYA REGION
    Dealer(
      accountCode: 'AC2000123373',
      name: 'Vavuniya Vehicle Mart',
      surname: 'Vehicle Mart',
      address: 'Kandy Road',
      city: 'Vavuniya',
      region: 'VAVUNIYA',
    ),
    Dealer(
      accountCode: 'AC2000123374',
      name: 'Mannar Auto Sales',
      surname: 'Mannar Auto',
      address: 'Thalaimannar Road',
      city: 'Mannar',
      region: 'VAVUNIYA',
    ),
    Dealer(
      accountCode: 'AC2000123375',
      name: 'Wanni Auto Hub',
      surname: 'Wanni Hub',
      address: 'Horowpathana Road',
      city: 'Vavuniya',
      region: 'VAVUNIYA',
    ),

    // BADULLA REGION
    Dealer(
      accountCode: 'AC2000123376',
      name: 'Uva Motors',
      surname: 'Uva Motors',
      address: 'No 34, Lower Street',
      city: 'Badulla',
      region: 'BADULLA',
    ),
    Dealer(
      accountCode: 'AC2000123377',
      name: 'Bandarawela Highland Auto',
      surname: 'Highland Auto',
      address: 'Welimada Road',
      city: 'Bandarawela',
      region: 'BADULLA',
    ),
    Dealer(
      accountCode: 'AC2000123378',
      name: 'Ella Gap Traders',
      surname: 'Ella Gap',
      address: 'Main Street',
      city: 'Ella',
      region: 'BADULLA',
    ),
    Dealer(
      accountCode: 'AC2000123379',
      name: 'Mahiyanganaya Motors',
      surname: 'Mahiyanganaya',
      address: 'Badulla Road',
      city: 'Mahiyanganaya',
      region: 'BADULLA',
    ),

    // MONARAGALA REGION
    Dealer(
      accountCode: 'AC2000123380',
      name: 'Monaragala Best Cars',
      surname: 'Best Cars',
      address: 'Wellawaya Road',
      city: 'Monaragala',
      region: 'MONARAGALA',
    ),
    Dealer(
      accountCode: 'AC2000123381',
      name: 'Buttala Sugar City Auto',
      surname: 'Sugar City',
      address: 'Kataragama Road',
      city: 'Buttala',
      region: 'MONARAGALA',
    ),
    Dealer(
      accountCode: 'AC2000123382',
      name: 'Siyambalanduwa Traders',
      surname: 'Traders',
      address: 'Pottuvil Road',
      city: 'Siyambalanduwa',
      region: 'MONARAGALA',
    ),

    // N'ELIYA REGION
    Dealer(
      accountCode: 'AC2000123383',
      name: 'Nuwara Eliya Lake Auto',
      surname: 'Lake Auto',
      address: 'Grand Hotel Road',
      city: 'Nuwara Eliya',
      region: 'N\'ELIYA',
    ),
    Dealer(
      accountCode: 'AC2000123384',
      name: 'Hatton Tea Country Motors',
      surname: 'Tea Country',
      address: 'Main Street',
      city: 'Hatton',
      region: 'N\'ELIYA',
    ),
    Dealer(
      accountCode: 'AC2000123385',
      name: 'Talawakele Highland Wheels',
      surname: 'Highland',
      address: 'Avissawella Road',
      city: 'Talawakele',
      region: 'N\'ELIYA',
    ),
    Dealer(
      accountCode: 'AC2000123386',
      name: 'Welimada Veggie Auto',
      surname: 'Veggie Auto',
      address: 'Uva Paranagama Road',
      city: 'Welimada',
      region: 'N\'ELIYA',
    ),

    // EXTRA DATA TO REACH 100
    Dealer(
      accountCode: 'AC2000123387',
      name: 'Jayawardena Auto',
      surname: 'Jayawardena',
      address: '55, Reid Avenue',
      city: 'Colombo 07',
      region: 'COLOMBO',
    ),
    Dealer(
      accountCode: 'AC2000123388',
      name: 'Ratnapura Gem Traders',
      surname: 'Gem Traders',
      address: 'Main Street',
      city: 'Ratnapura',
      region: 'MATHUGAMA',
    ), // Assuming Sabaragamuwa falls here
    Dealer(
      accountCode: 'AC2000123389',
      name: 'Kegalle Rock Motors',
      surname: 'Rock Motors',
      address: 'Kandy Road',
      city: 'Kegalle',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123390',
      name: 'Avissawella Auto',
      surname: 'Avissawella',
      address: 'Main Road',
      city: 'Avissawella',
      region: 'MADAPATHA',
    ),
    Dealer(
      accountCode: 'AC2000123391',
      name: 'Panadura Town Sales',
      surname: 'Town Sales',
      address: 'Galle Road',
      city: 'Panadura',
      region: 'MATHUGAMA',
    ),
    Dealer(
      accountCode: 'AC2000123392',
      name: 'Kalutara Bridge Auto',
      surname: 'Bridge Auto',
      address: 'Main Street',
      city: 'Kalutara',
      region: 'MATHUGAMA',
    ),
    Dealer(
      accountCode: 'AC2000123393',
      name: 'Horana Auto',
      surname: 'Horana',
      address: 'Panadura Road',
      city: 'Horana',
      region: 'MADAPATHA',
    ),
    Dealer(
      accountCode: 'AC2000123394',
      name: 'Kuliyapitiya Motors',
      surname: 'Kuliyapitiya',
      address: 'Main Street',
      city: 'Kuliyapitiya',
      region: 'KURUNEGALA',
    ),
    Dealer(
      accountCode: 'AC2000123395',
      name: 'Matale Spice Auto',
      surname: 'Spice Auto',
      address: 'Kandy Road',
      city: 'Matale',
      region: 'DAMBULLA',
    ),
    Dealer(
      accountCode: 'AC2000123396',
      name: 'Gampola Bridge Motors',
      surname: 'Gampola',
      address: 'Nawalapitiya Road',
      city: 'Gampola',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123397',
      name: 'Nawalapitiya Highland Auto',
      surname: 'Highland',
      address: 'Main Street',
      city: 'Nawalapitiya',
      region: 'KANDY',
    ),
    Dealer(
      accountCode: 'AC2000123398',
      name: 'Ambalantota Auto',
      surname: 'Ambalantota',
      address: 'Main Street',
      city: 'Ambalantota',
      region: 'RANNA',
    ),
    Dealer(
      accountCode: 'AC2000123399',
      name: 'Kilinochchi Motors',
      surname: 'Kilinochchi',
      address: 'A9 Road',
      city: 'Kilinochchi',
      region: 'VAVUNIYA',
    ),
    Dealer(
      accountCode: 'AC2000123400',
      name: 'Mullaitivu Auto',
      surname: 'Mullaitivu',
      address: 'Main Street',
      city: 'Mullaitivu',
      region: 'VAVUNIYA',
    ),
  ];

  static final List<Reference> _references = [
    // Additional reference data
    Reference(refId: 'REF001', remark: 'R1'),
    Reference(refId: 'REF002', remark: ''),
    Reference(refId: 'REF003', remark: 'R3'),
    Reference(refId: 'REF004', remark: ''),
    Reference(refId: 'REF005', remark: ''),
  ];

  static final List<Invoice> _invoices = [
    Invoice(
      date: '07/07/2025',
      invoiceNumber: 'MIN00205',
      customer: 'ABC Motors',
      totalValue: 27000.00,
    ),
    Invoice(
      date: '08/07/2025',
      invoiceNumber: 'MIN00206',
      customer: 'XYZ Supplies',
      totalValue: 15500.50,
    ),
    Invoice(
      date: '08/07/2025',
      invoiceNumber: 'MIN00207',
      customer: 'John Doe',
      totalValue: 9800.75,
    ),
    Invoice(
      date: '09/07/2025',
      invoiceNumber: 'MIN00208',
      customer: 'Jane Smith',
      totalValue: 32000.00,
    ),
    Invoice(
      date: '10/07/2025',
      invoiceNumber: 'MIN00209',
      customer: 'Global Corp',
      totalValue: 54300.20,
    ),
  ];

  static final List<TinData> _tins = [
    const TinData(tinNumber: 'TIN987654321', totalValue: 1500.75),
    const TinData(tinNumber: 'TIN123456789', totalValue: 899.99),
    const TinData(tinNumber: 'TIN555555555', totalValue: 12500.00),
    const TinData(tinNumber: 'TIN314159265', totalValue: 432.50),
  ];

  static final List<Region> _regions = [
    Region(region: 'COLOMBO', head: 'Mr. Chamila Galketiya'),
    Region(region: 'MADAPATHA', head: 'Mr. Chamila Galketiya'),
    Region(region: 'MATHUGAMA', head: 'Mr. Chamila Galketiya'),
    Region(region: 'NEGOMBO', head: 'Mr. Chamila Galketiya'),
    Region(region: 'YAKKALA', head: 'Mr. Chamila Galketiya'),
    Region(region: 'DAMBULLA', head: 'Mr. Gayan Senaviratna'),
    Region(region: 'D\'KANDIYA', head: 'Mr. Gayan Senaviratna'),
    Region(region: 'KANDY', head: 'Mr. Gayan Senaviratna'),
    Region(region: 'KURUNEGALA', head: 'Mr. Gayan Senaviratna'),
    Region(region: 'AMBALANGODA', head: 'Mr. Priyantha Gamage'),
    Region(region: 'DENIYAYA', head: 'Mr. Priyantha Gamage'),
    Region(region: 'GALLE', head: 'Mr. Priyantha Gamage'),
    Region(region: 'MATARA', head: 'Mr. Priyantha Gamage'),
    Region(region: 'RANNA', head: 'Mr. Priyantha Gamage'),
    Region(region: 'AMPARA', head: 'Mr. Mahalingam Ravichandran'),
    Region(region: 'BATTICALOA', head: 'Mr. Mahalingam Ravichandran'),
    Region(region: 'TRINCOMALEE', head: 'Mr. Mahalingam Ravichandran'),
    Region(region: 'ANURADHAPURA', head: 'Mr. Nadaraja Sadheen'),
    Region(region: 'CHILAW', head: 'Mr. Nadaraja Sadheen'),
    Region(region: 'JAFFNA', head: 'Mr. Nadaraja Sadheen'),
    Region(region: 'VAVUNIYA', head: 'Mr. Nadaraja Sadheen'),
    Region(region: 'BADULLA', head: 'Mr. Ruwan Sameera'),
    Region(region: 'MONARAGALA', head: 'Mr. Ruwan Sameera'),
    Region(region: 'N\'ELIYA', head: 'Mr. Ruwan Sameera'),
  ];

  static final List<ReturnItem> _returnItems = [
    ReturnItem(partNo: 'AC2000123230', requestQty: 5),
    ReturnItem(partNo: 'AC2000123266', requestQty: 8),
    ReturnItem(partNo: 'AC2000123267', requestQty: 7),
    ReturnItem(partNo: 'PN-1122-AB', requestQty: 12),
    ReturnItem(partNo: 'PN-1133-CD', requestQty: 3),
    ReturnItem(partNo: 'XY-9988-ZZ', requestQty: 18),
    ReturnItem(partNo: 'AC2000124001', requestQty: 2),
    ReturnItem(partNo: 'AC2000124005', requestQty: 11),
    ReturnItem(partNo: 'AC2000124019', requestQty: 6),
    ReturnItem(partNo: 'HW-5500-FG', requestQty: 9),
    ReturnItem(partNo: 'HW-5501-FH', requestQty: 14),
    ReturnItem(partNo: 'HW-5502-FI', requestQty: 4),
    ReturnItem(partNo: 'AC3001005001', requestQty: 1),
    ReturnItem(partNo: 'AC3001005002', requestQty: 15),
    ReturnItem(partNo: 'PN-3344-GH', requestQty: 7),
    ReturnItem(partNo: 'PN-3355-IJ', requestQty: 10),
    ReturnItem(partNo: 'XY-7766-WX', requestQty: 13),
    ReturnItem(partNo: 'XY-7767-WY', requestQty: 5),
    ReturnItem(partNo: 'AC2000125555', requestQty: 19),
    ReturnItem(partNo: 'AC2000125556', requestQty: 20),
    ReturnItem(partNo: 'HW-6600-JK', requestQty: 8),
  ];
  static final List<Part> _parts = [
    Part(id: 'p1', partNo: 'AC2000123230', requestQty: 2, price: 12000.00),
    Part(id: 'p2', partNo: 'AC2000123231', requestQty: 5, price: 5500.50),
    Part(id: 'p3', partNo: 'AC2000123232', requestQty: 1, price: 8000.00),
    Part(id: 'p4', partNo: 'AC2000123342', requestQty: 1, price: 1000.00),
    Part(id: 'p5', partNo: 'AC2000123932', requestQty: 6, price: 3000.00),
    Part(id: 'p6', partNo: 'AC2000123937', requestQty: 6, price: 300.00),
    // Generating more parts for a richer list
    Part(id: 'p7', partNo: 'HW-5500-FG', requestQty: 10, price: 750.00),
    Part(id: 'p8', partNo: 'HW-5501-FH', requestQty: 3, price: 1500.25),
    Part(id: 'p9', partNo: 'PN-3344-GH', requestQty: 8, price: 999.99),
    Part(id: 'p10', partNo: 'PN-3355-IJ', requestQty: 4, price: 250.00),
    Part(id: 'p11', partNo: 'XY-7766-WX', requestQty: 12, price: 6500.00),
    Part(id: 'p12', partNo: 'XY-9988-ZZ', requestQty: 7, price: 125.50),
  ];
//
   static final List<Bank> _banks = [
    Bank(bankCode: '7010', bankName: 'Bank of Ceylon'),
    Bank(bankCode: '7056', bankName: 'Commercial Bank of Ceylon'),
    Bank(bankCode: '7278', bankName: 'Sampath Bank'),
    Bank(bankCode: '7083', bankName: 'Hatton National Bank'),
    Bank(bankCode: '7135', bankName: 'Peoples Bank'),
  ];

  static final List<BankBranch> _branches = [
    // Bank of Ceylon Branches
    BankBranch(bankCode: '7010', bankName: 'Bank of Ceylon', branchCode: '001', branchName: 'Bank of Ceylon - Colombo'),
    BankBranch(bankCode: '7010', bankName: 'Bank of Ceylon', branchCode: '002', branchName: 'Bank of Ceylon - Kandy'),
    BankBranch(bankCode: '7010', bankName: 'Bank of Ceylon', branchCode: '003', branchName: 'Bank of Ceylon - Galle'),
    BankBranch(bankCode: '7010', bankName: 'Bank of Ceylon', branchCode: '004', branchName: 'Bank of Ceylon - Jaffna'),

    // Commercial Bank of Ceylon Branches
    BankBranch(bankCode: '7056', bankName: 'Commercial Bank of Ceylon', branchCode: '001', branchName: 'Commercial Bank - Colombo'),
    BankBranch(bankCode: '7056', bankName: 'Commercial Bank of Ceylon', branchCode: '002', branchName: 'Commercial Bank - Kandy'),
    BankBranch(bankCode: '7056', bankName: 'Commercial Bank of Ceylon', branchCode: '003', branchName: 'Commercial Bank - Galle'),
    BankBranch(bankCode: '7056', bankName: 'Commercial Bank of Ceylon', branchCode: '004', branchName: 'Commercial Bank - Matara'),

    // Sampath Bank Branches
    BankBranch(bankCode: '7278', bankName: 'Sampath Bank', branchCode: '001', branchName: 'Sampath Bank - Colombo'),
    BankBranch(bankCode: '7278', bankName: 'Sampath Bank', branchCode: '002', branchName: 'Sampath Bank - Gampaha'),
    BankBranch(bankCode: '7278', bankName: 'Sampath Bank', branchCode: '003', branchName: 'Sampath Bank - Kurunegala'),
    BankBranch(bankCode: '7278', bankName: 'Sampath Bank', branchCode: '004', branchName: 'Sampath Bank - Panadura'),

    // Hatton National Bank Branches
    BankBranch(bankCode: '7083', bankName: 'Hatton National Bank', branchCode: '001', branchName: 'HNB - Colombo'),
    BankBranch(bankCode: '7083', bankName: 'Hatton National Bank', branchCode: '002', branchName: 'HNB - Kandy'),
    BankBranch(bankCode: '7083', bankName: 'Hatton National Bank', branchCode: '003', branchName: 'HNB - Galle'),
    BankBranch(bankCode: '7083', bankName: 'Hatton National Bank', branchCode: '004', branchName: 'HNB - Negombo'),

    // Peoples Bank Branches
    BankBranch(bankCode: '7135', bankName: 'Peoples Bank', branchCode: '001', branchName: 'Peoples Bank - Colombo'),
    BankBranch(bankCode: '7135', bankName: 'Peoples Bank', branchCode: '002', branchName: 'Peoples Bank - Nugegoda'),
    BankBranch(bankCode: '7135', bankName: 'Peoples Bank', branchCode: '003', branchName: 'Peoples Bank - Gampaha'),
    BankBranch(bankCode: '7135', bankName: 'Peoples Bank', branchCode: '004', branchName: 'Peoples Bank - Anuradhapura'),
  ];

  static List<Bank> get banks => _banks;
  static List<BankBranch> get branches => _branches;
  static List<Dealer> get dealers => _dealers;
  static List<Reference> get references => _references;
  static List<Invoice> get invoices => _invoices;
  static List<TinData> get tins => _tins;
  static List<Region> get regions => _regions;
  static List<ReturnItem> get returnItems => _returnItems;
  static List<Part> get parts => _parts;
}
