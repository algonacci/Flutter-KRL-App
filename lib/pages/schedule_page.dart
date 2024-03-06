import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:krl_app/model/train_schedule.dart';

class SchedulePage extends StatelessWidget {
  final List<String> stations;

  SchedulePage({super.key, required this.stations});

  final RxString selectedFromStation = RxString('');
  final RxString selectedToStation = RxString('');
  final RxList<TrainSchedule> schedules = RxList<TrainSchedule>();

  @override
  Widget build(BuildContext context) {
    // Ensure that initial values are set for dropdowns
    if (stations.isNotEmpty) {
      selectedFromStation.value = stations.first;
      selectedToStation.value =
          stations.length > 1 ? stations[1] : stations.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Berangkat Dari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedFromStation.value,
              onChanged: (newValue) {
                if (newValue != null) selectedFromStation.value = newValue;
              },
              items: stations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Menuju Ke',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedToStation.value,
              onChanged: (newValue) {
                if (newValue != null) selectedToStation.value = newValue;
              },
              items: stations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchTrainSchedules(selectedFromStation.value);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Lihat Jadwal Kereta'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return ListTile(
                      title: Text('ID Kereta: ${schedule.trainId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dari: ${schedule.dest}'),
                          Text('Menuju: ${schedule.kaName}'),
                          Text('Rute: ${schedule.routeName}'),
                          Text('Waktu Berangkat: ${schedule.timeEst}'),
                          Text('Waktu Sampai: ${schedule.destTime}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchTrainSchedules(String fromStationId) async {
    try {
      List<TrainSchedule> fetchedSchedules =
          await fetchTrainSchedulesFromAPI(fromStationId);

      // Filter schedules based on selected destination station
      fetchedSchedules = fetchedSchedules
          .where((schedule) => schedule.dest == selectedToStation.value)
          .toList();

      schedules.assignAll(fetchedSchedules);
    } catch (e) {
      // Handle error, show snackbar, toast, etc.
      print('Error fetching train schedules: $e');
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
        // Access the "data" key of the response
        List<dynamic> data = response.data['data'];
        List<TrainSchedule> schedules =
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
