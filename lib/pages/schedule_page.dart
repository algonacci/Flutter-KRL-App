import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:krl_app/model/train_schedule.dart';

class SchedulePage extends StatefulWidget {
  final List<String> stations;

  SchedulePage({Key? key, required this.stations}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String selectedFromStation;
  late String selectedToStation;
  late List<TrainSchedule> schedules;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedFromStation =
        widget.stations.isNotEmpty ? widget.stations.first : '';
    selectedToStation =
        widget.stations.length > 1 ? widget.stations[1] : widget.stations.first;
    schedules = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kereta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown(
                'Berangkat Dari', selectedFromStation, widget.stations),
            const SizedBox(height: 20),
            _buildDropdown('Menuju Ke', selectedToStation, widget.stations),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchTrainSchedules(selectedFromStation);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Lihat Jadwal Kereta'),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : (schedules.isNotEmpty
                      ? _buildTrainScheduleCards()
                      : Center(child: Text('Tidak ada jadwal kereta'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, String selectedValue, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  if (label == 'Berangkat Dari') {
                    selectedFromStation = newValue;
                  } else {
                    selectedToStation = newValue;
                  }
                });
              }
            },
            dropdownColor:
                Colors.white, // Memberikan warna latar belakang dropdown
            elevation: 4, // Menambah efek elevasi dropdown
            icon:
                Icon(Icons.arrow_drop_down), // Menambahkan ikon panah ke bawah
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainScheduleCards() {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${schedule.trainId}'),
                SizedBox(height: 8),
                Text('Dari: ${schedule.kaName}'),
                SizedBox(height: 8),
                Text('Rute: ${schedule.routeName}'),
                SizedBox(height: 8),
                Text('Waktu Berangkat: ${schedule.timeEst}'),
                SizedBox(height: 8),
                Text('Waktu Sampai: ${schedule.destTime}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchTrainSchedules(String fromStationId) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<TrainSchedule> fetchedSchedules =
          await fetchTrainSchedulesFromAPI(fromStationId);

      setState(() {
        schedules = fetchedSchedules;
      });
    } catch (e) {
      print('Error fetching train schedules: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load train schedules'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<TrainSchedule>> fetchTrainSchedulesFromAPI(
      String fromStationId) async {
    try {
      var dio = Dio();
      String url = 'https://krl.megalogic.id';
      Response response = await dio.get(
        url,
        queryParameters: {
          'stationid': fromStationId,
          'timefrom': '01:00',
          'timeto': '23:00',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final schedules =
            data.map((dynamic item) => TrainSchedule.fromJson(item)).toList();
        return schedules;
      } else {
        throw Exception('Failed to load train schedules');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load train schedules');
    }
  }
}
