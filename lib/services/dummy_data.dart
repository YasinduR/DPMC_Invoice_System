import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:myapp/models/Tin_invoice_model.dart';
import 'package:myapp/models/assignee_model.dart';
import 'package:myapp/models/attendance_model.dart';
import 'package:myapp/models/bank_branch_model.dart';
import 'package:myapp/models/bank_model.dart';
import 'package:myapp/models/dealer_model.dart';
import 'package:myapp/models/dispatch_note_model.dart';
import 'package:myapp/models/employee_model.dart';
import 'package:myapp/models/invoice_model.dart';
import 'package:myapp/models/menu_model.dart';
import 'package:myapp/models/part_model.dart';
import 'package:myapp/models/permission_model.dart';
import 'package:myapp/models/receipt_model.dart';
import 'package:myapp/models/reference_model.dart';
import 'package:myapp/models/region_model.dart';
import 'package:myapp/models/return_item_model.dart';
import 'package:myapp/models/return_request_model.dart';
import 'package:myapp/models/return_save_model.dart';
import 'package:myapp/models/role_model.dart';
import 'package:myapp/models/screen_model.dart';
import 'package:myapp/models/tin_model.dart';
import 'package:myapp/models/user_model.dart';
//import 'package:permission_handler/permission_handler.dart';

//// IMPORTANT :  This works as the DataBase remove later

class DummyData {

  static final dummyInv1 = InvoiceSave(
    invoiceNumber: "DN20260224002",
    tinNo: "PTIBDM202602170463",
    orderNo: "PADC2026021605834",
    payOndel: "N",
    route: "R01",

    dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
    dealerVatNo: "VAT123456789",
    dealerAddress: "No 199/4 Kanaththa Road, Molligoda, Wadduwa",
    dealerId: "AC2018023904",

    userId: "USR01",

    parts: [
      Part(
        id: '1',
        partNo: "03100335",
        description: "BEARING NEEDLE [SCE188] - MAINSHAFT",
        requestQty: 10,
        price: 21.3,
      ),
      Part(
        id: '2',
        partNo: "24171094",
        description: "SHOCKABSORBER ASSEMBLY - REAR",
        requestQty: 6,
        price: 4500.00,
      ),
      Part(
        id: '3',
        partNo: "39132420",
        description: "BEARING BALL [6305] - CRANKSHAFT",
        requestQty: 5,
        price: 320.50,
      ),
      Part(
        id: '4',
        partNo: "39193120",
        description: "BEARING BALL - 28 X 68 X 18",
        requestQty: 4,
        price: 275.75,
      ),
      Part(
        id: '5',
        partNo: "AA101108",
        description: "GEAR SELECTER",
        requestQty: 5,
        price: 1890.00,
      ),
      Part(
        id: '6',
        partNo: "AA101481",
        description: "INNER CLUTCH RELEASE COMPLETE",
        requestQty: 5,
        price: 2150.00,
      ),
      Part(
        id: '7',
        partNo: "AB171044",
        description: "SHOCKABSORBER ASSEMBLY COMPLETE - FRONT",
        requestQty: 4,
        price: 5600.00,
      ),
      Part(
        id: '8',
        partNo: "AS00304013",
        description: "N/A",
        requestQty: 50,
        price: 12.00,
      ),
      Part(
        id: '9',
        partNo: "DS101277",
        description: "TENSIONER ASSEMBLY",
        requestQty: 5,
        price: 1340.00,
      ),
    ],
    invoiceAmount: 100000.00,
    invoiceTime: DateTime.now(),
  );

  static final dummyInv2 = InvoiceSave(
    invoiceNumber: "DN20260224001",
    tinNo: "PTIBDM202602170463",
    orderNo: "PADC2026021605834",
    payOndel: "N",
    route: "R01",

    dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
    dealerVatNo: "VAT123456789",
    dealerAddress: "No 199/4 Kanaththa Road, Molligoda, Wadduwa",
    dealerId: "AC2018023904",

    userId: "USR01",

    parts: [
      Part(
        id: '1',
        partNo: "03100335",
        description: "BEARING NEEDLE [SCE188] - MAINSHAFT",
        requestQty: 10,
        price: 21.3,
      ),
      Part(
        id: '2',
        partNo: "24171094",
        description: "SHOCKABSORBER ASSEMBLY - REAR",
        requestQty: 6,
        price: 4500.00,
      ),
      Part(
        id: '7',
        partNo: "39132420",
        description: "BEARING BALL [6305] - CRANKSHAFT",
        requestQty: 5,
        price: 320.50,
      ),
      Part(
        id: '4',
        partNo: "39193120",
        description: "BEARING BALL - 28 X 68 X 18",
        requestQty: 4,
        price: 275.75,
      ),
      Part(
        id: '5',
        partNo: "AA101108",
        description: "GEAR SELECTER",
        requestQty: 5,
        price: 1890.00,
      ),
    ],
    invoiceAmount: 100000.00,
    invoiceTime: DateTime.now(),
  );

  static final dummyRec1 = Receipt(
    dealerName: "Star Distributors (Pvt) Ltd",
    userId: "2619",
    receiptNo: 'TestS112111',
    receiptTime: DateTime.now(),
    dealerCode: 'TestS112111',
    chequeNumber: 'CH1234567',
    chequeAmount: 45200.50,
    chequeDate: DateTime.now(),
    bankCode: '7010',
    branchCode: '001',
    branchName: 'Bank of Ceylon - Colombo',
    tins: [
      TinInvoice(
        tinNo: 'TINBDM2025011500101',
        mobileInvNo: 'MIN0020512201400010',
        invAmount: 45200.50,
        paymentOnDeliveryStatus: 'Y',
        dealerAccCode: 'AC2000123306',
      ),
    ],
    creditNotes: [],
  );

  static final dummyRec2 = Receipt(
    dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
    userId: "2619",
    receiptNo: 'TestS112112',
    receiptTime: DateTime.now(),
    dealerCode: 'TestS112111',
    chequeNumber: '',
    chequeAmount: 45200.50,
    chequeDate: DateTime.now(),
    bankCode: '7010',
    branchCode: '001',
    branchName: 'Bank of Ceylon - Colombo',
    tins: [
      TinInvoice(
        tinNo: 'TINBDM2025011500101',
        mobileInvNo: 'MIN0020512201400010',
        invAmount: 45200.50,
        paymentOnDeliveryStatus: 'Y',
        dealerAccCode: 'AC2000123306',
      ),
    ],
    creditNotes: [],
  );

  static final dummyRec3 = Receipt(
    dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
    userId: "2619",
    receiptNo: 'TestS112113',
    receiptTime: DateTime.now(),
    dealerCode: 'TestS112111',
    chequeNumber: '',
    chequeAmount: 45200.50,
    chequeDate: DateTime.now(),
    bankCode: '7010',
    branchCode: '001',
    branchName: 'Bank of Ceylon - Colombo',
    tins: [
      TinInvoice(
        tinNo: 'TINBDM2025011500101',
        mobileInvNo: 'MIN0020512201400010',
        invAmount: 45200.50,
        paymentOnDeliveryStatus: 'Y',
        dealerAccCode: 'AC2000123306',
      ),
    ],
    creditNotes: [],
  );

  // Added by Darshan R on 23/03/2026
  static final dummyDispatchNote1 = DispatchNoteSave(
    dispatchNumber: "ADN20260323001",
    tins: [
      TinData(
        tinNumber: 'TIN987654321',
        orderNumber: 'PADC202510250001',
        totalValue: 1500.75,
        paymentStatus: 'P',
        dealercode: 'AC2000123306',
        payOnDel: 'N',
        bagCount: 2,
        tagCount: 4,
        plasticBCount: 1,
        remark: 'Handle with care',
        parts: [],
      ),
    ], // Add sample TinData if needed
    route: "R01",
    dealerName: "Star Enterprises and Distributors (Pvt) Ltd",
    dealerVatNo: "VAT123456789",
    dealerAddress: "No 199/4 Kanaththa Road, Molligoda, Wadduwa",
    dealerId: "AC2018023904",
    userId: "USR01",
    dispatchTime: DateTime.now(),
  );

  static final List<Receipt> _sessionReceipts = [dummyRec1];
  static final List<Return> _sessionReturns = [];
  //static final List<ReturnRequest> _returnRequest = [];

  static final List<InvoiceSave> _sessionInvoices = [dummyInv2, dummyInv1];
  static final List<DispatchNoteSave> _sessionDispatchNotes = [
    dummyDispatchNote1,
  ];
  //static final List<Attendance> _attendance = [];

  static final List<Attendance> _attendance = generateDummyAttendanceData(
    userId: "8108",
    numberOfWorkingDays: 30,
  );
  static final List<Employee> _employees = [
    Employee(
      id: '2619',
      name: 'YASINDU GANEGODA',
      compName: 'D P INFOTECH PRIVATE LIMITED',
    ),
    Employee(
      id: '8108',
      name: 'NIMESH KALPANA',
      compName: 'D P INFOTECH PRIVATE LIMITED',
    ),
    Employee(
      id: '1122',
      name: 'SACHITH DANANJAYA',
      compName: 'D P INFOTECH PRIVATE LIMITED',
    ),
    Employee(
      id: '2896',
      name: 'DARSHAN RAVICHANDRAN',
      compName: 'D P INFOTECH PRIVATE LIMITED',
    ),
  ];

  static final List<Menu> _menus = [
    Menu(MenuId: '01', MenuName: 'Sales'),
    Menu(MenuId: '02', MenuName: 'Admin'),
    Menu(MenuId: '03', MenuName: 'Supervisor'),
  ];

  static final List<Assignee> _assignees = [
Assignee(
    supervisorId: '1122',
    assigneeId: '2619',
    name: 'Yasindu Ganegoda',
    dealerListAssigned: [
      'AC2000123306', // Madapatha Car Mart
      'AC2000123307', // Jayalath Enterprises
      'AC2000123308', // Kesbewa Auto Zone
    ],
  ),
  Assignee(
    supervisorId: '1122',
    assigneeId: '2896',
    name: 'Darshan Ravichandran',
    dealerListAssigned: [
      'AC2000123301', // Perera & Sons Motors
      'AC2000123302', // Colombo Auto Traders
      'AC2000123303', // Capital Wheels
      'AC2000123304', // De Silva Car Sales
      'AC2000123305', // Metro Vehicle Centre
    ]),
  ];

  static final List<Screen> _screens = [
    // Non-menu screens
    Screen(
      screenId: '001',
      screenName: 'login',
      menuId: 'N/A',
      title: 'Login',
      iconName: 'login',
    ),
    Screen(
      screenId: '002',
      screenName: 'mainMenu',
      menuId: 'N/A',
      title: 'Main Menu',
      iconName: 'apps',
    ),
    Screen(
      screenId: '013',
      screenName: 'forgetPassword',
      menuId: 'N/A',
      title: 'Forget Password',
      iconName: 'lock_open',
    ),

    // Menu screens
    Screen(
      screenId: '003',
      screenName: 'setupPrint',
      menuId: '01',
      title: 'Setup Print',
      iconName: 'settings',
    ),
    Screen(
      screenId: '004',
      screenName: 'invoice',
      menuId: '01',
      title: 'Invoice',
      iconName: 'receipt_long',
    ),
    Screen(
      screenId: '005',
      screenName: 'printInvoice',
      menuId: '01',
      title: 'Print Invoice',
      iconName: 'print',
    ),
    Screen(
      screenId: '006',
      screenName: 'profile',
      menuId: '01',
      title: 'Profile',
      iconName: 'person',
    ),
    // Screen(
    //   screenId: '007',
    //   screenName: 'testNotify',
    //   menuId: '01',
    //   title: 'Test',
    //   iconName: 'alarm',
    // ),
    Screen(
      screenId: '008',
      screenName: 'receipt',
      menuId: '01',
      title: 'Receipt',
      iconName: 'article',
    ),
    Screen(
      screenId: '009',
      screenName: 'returns',
      menuId: '01',
      title: 'Returns',
      iconName: 'assignment_return',
    ),
    Screen(
      screenId: '010',
      screenName: 'reprint',
      menuId: '01',
      title: 'Re-Print',
      iconName: 'replay_circle_filled',
    ),
    Screen(
      screenId: '011',
      screenName: 'region',
      menuId: '01',
      title: 'Route Selection',
      iconName: 'route',
    ),

    Screen(
      screenId: '014',
      screenName: 'attendance',
      menuId: '02',
      title: 'Attendance',
      iconName: 'checklist',
    ),

    Screen(
      screenId: '015',
      screenName: 'securitySetting',
      menuId: '00', // availble under each menu
      title: 'Security',
      iconName: 'security_settings',
    ),
    Screen(
      screenId: '012',
      screenName: 'changePassword',
      menuId: '00', // availble under each menu
      title: 'Change Password',
      iconName: 'lock_reset',
    ),
    // Screen(
    //   screenId: '016',
    //   screenName: 'testPrint',
    //   menuId: '01',
    //   title: 'Test',
    //   iconName: 'print',
    // ),
    Screen(
      screenId: '017',
      screenName: 'returnRequestAdjust',
      menuId: '01',
      title: 'Return Adjustment',
      iconName: 'account_tree_sharp',
    ),

    Screen(
      screenId: '018',
      screenName: 'dispatchNote',
      menuId: '01',
      title: 'Dispatch Note',
      iconName: 'local_shipping',
    ),

    Screen(
      screenId: '019',
      screenName: 'activityLog',
      menuId: '01',
      title: 'Activity Log',
      iconName: 'history',
    ),

    Screen(
      screenId: '020',
      screenName: 'toDoList',
      menuId: '01',
      title: 'To Do List',
      iconName: 'task',
    ),

    Screen(
      screenId: '021',
      screenName: 'chequeSummary',
      menuId: '01',
      title: 'Cheque Summary',
      iconName: 'account_balance',
    ),

    Screen(
      screenId: '022',
      screenName: 'supervisorSummary',
      menuId: '03',
      title: 'Supervisor Summary',
      iconName: 'supervisor_account',
    ),
  ];
  //chequeSummary
  static final List<Role> _roles = [
    Role(roleId: '001', roleName: 'Sales-Man'),
    Role(roleId: '002', roleName: 'Admin'),
    Role(roleId: '003', roleName: 'Supervisor'),
  ];

  static final List<Perm> _perms = [
    Perm(RoleId: '001', ScreenId: '003'), // setupPrint
    Perm(RoleId: '001', ScreenId: '004'), // invoice
    Perm(RoleId: '001', ScreenId: '005'), // printInvoice
    Perm(RoleId: '002', ScreenId: '006'), // profile
    Perm(RoleId: '003', ScreenId: '006'), // profile
    Perm(RoleId: '001', ScreenId: '006'), // profile
    Perm(RoleId: '001', ScreenId: '007'), // testNotify
    Perm(RoleId: '002', ScreenId: '007'), // testNotify
    Perm(RoleId: '001', ScreenId: '008'), // receipt
    Perm(RoleId: '001', ScreenId: '009'), // returns
    Perm(RoleId: '001', ScreenId: '010'), // reprint
    Perm(RoleId: '001', ScreenId: '011'), // region
    Perm(RoleId: '001', ScreenId: '012'), // changePassword
    Perm(RoleId: '002', ScreenId: '012'), // changePassword
    Perm(RoleId: '003', ScreenId: '012'), // changePassword
    Perm(RoleId: '002', ScreenId: '012'), // changePassword
    Perm(RoleId: '002', ScreenId: '014'), // Attendance
    Perm(RoleId: '003', ScreenId: '014'), // Attendance
    Perm(RoleId: '001', ScreenId: '015'), // Security Settings
    Perm(RoleId: '002', ScreenId: '015'), // Security Settings
    Perm(RoleId: '003', ScreenId: '015'), // Security Settings
    Perm(RoleId: '001', ScreenId: '016'), // Test Print
    Perm(RoleId: '002', ScreenId: '016'), // Test Print
    Perm(RoleId: '003', ScreenId: '016'), // Test Print
    Perm(RoleId: '001', ScreenId: '017'), // Return Request Adjustment
    Perm(RoleId: '001', ScreenId: '018'), // Dispatch Note
    Perm(RoleId: '001', ScreenId: '019'), // Actvity Log
    Perm(RoleId: '001', ScreenId: '020'), // To Do List
    Perm(RoleId: '001', ScreenId: '021'), // To Do List
    Perm(RoleId: '003', ScreenId: '022'), // Superviosr Summary
  ];

  static final List<User> _users = [
    User(
      id: '2619',
      username: 'yasindu',
      email: 'yasindu@example.com',
      telephone: '+94771234567',
      password: BCrypt.hashpw('12345', BCrypt.gensalt()),
      roles: ['001'],
      isTemporaryPassword: false,
      passwordUpdatedAt: DateTime.now(),
    ),
    User(
      id: '8108',
      username: 'nimesh',
      email: 'nimesh@example.com',
      telephone: '+94761234566',
      password: BCrypt.hashpw('12345', BCrypt.gensalt()),
      roles: ['001', '002'],
      isTemporaryPassword: false,
      passwordUpdatedAt: DateTime.now(),
    ),
    User(
      id: '1122',
      username: 'sachith',
      email: 'sachith@example.com',
      telephone: '+94711234567',
      isTemporaryPassword: false,
      passwordUpdatedAt: DateTime.now(),
      password: BCrypt.hashpw('12345', BCrypt.gensalt()),
      roles: ['003'],
    ),
    User(
      id: '1111',
      username: 'sameera',
      email: 'sameera@example.com',
      telephone: '+94771234568',
      password: BCrypt.hashpw('12345', BCrypt.gensalt()),
      roles: ['002', '003'],
    ),
    User(
      id: '1000',
      username: 'admin',
      email: 'admin@example.com',
      telephone: '+94771234555',
      password: BCrypt.hashpw('admin12345', BCrypt.gensalt()),
      roles: ['001', '002', '003'],
    ),
    User(
      id: '2896',
      username: 'darshanr',
      email: 'darshanr@example.com',
      telephone: '+94771234567',
      password: BCrypt.hashpw('12345', BCrypt.gensalt()),
      roles: ['001'],
      isTemporaryPassword: false,
      passwordUpdatedAt: DateTime.now(),
    ),
  ];

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
      hasBankGuarantee: true,
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
    const TinData(
      tinNumber: 'TIN987654321',
      orderNumber: 'PADC202510250001',
      totalValue: 1500.75,
      paymentStatus: 'P', // Payment Pending
      dealercode: 'AC2000123306',
      payOnDel: 'N',
      bagCount: 2,
      tagCount: 4,
      plasticBCount: 1,
      remark: 'Handle with care',
      parts: [],
    ),
    const TinData(
      tinNumber: 'TIN123456789',
      orderNumber: 'PADC202510250002',
      totalValue: 899.99,
      paymentStatus: 'C', // Payment Completed
      dealercode: 'AC2000123306',
      payOnDel: 'Y',
      bagCount: 1,
      tagCount: 2,
      plasticBCount: 0,
      remark: 'Fragile items',
      parts: [],
    ),
    TinData(
      tinNumber: 'TIN555555555',
      orderNumber: 'PADC202510250003',
      totalValue: 12500.00,
      paymentStatus: 'A', // Payment Approved
      dealercode: 'AC2000123306',
      payOnDel: 'N',
      bagCount: 5,
      tagCount: 10,
      plasticBCount: 3,
      remark: 'Heavy equipment',
      parts: [
        Part(
          id: 'p3',
          partNo: '7K92A104',
          requestQty: 1,
          price: 8000.00,
          description: 'Engine Assembly',
        ),
        Part(
          id: 'p4',
          partNo: '5M8102Q3',
          requestQty: 1,
          price: 1000.00,
          description: 'Transmission',
        ),
        Part(
          id: 'p5',
          partNo: '2P9706B1',
          requestQty: 6,
          price: 3000.00,
          description: 'Wheel Set',
        ),
      ],
    ),
    TinData(
      tinNumber: 'TIN314159265',
      orderNumber: 'PADC202510250004',
      totalValue: 432.50,
      paymentStatus: 'P', // Another Pending example
      dealercode: 'AC2000123306',
      payOnDel: 'Y',
      bagCount: 1,
      tagCount: 1,
      plasticBCount: 1,
      remark: 'Small parts',
      parts: [
        Part(
          id: 'p6',
          partNo: 'XYZ123111',
          requestQty: 2,
          price: 150.25,
          description: 'Oil Filter',
        ),
        Part(
          id: 'p7',
          partNo: 'XYZ123222',
          requestQty: 1,
          price: 132.00,
          description: 'Air Filter',
        ),
      ],
    ),

    /// ADDITIONAL PAYMENT APPROVED ENTRIES WITH SAME DEALERCODE

    // Entry 5: Payment Approved with multiple parts and remark '-'
    TinData(
      tinNumber: 'TIN999888777',
      orderNumber: 'PADC202510250005',
      totalValue: 8750.25,
      paymentStatus: 'A', // Payment Approved
      dealercode: 'AC2000123306',
      payOnDel: 'N',
      bagCount: 4,
      tagCount: 8,
      plasticBCount: 2,
      remark: '-',
      parts: [
        Part(
          id: 'p8',
          partNo: '9W1207C8',
          requestQty: 2,
          price: 1250.00,
          description: 'Brake Caliper Set',
        ),
        Part(
          id: 'p9',
          partNo: '3X8604F1',
          requestQty: 4,
          price: 350.00,
          description: 'Brake Pads',
        ),
        Part(
          id: 'p10',
          partNo: '1Y7309J2',
          requestQty: 2,
          price: 450.00,
          description: 'Brake Disc Rotor',
        ),
        Part(
          id: 'p11',
          partNo: '1Y7309J3',
          requestQty: 1,
          price: 2200.00,
          description: 'ABS Control Module',
        ),
      ],
    ),

    // Entry 6: Payment Approved with remark '-'
    TinData(
      tinNumber: 'TIN444333222',
      orderNumber: 'PADC202510250006',
      totalValue: 23450.50,
      paymentStatus: 'A', // Payment Approved
      dealercode: 'AC2000123306',
      payOnDel: 'N',
      bagCount: 8,
      tagCount: 16,
      plasticBCount: 5,
      remark: '-',
      parts: [
        Part(
          id: 'p12',
          partNo: '5C1709T4',
          requestQty: 1,
          price: 8500.00,
          description: 'Turbocharger Assembly',
        ),
        Part(
          id: 'p13',
          partNo: '5C1709T5',
          requestQty: 1,
          price: 4200.00,
          description: 'Intercooler',
        ),
        Part(
          id: 'p14',
          partNo: '5C1709T6',
          requestQty: 4,
          price: 850.00,
          description: 'Fuel Injector',
        ),
        Part(
          id: 'p15',
          partNo: '5C1709T7',
          requestQty: 2,
          price: 950.00,
          description: 'Fuel Pump',
        ),
        Part(
          id: 'p16',
          partNo: '5C1709T8',
          requestQty: 1,
          price: 1800.00,
          description: 'ECU Engine Control Unit',
        ),
      ],
    ),

    // Entry 7: Payment Approved with remark '-'
    TinData(
      tinNumber: 'TIN777666555',
      orderNumber: 'PADC202510250007',
      totalValue: 5675.80,
      paymentStatus: 'A', // Payment Approved
      dealercode: 'AC2000123306',
      payOnDel: 'Y',
      bagCount: 3,
      tagCount: 6,
      plasticBCount: 2,
      remark: '-',
      parts: [
        Part(
          id: 'p17',
          partNo: '6F7108X3',
          requestQty: 2,
          price: 675.00,
          description: 'Alternator',
        ),
        Part(
          id: 'p18',
          partNo: '3F7108X3',
          requestQty: 2,
          price: 545.00,
          description: 'Starter Motor',
        ),
        Part(
          id: 'p19',
          partNo: '4F7108X3',
          requestQty: 4,
          price: 185.00,
          description: 'Spark Plugs',
        ),
        Part(
          id: 'p20',
          partNo: '5F7108X3',
          requestQty: 1,
          price: 1250.00,
          description: 'Ignition Coil Pack',
        ),
      ],
    ),

    // Entry 8: Payment Approved with remark '-'
    TinData(
      tinNumber: 'TIN777666555',
      orderNumber: 'PADC202510250007',
      totalValue: 5675.80,
      paymentStatus: 'A', // Payment Approved
      dealercode: 'AC2000123307',
      payOnDel: 'Y',
      bagCount: 3,
      tagCount: 6,
      plasticBCount: 2,
      remark: '-',
      parts: [
        Part(
          id: 'p17',
          partNo: '6F7108X3',
          requestQty: 2,
          price: 675.00,
          description: 'Alternator',
        ),
        Part(
          id: 'p18',
          partNo: '3F7108X3',
          requestQty: 2,
          price: 545.00,
          description: 'Starter Motor',
        ),
        Part(
          id: 'p19',
          partNo: '4F7108X3',
          requestQty: 4,
          price: 185.00,
          description: 'Spark Plugs',
        ),
        Part(
          id: 'p20',
          partNo: '5F7108X3',
          requestQty: 1,
          price: 1250.00,
          description: 'Ignition Coil Pack',
        ),
      ],
    ),

      // ==================== Dummy data for AC2000123307 (Jayalath Enterprises) ====================
  TinData(
    tinNumber: 'TIN111222333',
    orderNumber: 'PADC202510260001',
    totalValue: 2500.00,
    paymentStatus: 'P',
    dealercode: 'AC2000123307',
    payOnDel: 'N',
    bagCount: 3,
    tagCount: 5,
    plasticBCount: 1,
    remark: 'Priority delivery',
    parts: [],
  ),
  TinData(
    tinNumber: 'TIN444555666',
    orderNumber: 'PADC202510260002',
    totalValue: 1250.75,
    paymentStatus: 'A',
    dealercode: 'AC2000123307',
    payOnDel: 'Y',
    bagCount: 2,
    tagCount: 3,
    plasticBCount: 0,
    remark: '-',
    parts: [
      Part(id: 'p21', partNo: 'B102345', requestQty: 1, price: 800.00, description: 'Battery 12V'),
      Part(id: 'p22', partNo: 'B102346', requestQty: 1, price: 450.75, description: 'Alternator Belt'),
    ],
  ),
  TinData(
    tinNumber: 'TIN777888999',
    orderNumber: 'PADC202510260003',
    totalValue: 8920.30,
    paymentStatus: 'C',
    dealercode: 'AC2000123307',
    payOnDel: 'N',
    bagCount: 5,
    tagCount: 9,
    plasticBCount: 2,
    remark: 'Contains glass parts',
    parts: [
      Part(id: 'p23', partNo: 'W1234A', requestQty: 2, price: 1250.00, description: 'Windshield'),
      Part(id: 'p24', partNo: 'W1234B', requestQty: 1, price: 3500.00, description: 'Rear Window'),
      Part(id: 'p25', partNo: 'M5678', requestQty: 1, price: 2920.30, description: 'Side Mirror Assembly'),
    ],
  ),

  // ==================== Dummy data for AC2000123308 (Kesbewa Auto Zone) ====================
  TinData(
    tinNumber: 'TIN987123456',
    orderNumber: 'PADC202510270001',
    totalValue: 340.25,
    paymentStatus: 'P',
    dealercode: 'AC2000123308',
    payOnDel: 'Y',
    bagCount: 1,
    tagCount: 1,
    plasticBCount: 0,
    remark: 'Urgent',
    parts: [],
  ),
  TinData(
    tinNumber: 'TIN654321987',
    orderNumber: 'PADC202510270002',
    totalValue: 11200.00,
    paymentStatus: 'A',
    dealercode: 'AC2000123308',
    payOnDel: 'N',
    bagCount: 6,
    tagCount: 12,
    plasticBCount: 4,
    remark: '-',
    parts: [
      Part(id: 'p26', partNo: 'E101', requestQty: 1, price: 6200.00, description: 'Engine Control Unit'),
      Part(id: 'p27', partNo: 'E102', requestQty: 2, price: 1500.00, description: 'Oxygen Sensor'),
      Part(id: 'p28', partNo: 'E103', requestQty: 2, price: 1000.00, description: 'MAF Sensor'),
    ],
  ),
  TinData(
    tinNumber: 'TIN456789123',
    orderNumber: 'PADC202510270003',
    totalValue: 3875.50,
    paymentStatus: 'C',
    dealercode: 'AC2000123308',
    payOnDel: 'Y',
    bagCount: 3,
    tagCount: 5,
    plasticBCount: 1,
    remark: 'Returnable packaging',
    parts: [
      Part(id: 'p29', partNo: 'C001', requestQty: 4, price: 425.00, description: 'Clutch Kit'),
      Part(id: 'p30', partNo: 'C002', requestQty: 2, price: 187.75, description: 'Clutch Cable'),
    ],
  ),

  // ==================== Dummy data for AC2000123301 (Perera & Sons Motors) ====================
  TinData(
    tinNumber: 'TIN112233445',
    orderNumber: 'PADC202510280001',
    totalValue: 14500.00,
    paymentStatus: 'A',
    dealercode: 'AC2000123301',
    payOnDel: 'N',
    bagCount: 10,
    tagCount: 18,
    plasticBCount: 6,
    remark: 'Fragile electronics',
    parts: [
      Part(id: 'p31', partNo: 'INFOT1', requestQty: 3, price: 2500.00, description: 'Infotainment Screen'),
      Part(id: 'p32', partNo: 'SENS1', requestQty: 5, price: 800.00, description: 'Parking Sensor'),
      Part(id: 'p33', partNo: 'CAM1', requestQty: 2, price: 1200.00, description: 'Rear Camera'),
    ],
  ),
  TinData(
    tinNumber: 'TIN554433221',
    orderNumber: 'PADC202510280002',
    totalValue: 975.30,
    paymentStatus: 'P',
    dealercode: 'AC2000123301',
    payOnDel: 'Y',
    bagCount: 1,
    tagCount: 2,
    plasticBCount: 1,
    remark: '-',
    parts: [],
  ),

  // ==================== Dummy data for AC2000123302 (Colombo Auto Traders) ====================
  TinData(
    tinNumber: 'TIN998877665',
    orderNumber: 'PADC202510290001',
    totalValue: 5230.00,
    paymentStatus: 'C',
    dealercode: 'AC2000123302',
    payOnDel: 'N',
    bagCount: 4,
    tagCount: 7,
    plasticBCount: 2,
    remark: 'Express shipping',
    parts: [
      Part(id: 'p34', partNo: 'ACCOMP1', requestQty: 1, price: 3500.00, description: 'AC Compressor'),
      Part(id: 'p35', partNo: 'COND1', requestQty: 1, price: 1730.00, description: 'Condenser'),
    ],
  ),
  TinData(
    tinNumber: 'TIN332211445',
    orderNumber: 'PADC202510290002',
    totalValue: 2840.50,
    paymentStatus: 'A',
    dealercode: 'AC2000123302',
    payOnDel: 'Y',
    bagCount: 2,
    tagCount: 3,
    plasticBCount: 1,
    remark: '-',
    parts: [
      Part(id: 'p36', partNo: 'FILT1', requestQty: 5, price: 120.00, description: 'Oil Filter'),
      Part(id: 'p37', partNo: 'FILT2', requestQty: 3, price: 180.00, description: 'Air Filter'),
    ],
  ),

  // ==================== Dummy data for AC2000123303 (Capital Wheels) ====================
  TinData(
    tinNumber: 'TIN123987654',
    orderNumber: 'PADC202510300001',
    totalValue: 36200.00,
    paymentStatus: 'A',
    dealercode: 'AC2000123303',
    payOnDel: 'N',
    bagCount: 12,
    tagCount: 24,
    plasticBCount: 8,
    remark: 'Heavy items, forklift required',
    parts: [
      Part(id: 'p38', partNo: 'WHEEL1', requestQty: 4, price: 6500.00, description: 'Alloy Wheel 18"'),
      Part(id: 'p39', partNo: 'TIRE1', requestQty: 4, price: 2500.00, description: 'Performance Tire'),
      Part(id: 'p40', partNo: 'LUG1', requestQty: 20, price: 35.00, description: 'Lug Nut Set'),
    ],
  ),
  TinData(
    tinNumber: 'TIN789654123',
    orderNumber: 'PADC202510300002',
    totalValue: 780.00,
    paymentStatus: 'P',
    dealercode: 'AC2000123303',
    payOnDel: 'Y',
    bagCount: 1,
    tagCount: 2,
    plasticBCount: 0,
    remark: '-',
    parts: [],
  ),

  // ==================== Dummy data for AC2000123304 (De Silva Car Sales) ====================
  TinData(
    tinNumber: 'TIN567890123',
    orderNumber: 'PADC202510310001',
    totalValue: 4800.00,
    paymentStatus: 'A',
    dealercode: 'AC2000123304',
    payOnDel: 'N',
    bagCount: 3,
    tagCount: 6,
    plasticBCount: 2,
    remark: 'Rush order',
    parts: [
      Part(id: 'p41', partNo: 'LAMP1', requestQty: 2, price: 450.00, description: 'Headlight Assembly'),
      Part(id: 'p42', partNo: 'LAMP2', requestQty: 2, price: 350.00, description: 'Tail Light'),
      Part(id: 'p43', partNo: 'BULB1', requestQty: 10, price: 25.00, description: 'LED Bulb'),
    ],
  ),
  TinData(
    tinNumber: 'TIN234567890',
    orderNumber: 'PADC202510310002',
    totalValue: 2100.00,
    paymentStatus: 'C',
    dealercode: 'AC2000123304',
    payOnDel: 'Y',
    bagCount: 2,
    tagCount: 3,
    plasticBCount: 1,
    remark: '-',
    parts: [
      Part(id: 'p44', partNo: 'BELT1', requestQty: 1, price: 2100.00, description: 'Timing Belt Kit'),
    ],
  ),

  // ==================== Dummy data for AC2000123305 (Metro Vehicle Centre) ====================
  TinData(
    tinNumber: 'TIN345678901',
    orderNumber: 'PADC202511010001',
    totalValue: 15750.00,
    paymentStatus: 'A',
    dealercode: 'AC2000123305',
    payOnDel: 'N',
    bagCount: 7,
    tagCount: 14,
    plasticBCount: 3,
    remark: 'Inspection required',
    parts: [
      Part(id: 'p45', partNo: 'SUSP1', requestQty: 2, price: 3500.00, description: 'Shock Absorber'),
      Part(id: 'p46', partNo: 'SUSP2', requestQty: 2, price: 2250.00, description: 'Strut Assembly'),
      Part(id: 'p47', partNo: 'SUSP3', requestQty: 1, price: 4250.00, description: 'Control Arm'),
    ],
  ),
  TinData(
    tinNumber: 'TIN456789012',
    orderNumber: 'PADC202511010002',
    totalValue: 950.25,
    paymentStatus: 'P',
    dealercode: 'AC2000123305',
    payOnDel: 'Y',
    bagCount: 1,
    tagCount: 2,
    plasticBCount: 0,
    remark: '-',
    parts: [],
  ),
  ];

  // static final List<TinData> _tins = [
  //   const TinData(
  //     tinNumber: 'TIN987654321',
  //     totalValue: 1500.75,
  //     orderNumber: 'PADC202510250001',
  //   ),
  //   const TinData(
  //     tinNumber: 'TIN123456789',
  //     totalValue: 899.99,
  //     orderNumber: 'PADC202510250002',
  //   ),
  //   const TinData(
  //     tinNumber: 'TIN555555555',
  //     totalValue: 12500.00,
  //     orderNumber: 'PADC202510250003',
  //   ),
  //   const TinData(
  //     tinNumber: 'TIN314159265',
  //     totalValue: 432.50,
  //     orderNumber: 'PADC202510250004',
  //   ),
  // ];

  static final List<Region> _regions = [
    Region(
      regionCode: 'REG0001',
      region: 'COLOMBO',
      head: 'Mr. Chamila Galketiya',
    ),
    Region(
      regionCode: 'REG0002',
      region: 'MADAPATHA',
      head: 'Mr. Chamila Galketiya',
    ),
    Region(
      regionCode: 'REG0003',
      region: 'MATHUGAMA',
      head: 'Mr. Chamila Galketiya',
    ),
    Region(
      regionCode: 'REG0004',
      region: 'NEGOMBO',
      head: 'Mr. Chamila Galketiya',
    ),
    Region(
      regionCode: 'REG0005',
      region: 'YAKKALA',
      head: 'Mr. Chamila Galketiya',
    ),
    Region(
      regionCode: 'REG0006',
      region: 'DAMBULLA',
      head: 'Mr. Gayan Senaviratna',
    ),
    Region(
      regionCode: 'REG0007',
      region: 'D\'KANDIYA',
      head: 'Mr. Gayan Senaviratna',
    ),
    Region(
      regionCode: 'REG0008',
      region: 'KANDY',
      head: 'Mr. Gayan Senaviratna',
    ),
    Region(
      regionCode: 'REG0009',
      region: 'KURUNEGALA',
      head: 'Mr. Gayan Senaviratna',
    ),
    Region(
      regionCode: 'REG0010',
      region: 'AMBALANGODA',
      head: 'Mr. Priyantha Gamage',
    ),
    Region(
      regionCode: 'REG0011',
      region: 'DENIYAYA',
      head: 'Mr. Priyantha Gamage',
    ),
    Region(
      regionCode: 'REG0012',
      region: 'GALLE',
      head: 'Mr. Priyantha Gamage',
    ),
    Region(
      regionCode: 'REG0013',
      region: 'MATARA',
      head: 'Mr. Priyantha Gamage',
    ),
    Region(
      regionCode: 'REG0014',
      region: 'RANNA',
      head: 'Mr. Priyantha Gamage',
    ),
    Region(
      regionCode: 'REG0015',
      region: 'AMPARA',
      head: 'Mr. Mahalingam Ravichandran',
    ),
    Region(
      regionCode: 'REG0016',
      region: 'BATTICALOA',
      head: 'Mr. Mahalingam Ravichandran',
    ),
    Region(
      regionCode: 'REG0017',
      region: 'TRINCOMALEE',
      head: 'Mr. Mahalingam Ravichandran',
    ),
    Region(
      regionCode: 'REG0018',
      region: 'ANURADHAPURA',
      head: 'Mr. Nadaraja Sadheen',
    ),
    Region(
      regionCode: 'REG0019',
      region: 'CHILAW',
      head: 'Mr. Nadaraja Sadheen',
    ),
    Region(
      regionCode: 'REG0020',
      region: 'JAFFNA',
      head: 'Mr. Nadaraja Sadheen',
    ),
    Region(
      regionCode: 'REG0021',
      region: 'VAVUNIYA',
      head: 'Mr. Nadaraja Sadheen',
    ),
    Region(regionCode: 'REG0022', region: 'BADULLA', head: 'Mr. Ruwan Sameera'),
    Region(
      regionCode: 'REG0023',
      region: 'MONARAGALA',
      head: 'Mr. Ruwan Sameera',
    ),
    Region(
      regionCode: 'REG0024',
      region: 'N\'ELIYA',
      head: 'Mr. Ruwan Sameera',
    ),
  ];

  static final List<ReturnItem> _returnItems = [
    ReturnItem(partNo: 'XYZ123230', requestQty: 5),
    ReturnItem(partNo: 'XYZ123266', requestQty: 8),
    ReturnItem(partNo: 'XYZ123267', requestQty: 7),
    ReturnItem(partNo: 'PN-1122-AB', requestQty: 12),
    ReturnItem(partNo: 'PN-1133-CD', requestQty: 3),
    ReturnItem(partNo: 'XY-9988-ZZ', requestQty: 18),
    ReturnItem(partNo: 'XYZ124001', requestQty: 2),
    ReturnItem(partNo: 'XYZ124005', requestQty: 11),
    ReturnItem(partNo: 'XYZ124019', requestQty: 6),
    ReturnItem(partNo: 'HW-5500-FG', requestQty: 9),
    ReturnItem(partNo: 'HW-5501-FH', requestQty: 14),
    ReturnItem(partNo: 'HW-5502-FI', requestQty: 4),
    ReturnItem(partNo: 'AC3001005001', requestQty: 1),
    ReturnItem(partNo: 'AC3001005002', requestQty: 15),
    ReturnItem(partNo: 'PN-3344-GH', requestQty: 7),
    ReturnItem(partNo: 'PN-3355-IJ', requestQty: 10),
    ReturnItem(partNo: 'XY-7766-WX', requestQty: 13),
    ReturnItem(partNo: 'XY-7767-WY', requestQty: 5),
    ReturnItem(partNo: 'XYZ125555', requestQty: 19),
    ReturnItem(partNo: 'XYZ125556', requestQty: 20),
    ReturnItem(partNo: 'HW-6600-JK', requestQty: 8),
  ];

  static final List<Part> _parts = [
    Part(id: 'p1', partNo: 'XYZ123230', requestQty: 2, price: 12000.00),
    Part(id: 'p2', partNo: 'XYZ123231', requestQty: 5, price: 5500.50),
    Part(id: 'p3', partNo: 'XYZ123232', requestQty: 1, price: 8000.00),
    Part(id: 'p4', partNo: 'XYZ123342', requestQty: 1, price: 1000.00),
    Part(id: 'p5', partNo: 'XYZ123932', requestQty: 6, price: 3000.00),
    Part(id: 'p6', partNo: 'XYZ123937', requestQty: 6, price: 300.00),
    // Generating more parts for a richer list
    Part(id: 'p7', partNo: 'HW-5500-FG', requestQty: 10, price: 750.00),
    Part(id: 'p8', partNo: 'HW-5501-FH', requestQty: 3, price: 1500.25),
    Part(id: 'p9', partNo: 'PN-3344-GH', requestQty: 8, price: 999.99),
    Part(id: 'p10', partNo: 'PN-3355-IJ', requestQty: 4, price: 250.00),
    Part(id: 'p11', partNo: 'XY-7766-WX', requestQty: 12, price: 6500.00),
    Part(id: 'p12', partNo: 'XY-9988-ZZ', requestQty: 7, price: 125.50),
  ];

  static final List<Bank> _banks = [
    Bank(bankCode: '7010', bankName: 'Bank of Ceylon'),
    Bank(bankCode: '7056', bankName: 'Commercial Bank of Ceylon'),
    Bank(bankCode: '7278', bankName: 'Sampath Bank'),
    Bank(bankCode: '7083', bankName: 'Hatton National Bank'),
    Bank(bankCode: '7135', bankName: 'Peoples Bank'),
  ];

  static final List<BankBranch> _branches = [
    // Bank of Ceylon Branches
    BankBranch(
      bankCode: '7010',
      bankName: 'Bank of Ceylon',
      branchCode: '001',
      branchName: 'Bank of Ceylon - Colombo',
    ),
    BankBranch(
      bankCode: '7010',
      bankName: 'Bank of Ceylon',
      branchCode: '002',
      branchName: 'Bank of Ceylon - Kandy',
    ),
    BankBranch(
      bankCode: '7010',
      bankName: 'Bank of Ceylon',
      branchCode: '003',
      branchName: 'Bank of Ceylon - Galle',
    ),
    BankBranch(
      bankCode: '7010',
      bankName: 'Bank of Ceylon',
      branchCode: '004',
      branchName: 'Bank of Ceylon - Jaffna',
    ),

    // Commercial Bank of Ceylon Branches
    BankBranch(
      bankCode: '7056',
      bankName: 'Commercial Bank of Ceylon',
      branchCode: '001',
      branchName: 'Commercial Bank - Colombo',
    ),
    BankBranch(
      bankCode: '7056',
      bankName: 'Commercial Bank of Ceylon',
      branchCode: '002',
      branchName: 'Commercial Bank - Kandy',
    ),
    BankBranch(
      bankCode: '7056',
      bankName: 'Commercial Bank of Ceylon',
      branchCode: '003',
      branchName: 'Commercial Bank - Galle',
    ),
    BankBranch(
      bankCode: '7056',
      bankName: 'Commercial Bank of Ceylon',
      branchCode: '004',
      branchName: 'Commercial Bank - Matara',
    ),

    // Sampath Bank Branches
    BankBranch(
      bankCode: '7278',
      bankName: 'Sampath Bank',
      branchCode: '001',
      branchName: 'Sampath Bank - Colombo',
    ),
    BankBranch(
      bankCode: '7278',
      bankName: 'Sampath Bank',
      branchCode: '002',
      branchName: 'Sampath Bank - Gampaha',
    ),
    BankBranch(
      bankCode: '7278',
      bankName: 'Sampath Bank',
      branchCode: '003',
      branchName: 'Sampath Bank - Kurunegala',
    ),
    BankBranch(
      bankCode: '7278',
      bankName: 'Sampath Bank',
      branchCode: '004',
      branchName: 'Sampath Bank - Panadura',
    ),

    // Hatton National Bank Branches
    BankBranch(
      bankCode: '7083',
      bankName: 'Hatton National Bank',
      branchCode: '001',
      branchName: 'HNB - Colombo',
    ),
    BankBranch(
      bankCode: '7083',
      bankName: 'Hatton National Bank',
      branchCode: '002',
      branchName: 'HNB - Kandy',
    ),
    BankBranch(
      bankCode: '7083',
      bankName: 'Hatton National Bank',
      branchCode: '003',
      branchName: 'HNB - Galle',
    ),
    BankBranch(
      bankCode: '7083',
      bankName: 'Hatton National Bank',
      branchCode: '004',
      branchName: 'HNB - Negombo',
    ),

    // Peoples Bank Branches
    BankBranch(
      bankCode: '7135',
      bankName: 'Peoples Bank',
      branchCode: '001',
      branchName: 'Peoples Bank - Colombo',
    ),
    BankBranch(
      bankCode: '7135',
      bankName: 'Peoples Bank',
      branchCode: '002',
      branchName: 'Peoples Bank - Nugegoda',
    ),
    BankBranch(
      bankCode: '7135',
      bankName: 'Peoples Bank',
      branchCode: '003',
      branchName: 'Peoples Bank - Gampaha',
    ),
    BankBranch(
      bankCode: '7135',
      bankName: 'Peoples Bank',
      branchCode: '004',
      branchName: 'Peoples Bank - Anuradhapura',
    ),
  ];

  static final List<TinInvoice> _tinInvoices = [
    const TinInvoice(
      tinNo: 'TINBDM2025011500101',
      mobileInvNo: 'MIN0020512201400010',
      invAmount: 45200.50,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025011800105',
      mobileInvNo: 'MIN0020512201400014',
      invAmount: 18750.0,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025012500119',
      mobileInvNo: 'MIN0020512201400028',
      invAmount: 33400.0,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025012800122',
      mobileInvNo: 'MIN0020512201400031',
      invAmount: 9800.25,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),

    const TinInvoice(
      tinNo: 'TINBDM2025020200130',
      mobileInvNo: 'MIN0020512201400039',
      invAmount: 5120.75,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025020500135',
      mobileInvNo: 'MIN0020512201400044',
      invAmount: 22450.00,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025021100142',
      mobileInvNo: 'MIN0020512201400051',
      invAmount: 7650.50,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025021400148',
      mobileInvNo: 'MIN0020512201400057',
      invAmount: 19990.00,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025021900153',
      mobileInvNo: 'MIN0020512201400062',
      invAmount: 31200.00,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025022500160',
      mobileInvNo: 'MIN0020512201400069',
      invAmount: 8430.20,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025030100165',
      mobileInvNo: 'MIN0020512201400074',
      invAmount: 65400.00,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025030400171',
      mobileInvNo: 'MIN0020512201400080',
      invAmount: 12300.75,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025030900178',
      mobileInvNo: 'MIN0020512201400087',
      invAmount: 25800.00,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025031200183',
      mobileInvNo: 'MIN0020512201400092',
      invAmount: 4150.50,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123306',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025031500190',
      mobileInvNo: 'MIN0020512201400099',
      invAmount: 15000.00,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123306',
    ),

    // --- Invoices for Jayalath Enterprises (AC2000123307) ---
    const TinInvoice(
      tinNo: 'TINBDM2025020300112',
      mobileInvNo: 'MIN0020512201400021',
      invAmount: 89300.0,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123307', // receiptStatus defaults to false
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025020400113',
      mobileInvNo: 'MIN0020512201400022',
      invAmount: 32000.75,
      paymentOnDeliveryStatus: 'Y',
      //receiptStatus: true, // Example of an already processed receipt
      dealerAccCode: 'AC2000123307',
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025021500128',
      mobileInvNo: 'MIN0020512201400039',
      invAmount: 112000.0,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123307', // receiptStatus defaults to false
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025021800131',
      mobileInvNo: 'MIN0020512201400042',
      invAmount: 6500.50,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123307', // receiptStatus defaults to false
    ),

    // --- Invoices for Kesbewa Auto Zone (AC2000123308) ---
    const TinInvoice(
      tinNo: 'TINBDM2025030100125',
      mobileInvNo: 'MIN0020512201400035',
      invAmount: 152500.0,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123308', // receiptStatus defaults to false
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025030900142',
      mobileInvNo: 'MIN0020512201400051',
      invAmount: 25000.0,
      paymentOnDeliveryStatus: 'Y',
      dealerAccCode: 'AC2000123308', // receiptStatus defaults to false
    ),
    const TinInvoice(
      tinNo: 'TINBDM2025031200148',
      mobileInvNo: 'MIN0020512201400059',
      invAmount: 48900.0,
      paymentOnDeliveryStatus: 'N',
      dealerAccCode: 'AC2000123308', // receiptStatus defaults to false
    ),
  ];

  static final List<ReturnRequest> _returnRequests = [
    ReturnRequest(
      returnId: 'RET00000001',
      dealerId: 'AC2000123306',
      userId: '2619',
      returnType: 'Field Returns',
      returnReason: 'LEAKAGES (PETROL/OIL)',
      requestUpdate: DateTime.now().subtract(Duration(days: 1)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'AC2000123230', requestQty: 5, returnQty: 5),
        ReturnItem(partNo: 'PN-1122-AB', requestQty: 12, returnQty: 12),
        ReturnItem(partNo: 'AC2000125555', requestQty: 19, returnQty: 19),
        ReturnItem(partNo: 'AC2000123266', requestQty: 8, returnQty: 8),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000002',
      dealerId: 'AC2000123306',
      userId: '2619',
      returnType: 'Discrepancy Returns',
      returnReason: 'MANUFACTURING DEFECT',
      requestUpdate: DateTime.now().subtract(Duration(days: 2)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'HW-5500-FG', requestQty: 9, returnQty: 9),
        ReturnItem(partNo: 'AC2000124005', requestQty: 11, returnQty: 11),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000003',
      dealerId: 'AC2000123306',
      userId: '2619',
      returnType: 'Field Returns',
      returnReason: 'Bead Failure - BF',
      requestUpdate: DateTime.now().subtract(Duration(days: 3)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'XY-9988-ZZ', requestQty: 18, returnQty: 18),
        ReturnItem(partNo: 'PN-3355-IJ', requestQty: 10, returnQty: 10),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000004',
      dealerId: 'AC2000123306',
      userId: '2619',
      returnType: 'Discrepancy Returns',
      returnReason: 'REFUND',
      requestUpdate: DateTime.now().subtract(Duration(days: 4)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'AC2000125555', requestQty: 19, returnQty: 19),
        ReturnItem(partNo: 'AC2000123266', requestQty: 8, returnQty: 8),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000005',
      dealerId: 'AC2000123306',
      userId: '2619',
      returnType: 'Field Returns',
      returnReason: 'LOYALTY DISCOUNT',
      requestUpdate: DateTime.now().subtract(Duration(days: 5)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'HW-6600-JK', requestQty: 8, returnQty: 8),
        ReturnItem(partNo: 'XY-7766-WX', requestQty: 13, returnQty: 13),
      ],
    ),

    ReturnRequest(
      returnId: 'RET00000006',
      dealerId: 'AC2000123307',
      userId: '2619',
      returnType: 'Field Returns',
      returnReason: 'LEAKAGES (PETROL/OIL)',
      requestUpdate: DateTime.now().subtract(Duration(days: 1)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'AC2000123230', requestQty: 5, returnQty: 5),
        ReturnItem(partNo: 'PN-1122-AB', requestQty: 12, returnQty: 12),
        ReturnItem(partNo: 'AC2000125555', requestQty: 19, returnQty: 19),
        ReturnItem(partNo: 'AC2000123266', requestQty: 8, returnQty: 8),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000007',
      dealerId: 'AC2000123307',
      userId: '2619',
      returnType: 'Discrepancy Returns',
      returnReason: 'MANUFACTURING DEFECT',
      requestUpdate: DateTime.now().subtract(Duration(days: 2)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'HW-5500-FG', requestQty: 9, returnQty: 9),
        ReturnItem(partNo: 'AC2000124005', requestQty: 11, returnQty: 11),
      ],
    ),
    ReturnRequest(
      returnId: 'RET00000008',
      dealerId: 'AC2000123307',
      userId: '2619',
      returnType: 'Field Returns',
      returnReason: 'Bead Failure - BF',
      requestUpdate: DateTime.now().subtract(Duration(days: 3)),
      returnTime: DateTime.now(),
      returnItems: [
        ReturnItem(partNo: 'XY-9988-ZZ', requestQty: 18, returnQty: 18),
        ReturnItem(partNo: 'PN-3355-IJ', requestQty: 10, returnQty: 10),
      ],
    ),
  ];

  static List<Bank> get banks => _banks;
  static List<BankBranch> get branches => _branches;
  static List<Dealer> get dealers => _dealers;
  static List<Reference> get references => _references;
  static List<Invoice> get invoices => _invoices;
  static List<InvoiceSave> get savedInvoices => _sessionInvoices;
  static List<TinData> get tins => _tins;
  static List<Region> get regions => _regions;
  static List<ReturnItem> get returnItems => _returnItems;
  static List<Part> get parts => _parts;
  static List<TinInvoice> get tinInvoices => _tinInvoices;
  static List<User> get users => _users;
  static List<Receipt> get receipts => _sessionReceipts;
  static List<Menu> get menus => _menus;
  static List<Screen> get screens => _screens;
  static List<Role> get roles => _roles;
  static List<Perm> get perms => _perms;
  static List<Attendance> get attendances => _attendance;
  static List<Employee> get employees => _employees;
  static List<Return> get returns => _sessionReturns;
  //static List<InvoiceSave> get savedInvoices => _sessionInvoices;
  static List<DispatchNoteSave> get savedDispatchNotes => _sessionDispatchNotes;
  static List<ReturnRequest> get returnRequests => _returnRequests;
  static List<Assignee> get assignees => _assignees;
}

List<Attendance> generateDummyAttendanceData({
  required String userId,
  int numberOfWorkingDays = 30,
}) {
  final List<Attendance> attendanceRecords = [];
  final Random random = Random();
  DateTime currentDate = DateTime.now(); // Starts from today's date

  while (attendanceRecords.length < numberOfWorkingDays) {
    // Go back one day at a time
    currentDate = currentDate.subtract(const Duration(days: 1));

    // Skip weekends (Saturday and Sunday)
    if (currentDate.weekday == DateTime.saturday ||
        currentDate.weekday == DateTime.sunday) {
      continue;
    }

    // This is a working day, generate attendance for it
    String attendanceType;
    String workMode;
    DateTime? startTime;
    DateTime? endTime;
    String? remark;

    // Distribute attendance types: ~80% PRESENT, ~10% LEAVE, ~10% HOLIDAY
    final int typeRoll = random.nextInt(100); // 0-99
    if (typeRoll < 60) {
      // High chance for PRESENT
      attendanceType = "PRESENT";
      List<String> _workOptions = ['Home', 'Office', 'Field'];
      int randomIndex = random.nextInt(_workOptions.length);

      // 3. Access the random element
      workMode = _workOptions[randomIndex];

      // Generate start time around 8:00 AM +/- 15 minutes
      startTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        8,
        0,
      ).add(Duration(minutes: random.nextInt(31) - 15)); // -15 to +15 minutes

      // Generate end time around 5:00 PM +/- 15 minutes
      endTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        17,
        0,
      ).add(Duration(minutes: random.nextInt(31) - 15)); // -15 to +15 minutes

      // Ensure end time is at least 6 hours after start time for a plausible work day
      if (endTime.isBefore(startTime.add(const Duration(hours: 6)))) {
        endTime = startTime.add(
          Duration(hours: 8, minutes: random.nextInt(60)),
        ); // ~8 to 9 hour shift
      }

      // Add a remark occasionally for PRESENT days
      final int remarkRoll = random.nextInt(10); // 0-9
      if (remarkRoll < 2) {
        // 20% chance
        remark = random.nextBool() ? "Early arrival" : "Late departure";
      } else if (remarkRoll == 3) {
        // 10% chance
        remark = "Working remotely today";
      } else {
        remark = null;
      }
    } else if (typeRoll < 80) {
      // 10% chance for LEAVE
      attendanceType = "LEAVE";
      workMode = ""; // Not applicable
      startTime = null;
      endTime = null;
      remark = random.nextBool() ? "Annual Leave" : "Sick Leave";
    } else {
      // 10% chance for HOLIDAY
      attendanceType = "HOLIDAY";
      workMode = ""; // Not applicable
      startTime = null;
      endTime = null;
      remark = "Public Holiday";
    }

    attendanceRecords.add(
      Attendance(
        userID: userId,
        date: DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ), // Normalize to date only
        attendanceType: attendanceType,
        workMode: workMode,
        start: startTime,
        end: endTime,
        remark: remark,
      ),
    );
  }
  return attendanceRecords;
}
