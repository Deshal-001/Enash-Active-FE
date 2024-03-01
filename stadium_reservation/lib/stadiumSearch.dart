import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:stadium_reservation/searchResults.dart';
import 'Court.dart';
import 'Enums/City.dart';
import 'Enums/District.dart';
import 'Stadium.dart';

class StadiumsSearchPage extends StatefulWidget {
  @override
  _StadiumsSearchPageState createState() => _StadiumsSearchPageState();
}

class _StadiumsSearchPageState extends State<StadiumsSearchPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  District? _selectedDistrict;
  City? _selectedCity;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  List<District> districts = [
    District.DISTRICT1,
    District.DISTRICT2,
    District.DISTRICT3,
    District.DISTRICT4,
    District.DISTRICT5,
    District.DISTRICT6,
    District.DISTRICT7,
    District.DISTRICT8,
    District.DISTRICT9,
    District.DISTRICT10,
    District.DISTRICT11,
    District.DISTRICT12,
    District.DISTRICT13,
    District.DISTRICT14,
    District.DISTRICT15,
    District.DISTRICT16,
    District.DISTRICT17,
    District.DISTRICT18,
    District.DISTRICT19,
    District.DISTRICT20,
    District.DISTRICT21,
    District.DISTRICT22,
    District.DISTRICT23,
    District.DISTRICT24,
    District.DISTRICT25,
  ];

  List<City> cities = [
    City.CITY1,
    City.CITY2,
    City.CITY3,
    City.CITY4,
    City.CITY5,
    City.CITY6,
    City.CITY7,
    City.CITY8,
    City.CITY9,
    City.CITY10,
    City.CITY11,
    City.CITY12,
    City.CITY13,
    City.CITY14,
    City.CITY15,
    City.CITY16,
    City.CITY17,
    City.CITY18,
    City.CITY19,
    City.CITY20,
    City.CITY21,
    City.CITY22,
    City.CITY23,
    City.CITY24,
    City.CITY25,
    City.CITY26,
    City.CITY27,
    City.CITY28,
    City.CITY29,
    City.CITY30,
    City.CITY31,
    City.CITY32,
    City.CITY33,
    City.CITY34,
    City.CITY35,
    City.CITY36,
    City.CITY37,
    City.CITY38,
    City.CITY39,
    City.CITY40,
    City.CITY41,
    City.CITY42,
    City.CITY43,
    City.CITY44,
    City.CITY45,
    City.CITY46,
    City.CITY47,
    City.CITY48,
    City.CITY49,
    City.CITY50,
    City.CITY51,
    City.CITY52,
    City.CITY53,
    City.CITY54,
    City.CITY55,
    City.CITY56,
    City.CITY57,
    City.CITY58,
    City.CITY59,
    City.CITY60,
    City.CITY61,
    City.CITY62,
    City.CITY63,
    City.CITY64,
    City.CITY65,
    City.CITY66,
    City.CITY67,
    City.CITY68,
  ];


  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = selectedTime;
          _startTimeController.text = _formatTime(selectedTime);
        } else {
          _selectedEndTime = selectedTime;
          _endTimeController.text = _formatTime(selectedTime);
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    String period = 'AM';
    int hour = time.hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12; // Convert to 12-hour format
    }
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> _fetchNonBookingCourts(String startTime, String endTime, String date, List<String> excludedCourtIds) async {
    final baseUrl = Uri.parse('http://localhost:8080/api/bookings/non-booking-courts');
    final url = Uri.parse('$baseUrl?startTime=$startTime&endTime=$endTime&date=$date');
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> nonBookingCourts = List<String>.from(jsonDecode(response.body));
        return nonBookingCourts;
      } else {
        throw Exception('Failed to load non-booking courts');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Stadium>> _fetchStadiums(List<String> courtIds) async {
    List<Stadium> stadiums = [];

    try {
      List<dynamic> response = await _fetchStadiumDetails(courtIds);
      for (var data in response) {
        Stadium stadium = Stadium(
          name: data['courtName'],
          description: data['description'],
          location: data['location'],
          ordID: data['orgID'],
          hourlyRate: data['hourlyRate'],
          availability: data['availability'],
        );
        stadiums.add(stadium);
      }
    } catch (e) {
      print('Failed to fetch stadium details: $e');
    }

    return stadiums;
  }

  Future<List<dynamic>> _fetchStadiumDetails(List<String> courtIds) async {
    final baseUrl = Uri.parse('http://localhost:8080/api/courts/except?excludedCourtIds=');
    final url = baseUrl.replace(queryParameters: {'excludedCourtIds': courtIds.join(',')});

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch stadium details for court IDs: $courtIds');
      }
    } catch (e) {
      throw Exception('Failed to fetch stadium details: $e');
    }
  }

  void _searchStadiums() async {
    if (_selectedDate == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null ||
        _selectedDistrict == null ||
        _selectedCity == null) {
      _showErrorDialog(context, "All fields must be filled.");
    } else {
      String startTime = _selectedStartTime!.format(context);
      String endTime = _selectedEndTime!.format(context);
      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      try {
        List<String> courtIds = await _fetchNonBookingCourts(startTime, endTime, date, []);
        List<Stadium> searchResults = await _fetchStadiums(courtIds);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StadiumResultsPage(searchResults: searchResults),
          ),
        );
      } catch (e) {
        _showErrorDialog(context, "Failed to fetch non-booking courts: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Nearest Badminton Court'),
      ),
      body: Container(
        color: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField("Date", _dateController, () => _selectDate(context)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildTextFormField("Start Time", _startTimeController, () => _selectTime(context, true)),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: _buildTextFormField("End Time", _endTimeController, () => _selectTime(context, false)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDropdownButton("District", districts, _selectedDistrict, (District? value) {
                setState(() {
                  _selectedDistrict = value;
                });
              }),
              SizedBox(height: 20),
              _buildDropdownButton("City", cities, _selectedCity, (City? value) {
                setState(() {
                  _selectedCity = value;
                });
              }),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _searchStadiums,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton<T>(
      String hintText,
      List<T> items,
      T? value,
      void Function(T?)? onChanged,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<T>(
        hint: Text(hintText),
        value: value,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        style: TextStyle(color: Colors.black),
        onChanged: onChanged,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(_getDisplayText(item)),
          );
        }).toList(),
      ),
    );
  }

  String _getDisplayText<T>(T item) {
    if (item is District) {
      return item.getDisplayName();
    } else if (item is City) {
      return item.getDisplayName();
    } else {
      return '';
    }
  }

  Widget _buildTextFormField(String hintText, TextEditingController controller, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(Icons.calendar_today),
          ),
        ),
        onTap: onTap,
        readOnly: true,
      ),
    );
  }
}
