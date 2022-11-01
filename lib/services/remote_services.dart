import 'package:crm/services/constants.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteServices {
  final Dio _dio = Dio(
      BaseOptions(baseUrl: Constants.baseURL, responseType: ResponseType.json));

  Future<dynamic> login(String username, String password) async {
    try {
      Response resp = await _dio
          .post(Constants.login, data: {'username': username, 'password': password});

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllCustomerNames() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllCustomerNames,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllDistributors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllDistributors,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllTimesheet() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllTimesheet,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "id": prefs.getInt("id")
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllCompanies() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllCompanies,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllContractors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllContractors,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllConsultants() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllConsultants,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllEmployeeNames() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllEmployeeNames,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllCompanyNames() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllCompanyNames,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllProjects() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllProjects,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllProjectNames() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllProjectNames,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllCustomers(offset) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllCustomers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "offset" : offset
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> searchCustomers(offset, search) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.searchCustomers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "offset" : offset,
            "search" : search
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> filterCustomers(offset, filter) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.filterCustomers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "offset" : offset,
            "filter" : filter
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> searchFilterCustomers(offset, search, filter) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.searchFilterCustomers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "offset" : offset,
            "search" : search,
            "filter" : filter
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllShippers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllShippers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllSuppliers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllSuppliers,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllAssets() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllAssets,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllSoftware() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllSoftware,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllEmployees() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllEmployees,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getAllJobTitles(department) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.getAllJobTitles,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}",
            "department": department
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addCompany(name, category, address, city, province, country,
      businessPhone, fax, email, webpage, notes, attachments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addCompany,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "name": name,
            "category": category,
            "address": address,
            "city": city,
            "province": province,
            "country": country,
            "businessPhone": businessPhone,
            "fax": fax,
            "email": email,
            "webpage": webpage,
            "notes": notes,
            "attachments": attachments
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addEmployee(
      department,
      salutation,
      firstName,
      lastName,
      emailWork,
      emailPersonal,
      directManagerId,
      username,
      password,
      jobTitleId,
      joiningDate,
      business,
      mobile,
      address,
      city,
      state,
      zip,
      country,
      expertise,
      resume,
      softwarePrivilege,
      webpage,
      notes,
      attachments,
      proficiency,
      interest,
      cocurricular,
      training,
      birthday,
      anniversary,
      sports,
      activities,
      beverage,
      alcohol,
      travelDestination,
      spouseName,
      children,
      tvShow,
      movies,
      actor,
      dislikes,
      strengths,
      weaknesses,
      socialActiveIndex) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addEmployee,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "department" : department,
            "salutation" : salutation,
            "firstName" : firstName,
            "lastName" : lastName,
            "emailWork" : emailWork,
            "emailPersonal" : emailPersonal,
            "directManagerId" : directManagerId,
            "username" : username,
            "password" : password,
            "jobTitleId" : jobTitleId,
            "joiningDate" : joiningDate,
            "business" : business,
            "mobile" : mobile,
            "address" : address,
            "city" : city,
            "state" : state,
            "zip" : zip,
            "country" : country,
            "expertise" : expertise,
            "resume" : resume,
            "softwarePrivilege" : softwarePrivilege,
            "webpage" : webpage,
            "notes" : notes,
            "attachments" : attachments,
            "proficiency" : proficiency,
            "interest" : interest,
            "cocurricular" : cocurricular,
            "training" : training,
            "birthday" : birthday,
            "anniversary" : anniversary,
            "sports" : sports,
            "activities" : activities,
            "beverage" : beverage,
            "alcohol" : alcohol,
            "travelDestination" : travelDestination,
            "spouseName" : spouseName,
            "children" : children,
            "tvShow" : tvShow,
            "movies" : movies,
            "actor" : actor,
            "dislikes" : dislikes,
            "strengths" : strengths,
            "weaknesses" : weaknesses,
            "socialActiveIndex" : socialActiveIndex
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addToTimeSheet(
      projectId, date, startTime, endTime, comments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addToTimeSheet,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "employeeId": prefs.getInt("id"),
            "projectId": projectId,
            "date": date,
            "startTime":
                DateFormat.Hms().format(DateFormat.jm().parse(startTime)),
            "endTime": DateFormat.Hms().format(DateFormat.jm().parse(endTime)),
            "comments": comments
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addAsset(employeeId, category, hardwareDetails, acquiredOn,
      purchasePrice, shippedOn, retiredDate, attachments, notes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addAsset,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "employeeId": employeeId,
            "category": category,
            "hardwareDetails": hardwareDetails,
            "acquiredOn": acquiredOn,
            "purchasePrice": purchasePrice,
            "shippedOn": shippedOn,
            "retiredDate": retiredDate,
            "attachments": attachments,
            "notes": notes
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addSoftware(software, version, manufacturer, acquiredOn,
      price, retiredDate, attachments, notes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addSoftware,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "software": software,
            "version": version,
            "manufacturer": manufacturer,
            "acquiredOn": acquiredOn,
            "price": price,
            "retiredDate": retiredDate,
            "attachments": attachments,
            "notes": notes
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addContact(
      companyId,
      salutation,
      firstName,
      lastName,
      emailPersonal,
      emailWork,
      jobTitle,
      businessPhone,
      mobilePhone,
      address,
      city,
      province,
      zip,
      country,
      notes,
      attachment,
      birthday,
      anniversary,
      sports,
      activities,
      beverage,
      alcohol,
      travelDestination,
      spouseName,
      children,
      tvShow,
      movies,
      actor,
      dislikes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addContact,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "companyId": companyId,
            "salutation": salutation,
            "firstName": firstName,
            "lastName": lastName,
            "emailPersonal": emailPersonal,
            "emailWork": emailWork,
            "jobTitle": jobTitle,
            "businessPhone": businessPhone,
            "mobilePhone": mobilePhone,
            "address": address,
            "city": city,
            "province": province,
            "zip": zip,
            "country": country,
            "notes": notes,
            "attachment": attachment,
            "birthday": birthday,
            "anniversary": anniversary,
            "sports": sports,
            "activities": activities,
            "beverage": beverage,
            "alcohol": alcohol,
            "travelDestination": travelDestination,
            "spouseName": spouseName,
            "children": children,
            "tvShow": tvShow,
            "movies": movies,
            "actor": actor,
            "dislikes": dislikes
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addShipper(
      company,
      firstName,
      lastName,
      email,
      jobTitle,
      business,
      home,
      mobile,
      fax,
      address,
      city,
      state,
      zip,
      country,
      webpage,
      notes,
      attachments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addShipper,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "company": company,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "jobTitle": jobTitle,
            "business": business,
            "home": home,
            "mobile": mobile,
            "fax": fax,
            "address": address,
            "city": city,
            "state": state,
            "zip": zip,
            "country": country,
            "webPage": webpage,
            "notes": notes,
            "attachments": attachments
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addSupplier(
      company,
      firstName,
      lastName,
      email,
      jobTitle,
      business,
      home,
      mobile,
      fax,
      address,
      city,
      state,
      zip,
      country,
      webpage,
      notes,
      attachments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addSupplier,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "company": company,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "jobTitle": jobTitle,
            "business": business,
            "home": home,
            "mobile": mobile,
            "fax": fax,
            "address": address,
            "city": city,
            "state": state,
            "zip": zip,
            "country": country,
            "webPage": webpage,
            "notes": notes,
            "attachments": attachments
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addProject(
      projectName,
      dueDate,
      stage,
      followUpNotes,
      nextFollowUp,
      tentClosing,
      quantity,
      specified,
      value,
      consultant,
      city,
      province,
      department,
      assignedTo,
      contractor,
      distributor) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addProject,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "projectName": projectName,
            "dateCreated": DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(DateTime.now())
                .toString(),
            "dueDate": dueDate,
            "stage": stage,
            "followUpNotes": followUpNotes,
            "nextFollowUp": nextFollowUp,
            "tentClosing": tentClosing,
            "id": prefs.getInt("id"),
            "quantity": quantity,
            "specified": specified,
            "value": value,
            "consultant": consultant,
            "city": city,
            "province": province,
            "department": department,
            "assignedTo": assignedTo,
            "contractor": contractor,
            "distributor": distributor
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addOrder(
      customerId,
      productId,
      quantity,
      unitPrice,
      discount,
      shippingFee,
      taxes,
      paymentDate,
      paymentType,
      taxRate,
      taxStatus,
      notes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.newOrder,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "employeeId": prefs.getInt("id"),
            "customerId": customerId,
            "orderDate": DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(DateTime.now())
                .toString(),
            "productId": productId,
            "quantity": quantity,
            "unitPrice": unitPrice,
            "discount": discount,
            "shippingFee": shippingFee,
            "taxes": taxes,
            "paymentDate": paymentDate,
            "paymentType": paymentType,
            "taxRate": taxRate,
            "taxStatus": (taxStatus == "Taxable" ? 1 : 0),
            "notes": notes
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> addJobTitle(
      jobTitle, department, hourlyRate, multiplier) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.addJobTitle,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "jobTitle": jobTitle,
            "department": department,
            "hourlyRate": hourlyRate,
            "multiplier": multiplier
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updateClient(
      companyId,
      salutation,
      clientId,
      firstName,
      lastName,
      emailPersonal,
      emailWork,
      jobTitle,
      businessPhone,
      mobilePhone,
      address,
      city,
      province,
      zip,
      country,
      notes,
      attachments,
      birthday,
      anniversary,
      sports,
      activities,
      beverage,
      alcohol,
      travelDestination,
      spouseName,
      children,
      tvShow,
      movies,
      actor,
      dislikes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.updateCustomer,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "clientId": clientId,
            "companyId": companyId,
            "salutation": salutation,
            "firstName": firstName,
            "lastName": lastName,
            "emailPersonal": emailPersonal,
            "emailWork": emailWork,
            "jobTitle": jobTitle,
            "businessPhone": businessPhone,
            "mobilePhone": mobilePhone,
            "address": address,
            "city": city,
            "province": province,
            "zip": zip,
            "country": country,
            "notes": notes,
            "attachment": attachments,
            "birthday": birthday,
            "anniversary": anniversary,
            "sports": sports,
            "activities": activities,
            "beverage": beverage,
            "alcohol": alcohol,
            "travelDestination": travelDestination,
            "spouseName": spouseName,
            "children": children,
            "tvShow": tvShow,
            "movies": movies,
            "actor": actor,
            "dislikes": dislikes
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updateProject(
      projectId,
      projectName,
      dueDate,
      stage,
      followUpNotes,
      nextFollowUp,
      tentClosing,
      quantity,
      specified,
      value,
      consultant,
      city,
      province,
      department,
      assignedTo,
      contractor,
      distributor) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.updateProject,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "projectId": projectId,
            "projectName": projectName,
            "dueDate": dueDate,
            "stage": stage,
            "followUpNotes": followUpNotes,
            "nextFollowUp": nextFollowUp,
            "tentClosing": tentClosing,
            "quantity": quantity,
            "specified": specified,
            "value": value,
            "consultant": consultant,
            "city": city,
            "province": province,
            "department": department,
            "assignedTo": assignedTo,
            "contractor": contractor,
            "distributor": distributor
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updateEmployee(
      id,
      department,
      salutation,
      firstName,
      lastName,
      emailWork,
      emailPersonal,
      directManagerId,
      username,
      password,
      jobTitleId,
      joiningDate,
      business,
      mobile,
      address,
      city,
      state,
      zip,
      country,
      expertise,
      resume,
      softwarePrivilege,
      webpage,
      notes,
      attachments,
      proficiency,
      interest,
      cocurricular,
      training,
      birthday,
      anniversary,
      sports,
      activities,
      beverage,
      alcohol,
      travelDestination,
      spouseName,
      children,
      tvShow,
      movies,
      actor,
      dislikes,
      strengths,
      weaknesses,
      socialActiveIndex) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.updateEmployee,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "id": id,
            "department" : department,
            "salutation" : salutation,
            "firstName" : firstName,
            "lastName" : lastName,
            "emailWork" : emailWork,
            "emailPersonal" : emailPersonal,
            "directManagerId" : directManagerId,
            "username" : username,
            "password" : password,
            "jobTitleId" : jobTitleId,
            "joiningDate" : joiningDate,
            "business" : business,
            "mobile" : mobile,
            "address" : address,
            "city" : city,
            "state" : state,
            "zip" : zip,
            "country" : country,
            "expertise" : expertise,
            "resume" : resume,
            "softwarePrivilege" : softwarePrivilege,
            "webpage" : webpage,
            "notes" : notes,
            "attachments" : attachments,
            "proficiency" : proficiency,
            "interest" : interest,
            "cocurricular" : cocurricular,
            "training" : training,
            "birthday" : birthday,
            "anniversary" : anniversary,
            "sports" : sports,
            "activities" : activities,
            "beverage" : beverage,
            "alcohol" : alcohol,
            "travelDestination" : travelDestination,
            "spouseName" : spouseName,
            "children" : children,
            "tvShow" : tvShow,
            "movies" : movies,
            "actor" : actor,
            "dislikes" : dislikes,
            "strengths" : strengths,
            "weaknesses" : weaknesses,
            "socialActiveIndex" : socialActiveIndex
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updateCompany(id, name, category, address, city, province,
      country, businessPhone, fax, email, webpage, notes, attachments) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.post(Constants.updateCompany,
          options: Options(
              headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
          data: {
            "id": id,
            "name": name,
            "category": category,
            "address": address,
            "city": city,
            "province": province,
            "country": country,
            "businessPhone": businessPhone,
            "fax": fax,
            "email": email,
            "webpage": webpage,
            "notes": notes,
            "attachments": attachments
          });

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> suppliersDashboard() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(Constants.suppliersDashboard,
          options: Options(headers: {
            "auth": "Rose ${prefs.getString("auth-token") ?? ""}"
          }));

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getLogisticsDashboard() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(
        Constants.logisticsDashboard,
        options: Options(
            headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
      );

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<dynamic> getSupplierDashboard() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response resp = await _dio.get(
        Constants.suppliersDashboard,
        options: Options(
            headers: {"auth": "Rose ${prefs.getString("auth-token") ?? ""}"}),
      );

      return resp.data;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
